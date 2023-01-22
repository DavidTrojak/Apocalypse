//
//  DetailLocationView.swift
//  Apocalypse
//
//  Created by David Trojak on 09.01.2023.
//

import SwiftUI

struct DetailLocationView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var place: MLocation?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(Color.black)
                        .padding(20)
                        .scaleEffect(2.0)
                }.padding([.trailing, .bottom], 20)
            }
            if let p = self.place {
                Text("Selected place:").padding(20)
                Text("Name: \(p.name)")
                Text("Position: \(p.latitude), \(p.longitude)")
                Text("Year: \(p.year)")
                Text("Mass: \(p.getMass())")
                Text("Fall: \(p.fall)")
                Text("Recclass: \(p.recclass)")
            } else {
                Text("No place selected!")
            }
            Spacer()
            
        }.padding(20)
    }
}

struct DetailLocationView_Previews: PreviewProvider {
    static var previews: some View {
        DetailLocationView(place: MLocation.preview.first)
    }
}
