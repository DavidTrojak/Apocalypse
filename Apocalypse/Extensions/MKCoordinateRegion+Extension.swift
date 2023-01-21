//
//  MKCoordinateRegion+Extension.swift
//  Apocalypse
//
//  Created by David Trojak on 11.01.2023.
//

import Foundation
import MapKit

extension MKCoordinateRegion: Equatable {
    
    public static func == (first: MKCoordinateRegion, second: MKCoordinateRegion) -> Bool {
        return first.center == second.center
    }
 }
