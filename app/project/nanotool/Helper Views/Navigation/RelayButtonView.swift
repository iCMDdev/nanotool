//
//  RelayButtonView.swift | Relay View displayed on the Dashboard, used as a button
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct RelayCardView: View {
    @Binding var name: String
    @Binding var value: Bool
    var body: some View {
        VStack {
            Spacer()
            Text("nanotool")
                .font(.footnote)
            Text(name)
                .bold()
            Spacer()
            Circle()
                .frame(width: 10, height: 10)
                .foregroundColor(value ? .green : .gray)
            ZStack {
                HStack {
                    Text(value ? "On" : "Off")
                        .font(.title)
                        .bold()
                }
                .frame(maxWidth: .infinity)
            }
            HStack {
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.black)
        .background(.linearGradient(Gradient(colors: [Color(red: 0.88, green: 0.88, blue: 0.90), Color(red: 0.80, green: 0.80, blue: 0.85)]), startPoint: .topTrailing, endPoint: .bottomLeading))
    }
}
