//
//  CLLocationCoordinate2D+Extension.swift
//  Apocalypse
//
//  Created by David Trojak on 10.01.2023.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D: Equatable {
    
    public static func ==(first: CLLocationCoordinate2D, second: CLLocationCoordinate2D) -> Bool {
        let first = CLLocation(latitude: first.latitude, longitude: first.longitude)
        let second = CLLocation(latitude: second.latitude, longitude: second.longitude)
        return first.distance(from: second) < 100000
    }
}
