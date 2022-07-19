//
//  ChartDataModel.swift | Model used for the chart data fetching and display
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI // no Views are created within this file, but SwiftUI related objects and classes are used.

@MainActor
class ChartData: ObservableObject {
    struct DataSet: Decodable {
        var value: Double
        var maxValue: Double?
        var minValue: Double?
        var date: Date
    }
    
    @Published var needsUpdate: Bool = false
    @Published var temperatureData: [DataSet] = []
    @Published var humidityData: [DataSet] = []
    @Published var windData: [DataSet] = []
    @Published var pressureData: [DataSet] = []
    @Published var rainfallData: [DataSet] = []
    @Published var fetched = true
    @Published var stopLiveFetch: Bool = false
    
    func fetchChart(date: Date, sensor: Sensor, ip: String) async -> [ChartData.DataSet]? {
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
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            struct PartialData: Decodable {
                var value: Double
                var valueMax: Double?
                var valueMin: Double?
                var time: String
            }
            let decodedPartialData = try JSONDecoder().decode([PartialData].self, from: data)
            for dataChunk in (decodedPartialData.compactMap { $0 }) {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
                let stringDate: String = dataChunk.time
                if let date = dateFormatter.date(from: stringDate) {
                    let decodedDataChunk = DataSet(value: dataChunk.value, maxValue: dataChunk.valueMax, minValue: dataChunk.valueMin, date: date)
                    parsedSet.append(decodedDataChunk)
                }
            }
            return parsedSet
        } catch let error {
            print("Failed to load chart data for \(sensor) sensor: \(error.localizedDescription)")
            return nil
        }
    }
    
    func liveFetchDataFromClass(nanotool: NanotoolModel) async -> [ChartData.DataSet]  {
        [ChartData.DataSet(value: Double(nanotool.temperature) ?? 0, date: Date.now), ChartData.DataSet(value: Double(nanotool.humidity) ?? 0, date: Date.now), ChartData.DataSet(value: Double(nanotool.wind) ?? 0, date: Date.now), ChartData.DataSet(value: Double(nanotool.pressure) ?? 0, date: Date.now), ChartData.DataSet(value: Double(nanotool.rainfall) ?? 0, date: Date.now)]
            //try? await Task.sleep(nanoseconds: 15000000000)
    }
    
    func generateArray(sensor: Sensor) -> [Color] {
        // function that generates a gradient array based on the sensor used and maximum and minimum chart data values
        if sensor == .temperature {
            return [colorForValue(value: Int(self.temperatureData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 10, maxValue: 50, sensor: sensor), colorForValue(value: Int(self.temperatureData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 10, maxValue: 40, sensor: sensor)]
        } else if sensor == .humidity {
            return [colorForValue(value: Int(self.humidityData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor), colorForValue(value: Int(self.humidityData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor)]
        } else if sensor == .wind {
            return [colorForValue(value: Int(self.windData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 10, sensor: sensor), colorForValue(value: Int(self.windData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 10, sensor: sensor)]
        } else if sensor == .pressure {
            return [colorForValue(value: Int(self.pressureData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 300, maxValue: 1100, sensor: sensor), colorForValue(value: Int(self.pressureData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 300, maxValue: 1100, sensor: sensor)]
        } else if sensor == .rainfall {
            return [colorForValue(value: Int(self.humidityData.min(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor), colorForValue(value: Int(self.humidityData.max(by: { $0.value < $1.value })?.value ?? 0), minValue: 0, maxValue: 100, sensor: sensor)]
        }
        return []
    }
}


func colorForValue(value: Int, minValue: Int, maxValue: Int, sensor: Sensor) -> Color {
    // generates a color for a sensor registered value, based on a maximum and minimum accepted value
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
    // sensor type
    case temperature, humidity, wind, pressure, rainfall
}

enum ChartTime {
    // select chart time display mode (live, realtime chart or day history)
    case live, day
}
