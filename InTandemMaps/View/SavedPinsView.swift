//
//  SavedPinsView.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 20/10/24.
//

import SwiftUI
import SwiftData
import MapKit

struct SavedPinsView: View {
    @Environment(\.modelContext) private var context
    @Binding var showMenu: Bool
    @Binding var center: MapCameraPosition
    @Query var pins: [Pin]
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pins) { pin in
                        Button(action: {
                            withAnimation {
                                center = .region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: pin.lat, longitude: pin.long), span: MKCoordinateSpan(latitudeDelta: 5, longitudeDelta: 5)))
                            }
                            showMenu = false;
                        }, label: {
                            Text(pin.remark)
                                .font(.headline)
                            Text(pin.address)
                                .font(.subheadline)
                        })
                            
                    }
                }
                Button(action: {
                    for pin in pins {
                        context.delete(pin)
                        try? context.save()
                    }
                }, label: {
                    Text("Delete All")
                })
            }
            .navigationTitle("Saved Pins")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SavedPinsView(showMenu: .constant(true), center: .constant(.region(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 40), span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)))))
}
