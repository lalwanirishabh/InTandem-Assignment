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
    @Binding var showRemarksBottomSheetView: Bool
    @State var address: String = ""
    @State var remarks: String = ""
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                Text(address)
                        .font(.headline) // Change font size for better emphasis
                        .padding(.bottom, 8) // Add bottom padding for spacing

                    TextField("Enter your remarks", text: $remarks)
                        .padding()
                        .background(Color.white) // Set background color
                        .cornerRadius(10) // Rounded corners
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Subtle shadow for elevation
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                    
                    Button(action: {
                        let pin = Pin(lat: lat, long: long, remark: remarks, address: address)
                        context.insert(pin)
                        try? context.save()
                        print("Saved pin: \(pin)")
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Save")
                            .fontWeight(.bold) // Make the button text bold
                            .padding() // Add padding for touch targets
                            .frame(maxWidth: .infinity) // Make button full width
                            .background(Color.blue) // Set button background color
                            .foregroundColor(.white) // Set button text color
                            .cornerRadius(10) // Rounded corners for the button
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2) // Subtle shadow for elevation
                    }
                    .padding(.top, 8) // Add top padding to the button

                    Spacer() // Keep the layout responsive
            }
            .padding()
            .navigationBarTitle("Remarks", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showRemarksBottomSheetView = false
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
    RemarkBottomSheetView(lat: 0.0, long: 0.0, showRemarksBottomSheetView: .constant(true))
}
