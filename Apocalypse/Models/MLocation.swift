//
//  MLocation.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation
import MapKit

class MLocation: Identifiable {
    
    let formatStyle = Measurement<UnitMass>.FormatStyle(
        width: .abbreviated,
        locale: Locale(identifier: "cs_CZ")
    )
    
    var id: UUID
    
    var extId: UInt64
    var name: String
    var nametype: String
    var recclass: String
    var mass: Double
    var fall: String
    var year: Int
    var latitude: Double
    var longitude: Double
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
    
    init(id: UUID, extId: UInt64, name: String, nametype: String, recclass: String, mass: Double, fall: String, year: Int, latitude: Double, longitude: Double) {
        self.id = id
        self.extId = extId
        self.name = name
        self.nametype = nametype
        self.recclass = recclass
        self.mass = mass
        self.fall = fall
        self.year = year
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(from: NASAData, df: DateFormatter) {
        id = UUID()
        extId = UInt64(from.id!) ?? 0
        name = from.name ?? "-"
        nametype = from.nametype!
        recclass = from.recclass!
        mass = Double(from.mass ?? "0.0")!
        fall = from.fall ?? ""
        
        let date = df.date(from: from.year ?? "1930-01-01T00:00:00.000") ?? Date()
        year = date.get(.year)
        
        if let lat = from.geoLoc?.latitude, let lon = from.geoLoc?.longitude {
            latitude = Double(lat)!
            longitude = Double(lon)!
        } else {
            latitude = Double(from.reclat ?? "0.0")!
            longitude = Double(from.reclon ?? "0.0")!
        }
    }
    
    init(_ from: NASALocation) {
        id = UUID()
        extId = UInt64(from.id)
        name = from.name ?? "-"
        nametype = from.nameType!
        recclass = from.recclass!
        mass = from.mass
        fall = from.fall!
        year = Int(from.year)
        
        latitude = from.latitude
        longitude = from.longitude
    }
    
    func getMass() -> String {
        let w = Measurement(value: self.mass, unit: UnitMass.grams)
        return w.formatted(formatStyle)
    }

    static let preview = [
        MLocation(id: UUID(),
                  extId: 10866,
                  name: "Gasseltepaoua",
                  nametype: "Valid",
                  recclass: "H5",
                  mass: 0.012999999999999999,
                  fall: "Fell",
                  year: 2000,
                  latitude: 14.15083,
                  longitude: -2.04167),
        MLocation(id: UUID(),
                  extId: 16742,
                  name: "Morávka",
                  nametype: "Valid",
                  recclass: "H5",
                  mass: 633.0,
                  fall: "Fell",
                  year: 2000,
                  latitude: 49.6,
                  longitude: 18.53333),
        MLocation(id: UUID(),
                  extId: 23782,
                  name: "Tagish Lake",
                  nametype: "Valid",
                  recclass: "C2-ung",
                  mass: 10000.0,
                  fall: "Fell",
                  year: 2000,
                  latitude: 59.70444,
                  longitude: -134.20139)
    ]
}
