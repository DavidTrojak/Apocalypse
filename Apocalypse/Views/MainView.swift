//
//  ContentView.swift
//  Apocalypse
//
//  Created by David Trojak on 08.01.2023.
//

import SwiftUI
import MapKit
import CoreLocation
import CoreData

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @StateObject
    private var mainVM = MainViewModel()
    
    @State
    private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 49.5, longitude: 15.1),
                                    span: MKCoordinateSpan(latitudeDelta: 10,
                                                           longitudeDelta: 10))
    
    @State
    private var sheetShown = false
    
    @State
    private var showMenu = false
    
    @State
    private var showLocBtn = false
    
    @State
    var selectedLocation: Int?
    
    @State
    var selectedLocationUUID: UUID?
    
    @State
    private var degreesMenuBtn = 0.0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    // TODO - Publishing changes from within view updates is not allowed, this will cause undefined behavior.
                    Map (coordinateRegion: $region, annotationItems: mainVM.locations.filter { $0.year >= mainVM.selectedYear } ) { place in
                        MapAnnotation(coordinate: place.coordinate) {
                            Image(systemName: "target")
                                .scaleEffect(selectedLocationUUID == place.id ? 2.5 : 0.7)
                                .foregroundColor(selectedLocationUUID == place.id ? Color.red : Color.orange)
                                .onTapGesture {
                                    let index: Int = mainVM.locations.firstIndex(where: {$0.id == place.id})!
                                    self.selectedLocation = index
                                    self.selectedLocationUUID = place.id
                                    self.sheetShown.toggle()
                                }
                        }
                    }.onChange(of: region) { region in
                        if let userLoc = mainVM.userLocation {
                            showLocBtn = !(userLoc == region.center)
                        }
                    }
                }
                .edgesIgnoringSafeArea(.bottom)
                .toolbar() {
                    Button {
                        withAnimation {
                            self.degreesMenuBtn += 90
                            showMenu.toggle()
                        }
                    } label: {
                        Label("Side Menu", systemImage: "line.3.horizontal")
                            .foregroundColor(Color.primary)
                            .padding(15)
                            .rotationEffect(.degrees(degreesMenuBtn))
                    }
                }
                .sheet(isPresented: $sheetShown) {
                    DetailLocationView(place: mainVM.locations[selectedLocation ?? 0])
                }
                SideMenuView(showMenu: self.$showMenu,
                             degreesMenuBtn: self.$degreesMenuBtn,
                             selectedYear: mainVM.$selectedYear,
                             locations: mainVM.locations)
                VStack(alignment: .trailing) {
                    Spacer()
                    
                    Button {
                        showLocBtn.toggle()
                        region.center.latitude = mainVM.userLocation!.latitude
                        region.center.longitude = mainVM.userLocation!.longitude
                    } label: {
                        Image(systemName: "mappin.circle.fill")
                            .scaleEffect(showLocBtn ? 1.9 : 0)
                            .foregroundColor(Color.primary)
                            .opacity(showLocBtn ? 1 : 0)
                            .padding(25)
                            .animation(.easeOut, value: showLocBtn)
                            
                    }
                }.disabled(!showLocBtn)
                    .accessibilityIdentifier("User location btn")
            }
        }.navigationTitle(Text("Meteor map"))
        .navigationBarTitleDisplayMode(.inline)
        .task {
            DataService.shared.loadData() { (locs, res) in
                DispatchQueue.main.async {
                    switch res {
                    case .error:
                        print("error")
                    case .part:
                        mainVM.locations = locs
                        Task {
                            DataService.shared.loadDataSecond() { locs in
                                mainVM.locations.append(contentsOf: locs)
                            }
                        }
                    case .refresh:
                        mainVM.locations = locs
                        Task {
                            await DataService.shared.loadDataRefresh()
                        }
                    case .full:
                        mainVM.locations = locs
                    }
                }
            }
        }.onReceive(NotificationCenter.default.publisher(for: Notification.Name.refreshNotification)) { _ in
            print("Refresh notification arrived")
            DispatchQueue.main.async {
                mainVM.locations = DataService.shared.getLocalData()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
