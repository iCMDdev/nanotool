//
//  DataChartView.swift | Chart view and chart model, optimized for Widgets
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI
import WidgetKit

@MainActor
class ChartData: ObservableObject {
    var ip: String
    var sensor: Sensor
    
    init(sensor: SensorType, ip: String) {
        switch sensor {
        case .temperature:
            self.sensor = .temperature
        case .humidity:
            self.sensor = .humidity
        case .wind:
            self.sensor = .wind
        case .pressure:
            self.sensor = .pressure
        case .rain:
            self.sensor = .rainfall
        case .unknown:
            self.sensor = .temperature
        }
        self.ip = ip
    }
    
    struct DataSet: Decodable {
        var value: Double
        var maxValue: Double?
        var minValue: Double?
        var date: Date
    }
    @Published var sensorData: [DataSet] = []
    
    func fetchChart(date: Date, sensor: Sensor, ip: String, completion: (([DataSet]) -> Void)?) {
        var parsedSet: [DataSet] = []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let fetchTime: String = dateFormatter.string(from: date)
        let sensorStr: String
        if sensor == .temperature {
            sensorStr = "temperature"
        } else if sensor == .humidity {
            sensorStr = "humidity"
        } else if sensor == .wind {
            sensorStr = "wind"
        } else if sensor == .pressure {
            sensorStr = "pressure"
        } else {
            sensorStr = "rain"
        }
        
        let url = URL(string: "http://\(ip)/chart")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "sensor=\(sensorStr)&date=\(fetchTime)".data(using: .utf8)
        print("hello!")
        struct PartialData: Decodable {
            var value: Double
            var valueMax: Double?
            var valueMin: Double?
            var time: String
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: ")
                print(error.localizedDescription)
            }
            if let parseData = data {
                if let decodedPartialData =  try? JSONDecoder().decode([PartialData].self, from: parseData) {
                    for dataChunk in (decodedPartialData.compactMap { $0 }) {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
                        let stringDate: String = dataChunk.time
                        if let date = dateFormatter.date(from: stringDate) {
                            let decodedDataChunk = DataSet(value: dataChunk.value, maxValue: dataChunk.valueMax, minValue: dataChunk.valueMin, date: date)
                            parsedSet.append(decodedDataChunk)
                        }
                    }
                }
            }
            completion!(parsedSet)
        }
        task.resume()
    }
    
    
    func generateArray(sensor: Sensor) -> [Color] {
        if sensor == .temperature {
            return [colorForValue(value: Int(self.sensorData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 10, maxValue: 50, sensor: sensor), colorForValue(value: Int(self.sensorData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 10, maxValue: 40, sensor: sensor)]
        } else if sensor == .humidity {
            return [colorForValue(value: Int(self.sensorData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor), colorForValue(value: Int(self.sensorData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor)]
        } else if sensor == .wind {
            return [colorForValue(value: Int(self.sensorData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 10, sensor: sensor), colorForValue(value: Int(self.sensorData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 10, sensor: sensor)]
        } else if sensor == .pressure {
            return [colorForValue(value: Int(self.sensorData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 300, maxValue: 1100, sensor: sensor), colorForValue(value: Int(self.sensorData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 300, maxValue: 1100, sensor: sensor)]
        } else if sensor == .rainfall {
            return [colorForValue(value: Int(self.sensorData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor), colorForValue(value: Int(self.sensorData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor)]
        }
        return []
    }
}


func colorForValue(value: Int, minValue: Int, maxValue: Int, sensor: Sensor) -> Color {
    if sensor == .temperature {
        if value >= 75 {
            return .red
        }
        else if value >= 50 {
            return .orange
        }
        return Color(red: Double(value-minValue)/Double(maxValue-minValue)*250/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*50/255, green: Double(value-minValue)/Double(maxValue-minValue)*225/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*195/255, blue: Double(value-minValue)/Double(maxValue-minValue)*0/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*255/255)
    } else if sensor == .humidity || sensor == .rainfall {
        return Color(red: Double(value-minValue)/Double(maxValue-minValue)*0/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255, green: Double(value-minValue)/Double(maxValue-minValue)*70/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255, blue: Double(value-minValue)/Double(maxValue-minValue)*255/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255)
    } else if sensor == .pressure {
        return Color(red: Double(value-minValue)/Double(maxValue-minValue)*0/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255, green: Double(value-minValue)/Double(maxValue-minValue)*70/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255, blue: Double(value-minValue)/Double(maxValue-minValue)*255/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*225/255)
    }
    return Color(red: Double(value-minValue)/Double(maxValue-minValue)*255/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*100/255, green: Double(value-minValue)/Double(maxValue-minValue)*0/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*230/255, blue: Double(value-minValue)/Double(maxValue-minValue)*95/255+(1-(Double(value-minValue)/Double(maxValue-minValue)))*250/255)
}


enum Sensor {
    case temperature, humidity, wind, pressure, rainfall
}

struct DataChart: View {
    @State var day: Date = Date()
    @State var data: ChartData
    @State var placeholder: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    @MainActor func averageData() -> Double {
        var sum: Double = 0
        for value in data.sensorData {
            sum = sum + value.value
        }
        return sum / Double(data.sensorData.count)
    }
    
    @MainActor func sumData() -> Double {
        var sum: Double = 0
        for value in data.sensorData {
            sum = sum + value.value
        }
        return sum
    }
    
    var body: some View {
        if data.sensorData.isEmpty == true {
            Text("No data")
                .foregroundColor(.gray)
        } else {
            ZStack(alignment: .topLeading) {
                // Chart
                LineChart(style: Binding(get: {LinearGradient(colors: data.generateArray(sensor: data.sensor), startPoint: .bottom, endPoint: .top)}, set: { Value in}), data: Binding(get: {data.sensorData}, set: { Va in}))
                    .padding(.top, 25)
                    .padding(.horizontal, -5)
                HStack {
                    if data.sensor == .temperature {
                        Text("Temperature")
                            .bold()
                    } else if data.sensor == .humidity {
                        Text("Humidity")
                            .bold()
                    } else if data.sensor == .wind {
                        Text("Wind")
                            .bold()
                    } else if data.sensor == .pressure {
                        Text("Pressure")
                            .bold()
                    } else {
                        Text("Rainfall")
                            .bold()
                    }
                    Spacer()
                    Text("\(data.sensor == .rainfall ? "Total": "Average"): \(data.sensor == .rainfall ? sumData() : averageData(), specifier: "%.0f")\(data.sensor == .temperature ? "°C" : (data.sensor == .humidity ? "%" : (data.sensor == .wind ? " km/h" : (data.sensor == .pressure ? " hPa" : " mm")) ))")
                        .font(.footnote)
                }
            }
            .foregroundColor(colorScheme == .light ? .black : .white)
            .padding(.top)
            .padding(.horizontal)
        }
    }
}


