//
//  MLocation.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation
import MapKit

class MLocation: Identifiable {
    
    var id: UUID
    
    var extId: UInt64
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
    
    init(from: NASAData, df: DateFormatter) {
        id = UUID()
        extId = UInt64(from.id!) ?? 0
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
        nametype = from.nameType!
        recclass = from.recclass!
        mass = from.mass
        fall = from.fall!
        year = Int(from.year)
        
        latitude = from.latitude
        longitude = from.longitude
    }

}
