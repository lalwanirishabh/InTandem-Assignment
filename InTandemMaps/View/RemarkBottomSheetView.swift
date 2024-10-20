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
    @State var remarks: String = ""
    var body: some View {
        NavigationView {
            VStack {
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
                Button {
                    let pin = Pin(lat: lat, long: long, remark: remarks)
                    context.insert(pin)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete")
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
    }
}

#Preview {
    RemarkBottomSheetView(lat: 0.0, long: 0.0)
}
