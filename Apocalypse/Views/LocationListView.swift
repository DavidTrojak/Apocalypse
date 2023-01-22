//
//  LocationListView.swift
//  Apocalypse
//
//  Created by David Trojak on 21.01.2023.
//

import SwiftUI
import CoreLocation
import Foundation

struct LocationListView: View {
    
    @AppStorage("LocationOrder")
    var locationOrderToUserLocation: Bool = false
    
    let locations: [MLocation]
    let userLocation: CLLocationCoordinate2D?
    
    var distanceLocation: CLLocation?
    
    let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .abbreviated,
        locale: Locale(identifier: "cs_CZ"),
        usage: .general,
        numberFormatStyle: .number
    )
    
    init (locations: [MLocation], userLocation: CLLocationCoordinate2D?) {
        self.userLocation = userLocation
        if let userLoc = self.userLocation {
            let distanceLocation = CLLocation(latitude: userLoc.latitude,
                                     longitude: userLoc.longitude)
            self.distanceLocation = distanceLocation
            
            self.locations = locations.sorted(by: {
                $0.location.distance(from: distanceLocation) < $1.location.distance(from: distanceLocation)
            })
        } else {
            self.locations = locations
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(locations) { loc in
                    VStack {
                        HStack {
                            Text("Name: \(loc.name)").font(.title2).bold().padding(5)
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("{\(loc.nametype)}").font(.footnote)
                                if let calcDistance = self.distanceLocation {
                                    let distance = Measurement(value: loc.location.distance(from: calcDistance), unit: UnitLength.meters)
                                    Text(" [\(distance.formatted(formatStyle))]").font(.footnote)
                                }
                            }.padding(5)
                        }
                        HStack {
                            Text("Pos: \(loc.latitude, specifier: "%.4f"), \(loc.longitude, specifier: "%.4f")")
                            Text("Year: \(String(loc.year))")
                        }
                        HStack {
                            Text("Mass: \(loc.getMass())")
                            Text("Fall: \(loc.fall)")
                            Text("Recclass: \(loc.recclass)")
                        }
                    }
                }
            }
        }
        .navigationTitle("Locations")
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView(locations: MLocation.preview,
                         userLocation: LocationMapModel.defaultCoordinate)
    }
}
