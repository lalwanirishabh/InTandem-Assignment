//
//  CurrentLocationPin.swift
//  InTandemMaps
//
//  Created by Rishabh Lalwani on 20/10/24.
//

import SwiftUI

struct CurrentLocationPin: View {
    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.blue, lineWidth: 2)
                .frame(width: 25, height: 25)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 15, height: 15)
        }
    }
}

#Preview {
    CurrentLocationPin()
}
