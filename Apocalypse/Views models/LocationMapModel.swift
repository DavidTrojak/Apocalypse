//
//  LocationMapModel.swift
//  Apocalypse
//
//  Created by David Trojak on 12.01.2023.
//

import Foundation
import MapKit

class LocationMapModel:  NSObject, CLLocationManagerDelegate  {
    
    static let defaultCoordinate = CLLocationCoordinate2D(latitude: 49.5, longitude: 15.1)
    
    let locationManager = CLLocationManager()
    
    var model: MainViewModel?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func setModel(_ model: MainViewModel) {
        self.model = model
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.model!.userLocation = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle failure to get a user’s location
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
            case .restricted,.denied,.notDetermined:
                print("Current location is not available")
            default:
                locationManager.requestLocation()
        }
    }
    
}
