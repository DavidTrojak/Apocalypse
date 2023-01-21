//
//  Persistence.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSS"
        
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        if let url: URL = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data: Data = try Data(contentsOf: url)
                
                let response = try JSONDecoder().decode([NASAData].self, from: data)
                
                let result = response.map { data in
                    let newLoc = NASALocation(context: viewContext)
                    newLoc.id = Int64(data.id!)!
                    newLoc.nameType = data.nametype!
                    newLoc.recclass = data.recclass!
                    newLoc.mass = Double(data.mass ?? "0.0")!
                    newLoc.fall = data.fall ?? ""
                    
                    let date = df.date(from: data.year ?? "1930-01-01T00:00:00.000") ?? Date()
                    newLoc.year = Int16(date.get(.year))
                    
                    newLoc.latitude = Double(data.reclat ?? "0.0")!
                    newLoc.longitude = Double(data.reclon ?? "0.0")!
                    return newLoc
                }
                
            } catch {
                print(error.localizedDescription)
            }
        } else {
            print("data.json not found")
        }
         
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Apocalypse")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
