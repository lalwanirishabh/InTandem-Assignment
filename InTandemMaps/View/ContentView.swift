//
//  ContentView.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 19/10/24.
//

import SwiftUI
import SwiftData
import MapKit

@Model
class Pin {
    @Attribute(.unique) var id: UUID
    var lat: Double
    var long: Double
    var remark: String
    
    init(lat: Double, long: Double, remark: String) {
        self.id = UUID()
        self.lat = lat
        self.long = long
        self.remark = remark
    }
    
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @State var showRemarksBottomSheet: Bool = false
    @Query var pins: [Pin]
    var body: some View {
        MapReader { reader in
            Map() {
                ForEach(pins) { pin in
                    Annotation("remarks", coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.long)) {
                        Image(systemName: "pin.fill")
                    }
                }
            }
            .onTapGesture(perform: { screenCoord in
                let location = reader.convert(screenCoord, from: .local)
                if let lat = location?.latitude, let long = location?.longitude {
                    let pin = Pin(lat: lat, long: long, remark: "")
                    context.insert(pin)
                }
            })
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
