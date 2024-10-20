//
//  SavedPinsView.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 20/10/24.
//

import SwiftUI
import SwiftData

struct SavedPinsView: View {
    @Environment(\.modelContext) private var context
    @Query var pins: [Pin]
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(pins) { pin in
                        Text(pin.remark)
                    }
                }
            }
            .navigationTitle("Saved Pins")
            .toolbarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SavedPinsView()
}
