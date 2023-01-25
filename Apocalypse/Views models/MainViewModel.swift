//
//  MainViewModel.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import Foundation
import SwiftUI
import CoreLocation

class MainViewModel: ObservableObject {
    
    @Published
    var locationModel: LocationMapModel
    
    @Published
    var locations = [MLocation]()
    @Published
    var selectedLocationUUID: UUID?
    var selectedLocation: Int?
    
    @AppStorage("MinYear")
    var selectedYear: Int = 2000

    var userLocation: CLLocationCoordinate2D?
    
    init() {
        locationModel = LocationMapModel()
        locationModel.setModel(self)
    }
    
    func getSelectedLocation() -> MLocation {
        return self.locations[selectedLocation ?? 0]
    }
    
    func centerToSelectedLocation(locUUID: UUID) {
        self.selectedLocationUUID = locUUID
        self.selectedLocation = self.locations.firstIndex(where: { $0.id == locUUID})
        let loc = self.getSelectedLocation()
        if !locationModel.region.contains(loc) {
            locationModel.region.center.latitude = loc.latitude
            locationModel.region.center.longitude = loc.longitude
        }
    }
}
