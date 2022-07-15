//
//  SensorButtonView.swift | Sensor View displayed on the Dashboard, used as a button
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct SensorValueCardView: View {
    @State var sensorName: String
    @Binding var value: String
    @Binding var unit: String
    @Binding var color1: Color
    @Binding var color2: Color
    
    var body: some View {
        VStack {
            Spacer()
            Text("nanotool")
                .font(.footnote)
                .shadow(radius: 5)
            Text(sensorName)
                .bold()
                .shadow(radius: 5)
            Spacer()
            ZStack {
                HStack {
                    Text(value)
                        .font(.title)
                        .bold()
                        .shadow(radius: 5)
                    if unit != "" {
                        Text(unit)
                            .font(.footnote)
                            .shadow(radius: 5)
                    }
                }
                .frame(maxWidth: .infinity)
            }
            HStack {
                Spacer()
            }
            Spacer()
        }
        .foregroundColor(.white)
        .background(.linearGradient(Gradient(colors: [color1, color2]), startPoint: .topTrailing, endPoint: .bottomLeading))
    }
}

