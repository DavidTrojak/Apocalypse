//
//  MainViewModel.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

class MainViewModel: ObservableObject {
    
    var locatiomModel: LocationMapModel
    
    @Published
    var locations = [MLocation]()
    
    @AppStorage("MinYear")
    var selectedYear: Int = 2000

    var userLocation: CLLocationCoordinate2D?
    
    init() {
        
        locatiomModel = LocationMapModel()
        locatiomModel.setModel(self)
    }
}
