//
//  EditPinBottomSheet.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 19/10/24.
//

import SwiftUI

struct EditPinBottomSheet: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.modelContext) private var context
    @Bindable var pin: Pin
    @State var remark: String = ""
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your remarks", text: $remark)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .padding(.horizontal)
                Button {
                    pin.remark = remark
                    context.insert(pin)
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Save")
                }
                Button {
                    context.delete(pin)
                    try? context.save()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text("Delete")
                }
            }
            .navigationBarTitle("Update Pin", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .foregroundColor(.blue)
            })
        }
        .onAppear {
            print("remark in edit view is \(pin.remark)")
            pin.remark = remark
        }
    }
}
