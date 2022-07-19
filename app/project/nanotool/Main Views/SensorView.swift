//
//  SensorView.swift | View that displays a live sensor value
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct SensorValueView: View {
    @State var showSheet: Bool = false
    @State var sensorName: String
    @Binding var value: String
    @State var minValue: Double?
    @State var maxValue: Double?
    @Binding var unit: String
    @Binding var color1: Color
    @Binding var color2: Color
    @State var circle: Bool
    @EnvironmentObject var nanotool: NanotoolModel // unused here, used in the data chart child view
    
    var body: some View {
        VStack {
            Text("nanotool")
                .font(.footnote)
                .shadow(radius: 5)
            Text(sensorName)
                .font(.title
                .bold())
                .multilineTextAlignment(.center)
                .shadow(radius: 5)
            Spacer()
            ZStack {
                if circle {
                    Circle()
                        .stroke(Color(white: 1, opacity: 0.5), lineWidth: 20)
                        .overlay {
                            SensorValueArc(minValue: minValue ?? 0.0, maxValue: maxValue ?? 0.0, value: Double(value) ?? 0.0)
                                .stroke(.white, lineWidth: 20)
                                .rotationEffect(Angle(degrees: 180))
                        }
                        .padding()
                } else {
                    Circle()
                        .stroke(lineWidth: 0)
                        .padding()
                }
                HStack {
                    Text(value)
                        .font(.system(size: 56.0))
                        .bold()
                        .shadow(radius: 15)
                    Text(unit)
                        .font(.body)
                        .shadow(radius: 15)
                }
            }
            Spacer()
            Button  {
                showSheet.toggle()
            } label: {
                Image(systemName: "chart.xyaxis.line")
                    .imageScale(.large)
                    .shadow(radius: 5)
            }
        }
        .sheet(isPresented: $showSheet) {
            if sensorName == "Temperature" {
                DataChart(isPresented: $showSheet, sensor: .temperature)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            } else if sensorName == "Humidity" {
                DataChart(isPresented: $showSheet, sensor: .humidity)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            } else if sensorName == "Wind" {
                DataChart(isPresented: $showSheet, sensor: .wind)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            } else if sensorName == "Pressure" {
                DataChart(isPresented: $showSheet, sensor: .pressure)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            } else if sensorName == "Rainfall" {
                DataChart(isPresented: $showSheet, sensor: .rainfall)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            } else {
                DataChart(isPresented: $showSheet)
                    .preferredColorScheme(.dark)
                    .environmentObject(nanotool)
            }
        }
        .padding(.top, -20)
        .foregroundColor(.white)
        .padding()
        .background(.linearGradient(Gradient(colors: [color1, color2]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}
