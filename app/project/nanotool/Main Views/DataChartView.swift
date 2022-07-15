//
//  DataChartView.swift | view that displays the chart using 
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct DataChart: View {
    @Binding var isPresented: Bool
    @State var sensor: Sensor = .temperature
    @State var chartTime: ChartTime = .day
    @State var day: Date = Date()
    @StateObject private var data = ChartData()
    @EnvironmentObject var nanotool: NanotoolModel
    
    var dataPick: [ChartData.DataSet] {
        switch sensor {
        case .temperature:
            return data.temperatureData
        case .humidity:
            return data.humidityData
        case .wind:
            return data.windData
        case .pressure:
            return data.pressureData
        case .rainfall:
            return data.rainfallData
        }
    }
    
    func averageData() -> Double {
        var sum: Double = 0
        for value in dataPick {
            sum = sum + value.value
        }
        return sum / Double(dataPick.count)
    }
    
    func sumData() -> Double {
        var sum: Double = 0
        for value in dataPick {
            sum = sum + value.value
        }
        return sum
    }
    @State var dataXaxis: [CGFloat] = []
    @State var gradientArray: [Color] = []
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Data chart")
                    .font(.title)
                    .bold()
                Spacer()
                if chartTime == .day {
                    DatePicker("", selection: $day, displayedComponents: [.date])
                        .datePickerStyle(.compact)
                        .onChange(of: day) { newValue in
                            Task {
                                data.fetched = false // shows loading screen (but only if the picked data array is empty)
                                
                                data.temperatureData.removeAll()
                                data.humidityData.removeAll()
                                data.windData.removeAll()
                                data.pressureData.removeAll()
                                data.rainfallData.removeAll()
                                
                                // first fetched sensor is the picked one
                                if sensor == .temperature {
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .temperature, ip: nanotool.ip) {
                                        data.temperatureData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .humidity, ip: nanotool.ip) {
                                        data.humidityData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .wind, ip: nanotool.ip) {
                                        data.windData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .pressure, ip: nanotool.ip) {
                                        data.pressureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .rainfall, ip: nanotool.ip) {
                                        data.rainfallData = fetchedData
                                    }
                                } else if sensor == .humidity {
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .humidity, ip: nanotool.ip) {
                                        data.humidityData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .temperature, ip: nanotool.ip) {
                                        data.temperatureData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .wind, ip: nanotool.ip) {
                                        data.windData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .pressure, ip: nanotool.ip) {
                                        data.pressureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .rainfall, ip: nanotool.ip) {
                                        data.rainfallData = fetchedData
                                    }
                                } else if sensor == .wind {
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .wind, ip: nanotool.ip) {
                                        data.windData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .humidity, ip: nanotool.ip) {
                                        data.humidityData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .temperature, ip: nanotool.ip) {
                                        data.temperatureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .pressure, ip: nanotool.ip) {
                                        data.pressureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .rainfall, ip: nanotool.ip) {
                                        data.rainfallData = fetchedData
                                    }
                                } else if sensor == .pressure {
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .pressure, ip: nanotool.ip) {
                                        data.pressureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .wind, ip: nanotool.ip) {
                                        data.windData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .humidity, ip: nanotool.ip) {
                                        data.humidityData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .temperature, ip: nanotool.ip) {
                                        data.temperatureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .rainfall, ip: nanotool.ip) {
                                        data.rainfallData = fetchedData
                                    }
                                } else if sensor == .rainfall {
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .rainfall, ip: nanotool.ip) {
                                        data.rainfallData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .pressure, ip: nanotool.ip) {
                                        data.pressureData = fetchedData
                                    }
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .wind, ip: nanotool.ip) {
                                        data.windData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .humidity, ip: nanotool.ip) {
                                        data.humidityData = fetchedData
                                    }
                                    
                                    if let fetchedData = await data.fetchChart(date: newValue, sensor: .temperature, ip: nanotool.ip) {
                                        data.temperatureData = fetchedData
                                    }
                                }
                                data.fetched = true // finished fetching data
                            }
                        }
                }
                Picker("Time", selection: $chartTime) {
                    Text("Live").tag(ChartTime.live)
                    Text("Day").tag(ChartTime.day)
                }
                .onChange(of: chartTime) { newValue in
                    if newValue == .live {
                        data.stopLiveFetch = false
                        Task {
                            if data.temperatureData.isEmpty == false {
                                data.temperatureData.removeAll()
                            }
                            if data.humidityData.isEmpty == false {
                                data.humidityData.removeAll()
                            }
                            if data.windData.isEmpty == false {
                                data.windData.removeAll()
                            }
                            if data.pressureData.isEmpty == false {
                                data.pressureData.removeAll()
                            }
                            if data.rainfallData.isEmpty == false {
                                data.rainfallData.removeAll()
                            }
                            while data.stopLiveFetch == false {
                                let dataPoint = await data.liveFetchDataFromClass(nanotool: nanotool)
                                data.temperatureData.append(dataPoint[0])
                                data.humidityData.append(dataPoint[1])
                                data.windData.append(dataPoint[2])
                                data.pressureData.append(dataPoint[3])
                                data.rainfallData.append(dataPoint[4])
                                try? await Task.sleep(nanoseconds: 15000000000)
                            }
                        }
                    } else {
                        data.stopLiveFetch = true
                        Task {
                            data.fetched = false // shows loading screen (but only if the picked data array is empty)
                            
                            data.temperatureData.removeAll()
                            data.humidityData.removeAll()
                            data.windData.removeAll()
                            data.pressureData.removeAll()
                            data.rainfallData.removeAll()
                            
                            // first fetched sensor is the picked one
                            if sensor == .temperature {
                                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                                    data.temperatureData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                                    data.humidityData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                                    data.windData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                                    data.pressureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                                    data.rainfallData = fetchedData
                                }
                            } else if sensor == .humidity {
                                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                                    data.humidityData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                                    data.temperatureData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                                    data.windData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                                    data.pressureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                                    data.rainfallData = fetchedData
                                }
                            } else if sensor == .wind {
                                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                                    data.windData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                                    data.humidityData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                                    data.temperatureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                                    data.pressureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                                    data.rainfallData = fetchedData
                                }
                            } else if sensor == .pressure {
                                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                                    data.pressureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                                    data.windData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                                    data.humidityData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                                    data.temperatureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                                    data.rainfallData = fetchedData
                                }
                            } else if sensor == .rainfall {
                                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                                    data.rainfallData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                                    data.pressureData = fetchedData
                                }
                                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                                    data.windData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                                    data.humidityData = fetchedData
                                }
                                
                                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                                    data.temperatureData = fetchedData
                                }
                            }
                            data.fetched = true // finished fetching data
                        }
                    }
                }
                Button {
                    isPresented.toggle()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            VStack(alignment: .leading) {
                Picker("Sensor", selection: $sensor.animation(.spring())) {
                    Text("Temp").tag(Sensor.temperature)
                    Text("Hum").tag(Sensor.humidity)
                    Text("Wind").tag(Sensor.wind)
                    Text("Pressure").tag(Sensor.pressure)
                    Text("Rain").tag(Sensor.rainfall)
                }
                .pickerStyle(.segmented)
                if dataPick.isEmpty == false {
                    // Chart
                    HStack {
                        Text("\(sensor == .rainfall ? "": "Average") \(sensor == .temperature ? "temperature" : (sensor == .humidity ? "humidity" : (sensor == .wind ? "wind speed" : (sensor == .pressure ? "pressure" : "Total rainfall") ))):")
                            .font(.title3)
                            .bold()
                        Text("\(sensor == .rainfall ? sumData() : averageData(), specifier: "%.0f")\(sensor == .temperature ? "°C" : (sensor == .humidity ? "%" : (sensor == .wind ? " km/h" : (sensor == .pressure ? " hPa" : " mm")) ))")
                            .font(.title3)
                    }
                    .padding(.top)
                    LineChart(style: Binding(get: {LinearGradient(colors: data.generateArray(sensor: sensor), startPoint: .bottom, endPoint: .top)}, set: { Value in}), data: Binding(get: {dataPick}, set: { Va in}))
                    .padding(2)
                    VStack(alignment: .leading) {
                        HStack {
                            Text("Chart analysis")
                                .font(.headline)
                                .bold()
                                .foregroundStyle(.cyan)
                            Spacer()
                        }
                        Divider()
                        Text("During this \(chartTime == .live ? "live chart session" : "day"), the \(sensor == .rainfall ? "total": "average") \(sensor == .temperature ? "temperature" : (sensor == .humidity ? "humidity" : (sensor == .wind ? "wind speed" : (sensor == .pressure ? "pressure" : "rainfall")) )) was \(sensor == .rainfall ? sumData() : averageData(), specifier: "%.0f")\(sensor == .temperature ? "°C" : (sensor == .humidity ? "%" : (sensor == .wind ? " km/h" : (sensor == .pressure ? " hPa" : " mm")) )). The low was \(sensor == .wind ? (dataPick.min(by: {$0.minValue ?? 0 < $1.minValue ?? 0})?.minValue ?? 0) : (dataPick.min(by: {$0.value < $1.value})?.value ?? 0), specifier: "%.0f")\(sensor == .temperature ? "°C" : (sensor == .humidity ? "%" : (sensor == .wind ? " km/h" : (sensor == .pressure ? " hPa" : " mm")) )), and the high was \(sensor == .wind ? (dataPick.max(by: {$0.maxValue ?? 0 < $1.maxValue ?? 0})?.maxValue ?? 0) : (dataPick.max(by: {$0.value < $1.value})?.value ?? 0), specifier: "%.0f")\(sensor == .temperature ? "°C" : (sensor == .humidity ? "%" : (sensor == .wind ? " km/h" : (sensor == .pressure ? " hPa" : " mm")) )).")
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                    .padding(.bottom)
                } else if data.fetched == false {
                    Spacer()
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    Spacer()
                } else {
                    Spacer()
                    HStack {
                        Spacer()
                        Text("No data")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    Spacer()
                }
                HStack {
                    Text("You can download the data used as a .csv (Comma-separated values) file.\nOpen it with a spreadsheet editor.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                    Spacer()
                    Button  {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let dateString: String = dateFormatter.string(from: day)
                        if let url = URL(string: "http://\(nanotool.ip)/csv/\(dateString)") {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        Image(systemName: "arrow.down.to.line.circle")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                    }
                }
            }
        }
        .foregroundColor(colorScheme == .light ? .black : .white)
        .padding()
        .task {
            data.fetched = false // shows loading screen (but only if the picked data array is empty)
            
            data.temperatureData.removeAll()
            data.humidityData.removeAll()
            data.windData.removeAll()
            data.pressureData.removeAll()
            data.rainfallData.removeAll()
            
            // first fetched sensor is the picked one
            if sensor == .temperature {
                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                    data.temperatureData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                    data.humidityData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                    data.windData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                    data.pressureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                    data.rainfallData = fetchedData
                }
            } else if sensor == .humidity {
                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                    data.humidityData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                    data.temperatureData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                    data.windData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                    data.pressureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                    data.rainfallData = fetchedData
                }
            } else if sensor == .wind {
                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                    data.windData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                    data.humidityData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                    data.temperatureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                    data.pressureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                    data.rainfallData = fetchedData
                }
            } else if sensor == .pressure {
                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                    data.pressureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                    data.windData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                    data.humidityData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                    data.temperatureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                    data.rainfallData = fetchedData
                }
            } else if sensor == .rainfall {
                if let fetchedData = await data.fetchChart(date: day, sensor: .rainfall, ip: nanotool.ip) {
                    data.rainfallData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .pressure, ip: nanotool.ip) {
                    data.pressureData = fetchedData
                }
                if let fetchedData = await data.fetchChart(date: day, sensor: .wind, ip: nanotool.ip) {
                    data.windData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .humidity, ip: nanotool.ip) {
                    data.humidityData = fetchedData
                }
                
                if let fetchedData = await data.fetchChart(date: day, sensor: .temperature, ip: nanotool.ip) {
                    data.temperatureData = fetchedData
                }
            }
            data.fetched = true // finished fetching data
        }
    }
}

struct DataGraph_Previews: PreviewProvider {
    static var previews: some View {
        DataChart(isPresented: .constant(true))
            .environmentObject(NanotoolModel())
    }
}
