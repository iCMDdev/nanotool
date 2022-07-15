//
//  SettingsView.swift | View that displays the nanotool settings and information such as CPU Temperature
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var nanotool: NanotoolModel
    @Binding var ip: String
    @Binding var isPresented: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            NavigationView {
                List {
                    Section(content: {
                        HStack {
                            Text("IP")
                            TextField("nanotool.local:5000", text: $ip)
                                .multilineTextAlignment(.trailing)
                        }
                    }, header: {
                        HStack {
                            Image("nanotoolWiFi")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            Text("CONNECTION DETAILS")
                        }
                        .padding(.top)
                    })
                    
                    Section(content: {
                        HStack {
                            Text("Capture interval")
                            TextField("seconds", text: $nanotool.captureInterval)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                        HStack {
                            Text("Save interval")
                            TextField("minutes", text: $nanotool.saveInterval)
                                .multilineTextAlignment(.trailing)
                                .keyboardType(.numberPad)
                        }
                    }, header: {
                        HStack {
                            Image("nanotoolSensors")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            Text("SENSOR DATA")
                        }
                        .padding(.top)
                    }, footer: {
                        Text("Data is captured at a specified interval.\nData can be saved at a different interval.")
                    })
                    
                    Section(content: {
                        HStack {
                            Text("CPU temperature")
                            Spacer()
                            Text("\(nanotool.internalTemperature != nil ? String(nanotool.internalTemperature!) : "") °C")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Up for")
                            Spacer()
                            if nanotool.upTime != nil {
                                Text("\(DateInterval(start: nanotool.upTime!, end: Date()).duration/60, specifier: "%.0f") \(DateInterval(start: nanotool.upTime!, end: Date()).duration/60 != 1 ? "minutes" : "minute")")
                                    .foregroundColor(.gray)
                            }
                        }
                    }, header: {
                        HStack {
                            Image("nanotool")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 25, height: 25)
                                .cornerRadius(8)
                                .shadow(radius: 5)
                            Text("INFO")
                        }
                        .padding(.top)
                    })
                }
                .navigationTitle("Settings")
                .toolbar {
                    Button {
                        isPresented.toggle()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .task {
            nanotool.saveInfo(data: await nanotool.fetchInfo())
        }
    }
}
