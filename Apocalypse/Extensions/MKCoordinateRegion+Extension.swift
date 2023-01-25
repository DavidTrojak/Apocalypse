//
//  MKCoordinateRegion+Extension.swift
//  Apocalypse
//
//  Created by David Trojak on 11.01.2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    
    var maxLongitude: CLLocationDegrees {
        center.longitude + span.longitudeDelta / 2
    }

    var minLongitude: CLLocationDegrees {
        center.longitude - span.longitudeDelta / 2
    }

    var maxLatitude: CLLocationDegrees {
        center.latitude + span.latitudeDelta / 2
    }

    var minLatitude: CLLocationDegrees {
        center.latitude - span.latitudeDelta / 2
    }

    func contains(_ loc: MLocation) -> Bool {
        maxLongitude >= loc.longitude && minLongitude <= loc.longitude && maxLatitude >= loc.latitude && minLatitude <= loc.latitude
    }
    
    public static func == (first: MKCoordinateRegion, second: MKCoordinateRegion) -> Bool {
        return first.center == second.center
    }
 }
