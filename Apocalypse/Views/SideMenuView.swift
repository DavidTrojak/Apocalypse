//
//  SideMenuView.swift
//  Apocalypse
//
//  Created by David Trojak on 09.01.2023.
//

import SwiftUI

struct SideMenuView: View {
    @Binding
    var showMenu: Bool
    
    @Binding
    var degreesMenuBtn: Double
    
    @Binding
    var selectedYear: Int
    
    var locations: [MLocation]
    
    var sideMenuWidth = UIScreen.main.bounds.size.width * 0.4
    var bgClr: Color = Color("MenuColor")
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.black.opacity(0.6))
            .opacity(showMenu ? 1 : 0)
            .animation(.easeInOut.delay(0.2), value: showMenu)
            .onTapGesture {
                withAnimation {
                    showMenu.toggle()
                    degreesMenuBtn += 90
                }
            }
            menu
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var menu: some View {
        HStack(alignment: .top) {
            ZStack(alignment: .top) {
                bgClr
                VStack(alignment: .center, spacing: 25) {
                    Spacer()
                    Text("Total records: \(locations.count)").padding(5)
                    Spacer()
                    Text("Minimal year: ").padding(10)
                    Picker("", selection: $selectedYear) {
                        ForEach(Array(stride(from: 1930, to: 2025, by: 5)), id: \.self) { year in
                                Text(String(year))
                                .bold()
                            }
                        }
                        .pickerStyle(InlinePickerStyle())
                        .padding([.bottom], 50)
                }
            }
            .frame(width: sideMenuWidth)
            .offset(x: showMenu ? 0 : -sideMenuWidth)
            .animation(.default, value: showMenu)
            Spacer()
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(showMenu: .constant(true),
                     degreesMenuBtn: .constant(0),
                     selectedYear: .constant(2000),
                     locations: MLocation.preview)
    }
}
