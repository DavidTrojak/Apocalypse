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
    
    @Environment(\.presentationMode)
    var mode: Binding<PresentationMode>
    
    @Binding
    var selectedLocation: Int?
    @Binding
    var selectedLocationUUID: UUID?
    
    var locations: [MLocation]
    var distanceLocation: CLLocation?
    
    let formatStyle = Measurement<UnitLength>.FormatStyle(
        width: .abbreviated,
        locale: Locale(identifier: "cs_CZ"),
        usage: .general,
        numberFormatStyle: .number
    )
    
    init (model: MainViewModel, selectedLocation: Binding<Int?>, selectedLocationUUID: Binding<UUID?>) {
        
        self._selectedLocation = selectedLocation
        self._selectedLocationUUID = selectedLocationUUID
        
        self.locations = model.locations.filter { $0.year >= model.selectedYear }
        
        if let userLoc = model.userLocation {
            let distanceLocation = CLLocation(latitude: userLoc.latitude,
                                     longitude: userLoc.longitude)
            self.distanceLocation = distanceLocation
            
            self.locations.sort(by: {
                    $0.location.distance(from: distanceLocation) < $1.location.distance(from: distanceLocation)
                })
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
                    }.onTapGesture {
                        let index: Int = locations.firstIndex(where: {$0.id == loc.id})!
                        self.selectedLocation = index
                        self.selectedLocationUUID = loc.id
                        // TODO move region to center if tapped area is not included
                        self.mode.wrappedValue.dismiss()
                    }.foregroundColor(self.selectedLocationUUID == loc.id ? Color.red : Color.primary)
                }
            }
        }
        .navigationTitle("Locations")
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView(model: MainViewModel(),
                         selectedLocation: .constant(nil),
                         selectedLocationUUID: .constant(nil))
    }
}
