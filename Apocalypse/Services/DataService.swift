//
//  DataService.swift
//  Apocalypse
//
//  Created by David Trojak on 09.01.2023.
//

import Foundation
import CoreData
import SwiftUI

extension Notification.Name {
    static let refreshNotification = Notification.Name("RefreshNotification")
}

class DataService {
    
    static let shared = DataService()
    
    private let token = "5ICmpQkpEgwGiRqSdVVlEdKTW"
    
    private let viewContext = PersistenceController.shared.container.viewContext
    
    @AppStorage("LastUpdate")
    private var lastUpdate: Date?
    
    @AppStorage("MinYear")
    private var selectedYear: Int = 2000
    
    private var locations: [MLocation]?
    
    private let dateTimeFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        return df
    }()
    
    enum ResultType {
        case full, part, refresh, error
    }
    
    private enum RequestType {
        case full, first, second
    }
    
    func loadData(completion: @escaping (((locs: [MLocation], type: ResultType)) -> Void)) {
        if let locs = self.locations {
            completion((locs: locs, type: .full))
        }
        
        self.locations = self.fetchAllData()
        
        if let d = lastUpdate {
            print("Last update was \(dateTimeFormatter.string(from: d)) (\(d.daysAgo()) days ago)")
        }
        
        if (self.locations!.isEmpty) {
            // no data - first load
            callRequest(run: .first) { result in
                switch result {
                case .success(let locs):
                    self.locations = locs
                    self.saveAllData(locations: locs, delete: false)
                    completion((locs: locs, type: .part))
                case .failure(let error):
                    print(error)
                    completion((locs: [], type: .error))
                }
            }
        } else if (lastUpdate == nil || lastUpdate!.daysAgo() >= 0) {
            //old data
            completion((locs: self.locations ?? [], type: .refresh))
        } else {
            print("Persistet data loaded - size \(self.locations?.count ?? 0)")
            completion((locs: self.locations ?? [], type: .full ))
        }
    }
    
    func loadDataSecond(completion: @escaping (([MLocation]) -> Void)) {
        print("Load the rest of data")
        DispatchQueue.global(qos: .background).async {
            self.callRequest(run: .second) { result in
                switch result {
                case .success(let locs):
                    self.locations?.append(contentsOf: locs)
                    self.saveAllData(locations: locs, delete: false)
                    self.lastUpdate = Date()
                case .failure(let error):
                    debugPrint(error)
                }
                DispatchQueue.main.async {
                    completion(self.locations ?? [])
                }
            }
        }
    }
    
    func loadDataRefresh() async {
        callRequest(run: .full) { result in
            switch result {
            case .success(let locs):
                self.locations = locs
                self.lastUpdate = Date()
                DispatchQueue.main.async {
                    self.saveAllData(locations: locs, delete: true)
                    NotificationCenter.default.post (name: Notification.Name.refreshNotification, object: nil)
                }
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getLocalData() -> [MLocation] {
        return self.locations!
    }
    
    private func callRequest(run: RequestType, completion: @escaping ((Result<[MLocation], Error>) -> Void)) {
        guard var url = URL(string: "http://data.nasa.gov/resource/y77d-th95.json") else {
            print("Invalid URL")
            return
        }
        var query: [URLQueryItem]  = []
        query.append(URLQueryItem(name: "$limit", value: "100000"))
        switch run {
        case .first:
            query.append(URLQueryItem(name: "$where", value: "year >= '\(selectedYear)-01-01'"))
        case .second:
            query.append(URLQueryItem(name: "$where", value: "year < '\(selectedYear)-01-01'"))
        case .full:
            print("Full refresh of data")
        }
        url.append(queryItems: query)
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "X-App-Token")

        URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([NASAData].self, from: data)
                    print("Downloaded \(response.count) objects from NASA api")
                    let result = response.map { MLocation(from: $0, df: self.dateTimeFormatter) }
                    completion(.success(result))
                } catch {
                    print("Error fetching data from API: \(error)")
                    completion(.failure(error))
                }
            }
        }).resume()
    }
    
    private func fetchAllData() -> [MLocation] {
        var locations = [NASALocation]()
        let locationsRequest: NSFetchRequest<NASALocation> = NASALocation.fetchRequest()
        
        do {
            locations = try self.viewContext.fetch(locationsRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
        
        return locations.map({ MLocation($0) })
    }
    
    func saveAllData(locations: [MLocation], delete: Bool) {
        
        if (delete) {
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: NASALocation.fetchRequest())
            do {
                try viewContext.execute(deleteRequest)
            } catch let error as NSError {
                debugPrint(error)
            }
        }
        
        let persistedObjects: [NASALocation] = locations.map { loc in
            let newLoc = NASALocation(context: viewContext)
            newLoc.id = Int64(loc.extId)
            newLoc.nameType = loc.nametype
            newLoc.recclass = loc.recclass
            newLoc.mass = loc.mass
            newLoc.fall = loc.fall
            newLoc.year = Int16(loc.year)
            newLoc.latitude = loc.latitude
            newLoc.longitude = loc.longitude
            return newLoc
        }
        print("Persisted objects count: \(persistedObjects.count)")

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
}
