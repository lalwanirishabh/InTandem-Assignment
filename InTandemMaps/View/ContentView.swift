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
    var address: String
    
    init(lat: Double, long: Double, remark: String, address: String) {
        self.id = UUID()
        self.lat = lat
        self.long = long
        self.remark = remark
        self.address = address
    }
    
}

struct ContentView: View {
    @Environment(\.modelContext) private var context
    @ObservedObject var locationManager = LocationManager.instance
    @State var showRemarksBottomSheet: Bool = false
    @State var showSidebar = false
    @Query var pins: [Pin]
    @State var lat : Double = 0.0
    @State var long : Double = 0.0
    @State private var center: MapCameraPosition = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 28.4595, longitude: 77.0266), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
    var body: some View {
        ZStack {
            MapReader { reader in
                Map(position: $center) {
                    ForEach(pins) { pin in
                        Annotation(pin.remark, coordinate: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.long)) {
                            Image(systemName: "pin.fill")
                        }
                    }
                    if let latitude = locationManager.lat, let longitude = locationManager.long {
                            // Create a current location annotation
                            Annotation("", coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude)) {
                                CurrentLocationPin()
                                    .frame(width: 30, height: 30)
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
            }
            HStack {
                Spacer()
                SavedPinsView(showMenu: $showSidebar, center: $center)
                    .frame(width: UIScreen.main.bounds.width * 0.75)
                    .background(Color.gray)
                    .offset(x: showSidebar ? 0 : UIScreen.main.bounds.width)
                    .animation(.default, value: showSidebar)
            }
        }
        .overlay (
            VStack {
                Button(action: {
                    withAnimation {
                        self.showSidebar.toggle()
                    }
                }) {
                    Image(systemName: showSidebar ? "xmark.circle" : "list.bullet")
                        .font(.system(size: 20))
                        .padding(.all, 10)
                }
                if !showSidebar {
                    Button(action: {
                        if locationManager.authorizationStatus == .authorizedWhenInUse || locationManager.authorizationStatus == .authorizedAlways {
                            if let lat = locationManager.lat, let long = locationManager.long {
                                withAnimation {
                                    self.center = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: lat, longitude: long), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)))
                                }
                            }
                        } else {
                            locationManager.requestAuthorization()
                        }
                    }) {
                        Image(systemName: "location")
                            .font(.system(size: 20))
                            .padding(.all, 10)
                    }
                }
            }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2) // Shadow for elevation
                .padding(.trailing, 20)
                .padding(.top, 10)
            ,
            alignment: .topTrailing
        )
        .onAppear {
            locationManager.requestAuthorization()
        }
        .sheet(isPresented: $showRemarksBottomSheet) {
            RemarkBottomSheetView(lat: lat, long: long, showRemarksBottomSheetView: $showRemarksBottomSheet)
                .presentationDetents([.medium])
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
