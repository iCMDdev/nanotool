//
//  ContentView.swift | Dashboard & navigation
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct ContentView: View {
    @StateObject var nanotool = NanotoolModel()
    @State private var ip: String = "nanotool.local:5000"
    @State private var presentIP = true
    @State private var presentSettings = false
    @State private var presentInfo = false
    
    @Binding var showTitleMsg: Bool
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: true) {
                VStack(alignment: .leading) {
                    HStack {
                        Text(nanotool.connected ? "Connected" : "Disconnected" )
                            .onChange(of: nanotool.connected) { newValue in
                                showTitleMsg = newValue
                            }
                        Circle()
                            .frame(width: 10, height: 10)
                            .foregroundColor(nanotool.connected ? .green : .gray)
                    }
                    HStack {
                        NavigationLink {
                            SensorValueView(sensorName: nanotool.temperatureName, value: $nanotool.temperature, minValue: 0.0, maxValue: 100.0, unit: .constant("°C"), color1: $nanotool.tempColor1, color2: $nanotool.tempColor2, circle: true)
                                .environmentObject(nanotool)
                        } label: {
                            SensorValueCardView(sensorName: nanotool.temperatureName, value: $nanotool.temperature, unit: .constant("°C"), color1: $nanotool.tempColor1, color2: $nanotool.tempColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                        NavigationLink {
                            SensorValueView(sensorName: nanotool.humidityName, value: $nanotool.humidity, minValue: 0.0, maxValue: 100.0, unit: .constant("%"), color1: $nanotool.humidityColor1, color2: $nanotool.humidityColor2, circle: true)
                                .environmentObject(nanotool)
                        } label: {
                            SensorValueCardView(sensorName: nanotool.humidityName, value: $nanotool.humidity, unit: .constant("%"), color1: $nanotool.humidityColor1, color2: $nanotool.humidityColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                    }
                    HStack {
                        NavigationLink {
                            SensorValueView(sensorName: nanotool.windName, value: $nanotool.wind, minValue: 0.0, maxValue: 100, unit: Binding(get: {"km/h\n\(nanotool.windDirection)"}, set: { _, _ in}) , color1: $nanotool.windColor1, color2: $nanotool.windColor2, circle: true)
                                .environmentObject(nanotool)
                        } label: {
                            // /*\n\(nanotool.windDirection)"*/
                            SensorValueCardView(sensorName: nanotool.windName, value: $nanotool.wind, unit: Binding(get: {"km/h\n\(nanotool.windDirection)"}, set: { _, _ in}), color1: $nanotool.windColor1, color2: $nanotool.windColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                        NavigationLink {
                            SensorValueView(sensorName: nanotool.skyName, value: $nanotool.skyInfo, unit: .constant(""), color1: $nanotool.skyColor1, color2: $nanotool.skyColor2, circle: false)
                                .environmentObject(nanotool)
                        } label: {
                            SensorValueCardView(sensorName: nanotool.skyName, value: $nanotool.skyInfo, unit: .constant(""), color1: $nanotool.skyColor1, color2: $nanotool.skyColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                    }
                    HStack {
                        NavigationLink {
                            SensorValueView(sensorName: "Pressure", value: $nanotool.pressure, minValue: 0.0, maxValue: 1100, unit: .constant("hPa"), color1: $nanotool.pressureColor1, color2: $nanotool.pressureColor2, circle: true)
                                .environmentObject(nanotool)
                        } label: {
                            // /*\n\(nanotool.windDirection)"*/
                            SensorValueCardView(sensorName: "Pressure", value: $nanotool.pressure, unit: .constant("hPa"), color1: $nanotool.pressureColor1, color2: $nanotool.pressureColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                        NavigationLink {
                            SensorValueView(sensorName: "Rainfall", value: $nanotool.rainfall, unit: .constant("mm"), color1: $nanotool.rainfallColor1, color2: $nanotool.rainfallColor2, circle: false)
                                .environmentObject(nanotool)
                        } label: {
                            SensorValueCardView(sensorName: "Rainfall", value: $nanotool.rainfall, unit: .constant("mm"), color1: $nanotool.rainfallColor1, color2: $nanotool.rainfallColor2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                    }
                    HStack {
                        NavigationLink {
                            RelayView(name: $nanotool.relay1Name, relayOn: $nanotool.relay1)
                        } label: {
                            RelayCardView(name: $nanotool.relay1Name, value: $nanotool.relay1)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                        NavigationLink {
                            RelayView(name: $nanotool.relay2Name, relayOn: $nanotool.relay2)
                        } label: {
                            RelayCardView(name: $nanotool.relay2Name, value: $nanotool.relay2)
                                .cornerRadius(25)
                                .padding(1)
                        }
                    }
                    HStack {
                        NavigationLink {
                            RelayView(name: $nanotool.relay3Name, relayOn: $nanotool.relay3)
                        } label: {
                            RelayCardView(name: $nanotool.relay3Name, value: $nanotool.relay3)
                                .cornerRadius(25)
                                .padding(1)
                        }
                        
                        NavigationLink {
                            RelayView(name: $nanotool.relay4Name, relayOn: $nanotool.relay4)
                        } label: {
                            RelayCardView(name: $nanotool.relay4Name, value: $nanotool.relay4)
                                .cornerRadius(25)
                                .padding(1)
                        }
                    }
                }
                .navigationTitle("Dashboard")
                .toolbar(content: {
                    HStack {
                        Button {
                            presentInfo = true
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                        }
                        Button {
                            presentSettings = true
                        } label: {
                            Image(systemName: "play.circle")
                                .foregroundColor(.blue)
                        }
                        Button {
                            presentIP = true
                        } label: {
                            Image(systemName: "slider.horizontal.3")
                                .foregroundColor(.blue)
                        }
                    }
                    
                })
                .padding()
            }
        }
        .sheet(isPresented: $presentIP, onDismiss: {
            nanotool.ip = ip
            Task {
                nanotool.saveFetchedData(data: await nanotool.fetchData())
                nanotool.saveFetchedAutomatedTasks(data: await nanotool.getAutomatedTasks())
            }
        }, content: {
            SettingsView(nanotool: nanotool, ip: $ip, isPresented: $presentIP)
        })
        .sheet(isPresented: $presentSettings, content: {
            AutomatedTasksView(isPresented: $presentSettings)
                .onAppear() {
                    Task {
                        await nanotool.getAutomatedTasks()
                    }
                }
                .environmentObject(nanotool)
        })
        .sheet(isPresented: $presentInfo, content: {
            ZStack(alignment: .topTrailing) {
                Button {
                    presentInfo.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .imageScale(.large)
                }
                .padding()
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("nanotoolApp")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .cornerRadius(15)
                        Text("  nanotool App")
                            .font(.title2)
                            .bold()
                        Spacer()
                    }
                    .shadow(radius: 15)
                    Text("A new way to discover weather.")
                        .padding(.top,3)
                        .foregroundColor(.gray)
                    Text("v1.0")
                        .foregroundColor(.gray)
                    HStack {
                        Image("nanotool")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(8)
                            .shadow(radius: 15)
                        Image("nanotoolAPI")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(8)
                            .shadow(radius: 15)
                        Image("nanotoolSensors")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(8)
                            .shadow(radius: 15)
                        Image("nanotoolAuto")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(8)
                            .shadow(radius: 15)
                        Image("nanotoolWiFi")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .cornerRadius(8)
                            .shadow(radius: 5)
                    }
                    .padding(.top,3)
                    Spacer()
                }
                .padding()
            }
        })
        .accentColor(.white)
        .task {
            while true {
                nanotool.saveFetchedData(data: await nanotool.fetchData())
                try? await Task.sleep(nanoseconds: nanotool.timeIntervalSeconds*UInt64(1000000000))
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(showTitleMsg: .constant(true))
    }
}
