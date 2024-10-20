//
//  BottomSheetView.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 19/10/24.
//

import SwiftUI
import SwiftData

struct RemarkBottomSheetView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    let lat: Double
    let long: Double
    @State var address: String?
    @State var remarks: String = ""
    var body: some View {
        NavigationView {
            VStack {
                Text(address ?? "Finding Address")
                TextField("Enter your remarks", text: $remarks)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                Button {
                    let pin = Pin(lat: lat, long: long, remark: remarks)
                    context.insert(pin)
                    try? context.save()
                    print("saved pin \(pin)")
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
            }
            .navigationBarTitle("Remarks", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .foregroundColor(.blue)
            })
        }
        .onAppear {
            LocationManager.instance.getAddressFromCoordinates(latitude: lat, longitude: long) { address in
                self.address = address
            }
        }
    }
}

#Preview {
    RemarkBottomSheetView(lat: 0.0, long: 0.0)
}
