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
    @State var showSidebar = false
//    @State var showEditRemarksBottomSheet: Bool = false
    @Query var pins: [Pin]
    @State var lat : Double = 0.0
    @State var long : Double = 0.0
    @State private var center: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
    var body: some View {
        ZStack {
            MapReader { reader in
                Map(position: $center) {
                    ForEach(pins) { pin in
                        Annotation(pin.remark, coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.long)) {
                            Image(systemName: "pin.fill")
                        }
                    }
                }
                .onTapGesture(perform: { screenCoord in
                    let location = reader.convert(screenCoord, from: .local)
                    if let latitude = location?.latitude, let longitude = location?.longitude {
                        self.lat = latitude
                        self.long = longitude
                        self.showRemarksBottomSheet = true
                    }
                })
                .sheet(isPresented: $showRemarksBottomSheet) {
                    RemarkBottomSheetView(lat: lat, long: long)
                }
            }
            HStack {
                Spacer()
                SavedPinsView(showMenu: $showSidebar, center: $center)
                    .frame(width: UIScreen.main.bounds.width * 0.75) // Sidebar width
                    .background(Color.gray)
                    .offset(x: showSidebar ? 0 : UIScreen.main.bounds.width)
                    .animation(.default, value: showSidebar)
            }
        }
        .overlay (
            Button(action: { self.showSidebar.toggle() }) {
                Image(systemName: showSidebar ? "xmark.circle" : "list.bullet")
            },
            alignment: .topTrailing
        )
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
