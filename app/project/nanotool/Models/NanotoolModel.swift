//
//  NanotoolModel.swift | Model that asyncronously fetches data, using async / await. Doesn't fetch Chart data.
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import Foundation
import SwiftUI

@MainActor
class NanotoolModel: ObservableObject {
    var ip: String = "nanotool.local:5000"
    var upTime: Date?
    @Published var captureIntervalValue: Int?
    @Published var saveIntervalValue: Int?
    var captureInterval: String {
        get {
            let str = String(captureIntervalValue ?? 0)
            return str
        } set {
            captureIntervalValue = Int(newValue) ?? 0
            Task {
                await setIntervals()
            }
        }
    }
    var saveInterval: String {
        get {
            let str = String(saveIntervalValue ?? 0)
            return str
        } set {
            saveIntervalValue = Int(newValue) ?? 0
            Task {
                await setIntervals()
            }
        }
    }
    
    func setIntervals() async {
        var url = URL(string: "http://\(ip)/saveInterval")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "saveInterval=\(self.saveInterval)".data(using: .utf8)
        _ = try? await URLSession.shared.data(for: request)
        
        url = URL(string: "http://\(ip)/captureInterval")!
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "captureInterval=\(self.captureInterval)".data(using: .utf8)
        _ = try? await URLSession.shared.data(for: request)
    }
    
    @Published var internalTemperature: Double?
    @Published var connected: Bool = false
    @Published var timeIntervalSeconds: UInt64 = 15 /* multiply by 1000000000 for nanoseconds */
    
    func fetchInfo() async -> Data? {
        var data: Data? = nil
        if let url = URL(string: "http://\(ip)/info") {
            do {
                let request = URLRequest(url: url)
                (data, _) = try await URLSession.shared.data(for: request)
            } catch let error {
                print("Failed to load info data: \(error.localizedDescription)")
                if let error = error as? URLError {
                    if (error.code == .timedOut) || (error.code == .cannotFindHost) || (error.code == .notConnectedToInternet) {
                        self.connected = false
                    }
                }
            }
        }
        
        return data
    }
    
    func saveInfo(data: Data?) {
        if data != nil {
            do {
                if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any] {
                    // try to read out a string array
                    
                    if let upTimeString = json["uptime"] as? String {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
                        self.upTime = dateFormatter.date(from: upTimeString) ?? Date()
                    }
                    if let internalTemp = json["temperature"] as? Double {
                        self.internalTemperature = internalTemp
                    }
                    if let interval = json["captureInterval"] as? Int {
                        self.captureInterval = String(interval)
                    }
                    if let interval = json["saveInterval"] as? Int {
                        self.saveInterval = String(interval)
                    }
                }
            } catch let error {
                print("Failed to save info data: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchData() async -> (sensors: Data?, relays: Data?) {
        var sensorData: Data? = nil
        var relayData: Data? = nil
        if var url = URL(string: "http://\(ip)/sensors") {
            do {
                let request = URLRequest(url: url)
                (sensorData, _) = try await URLSession.shared.data(for: request)
            } catch let error {
                print("Failed to load sensor data: \(error.localizedDescription)")
                if let error = error as? URLError {
                    if (error.code == .timedOut) || (error.code == .cannotFindHost) || (error.code == .notConnectedToInternet) {
                        self.connected = false
                    }
                }
            }
            
            url = URL(string: "http://\(ip)/relays")!
            do {
                let request = URLRequest(url: url)
                (relayData, _) = try await URLSession.shared.data(for: request)
            } catch let error {
                print("Failed to load relay data: \(error.localizedDescription)")
                if let error = error as? URLError {
                    if (error.code == .timedOut) || (error.code == .cannotFindHost) || (error.code == .notConnectedToInternet) {
                        self.connected = false
                    }
                }
            }
        }
        return (sensors: sensorData, relays: relayData)
    }
    
    func saveFetchedData(data: (sensors: Data?, relays: Data?)) {
        if let sensorData = data.sensors {
            self.connected = true
            do {
                if let json = try JSONSerialization.jsonObject(with: sensorData, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let names = json["temperature"] as? [String: Any] {
                        if let names2 = names["value"] as? Double {
                            self.temperature = String(format: "%.1f", names2)
                            if Double(self.temperature)!<=10 {
                                self.tempColor1 = .blue
                                self.tempColor2 = .purple
                            } else if Double(self.temperature)!<=20 {
                                self.tempColor1 = .cyan
                                self.tempColor2 = .green
                            } else if Double(self.temperature)!<=25 {
                                self.tempColor1 = .green
                                self.tempColor2 = .yellow
                            } else if Double(self.temperature)!<=30 {
                                self.tempColor1 = .green
                                self.tempColor2 = .orange
                            } else {
                                self.tempColor1 = .orange
                                self.tempColor2 = .pink
                            }
                        }
                    }
                    if let names = json["humidity"] as? [String: Any] {
                        if let names2 = names["value"] as? Int {
                            self.humidity = String(names2)
                            if Int(self.humidity)!<=10 {
                                self.humidityColor1 = .yellow
                                self.humidityColor2 = .green
                            } else if Int(self.humidity)!<=25 {
                                self.humidityColor1 = .green
                                self.humidityColor2 = .cyan
                            } else if Int(self.humidity)!<=50 {
                                self.humidityColor1 = .gray
                                self.humidityColor2 = .blue
                            } else if Int(self.humidity)!<=75 {
                                self.humidityColor1 = .blue
                                self.humidityColor2 = .cyan
                            } else {
                                self.humidityColor1 = .blue
                                self.humidityColor2 = .purple
                            }
                        }
                    }
                    if let names = json["wind"] as? [String: Any] {
                        if let names2 = names["value"] as? Double {
                            self.wind = String(names2)
                        }
                        if let names2 = names["direction"] as? String {
                            self.windDirection = names2
                        }
                    }
                    if let names = json["pressure"] as? [String: Any] {
                        if let names2 = names["value"] as? Double {
                            self.pressure = String(format: "%.1f", names2)
                        }
                    }
                    if let names = json["rain"] as? [String: Any] {
                        if let names2 = names["value"] as? Double {
                            self.rainfall = String(format: "%.1f", names2)
                        }
                    }
                    if let names = json["camera"] as? [String: Any] {
                        if let names2 = names["value"] as? String {
                            self.skyInfo = String(names2)
                        }
                        
                        if let r1 = names["r1"] as? Double {
                            if let g1 = names["g1"] as? Double {
                                if let b1 = names["b1"] as? Double {
                                    self.skyColor1 = Color(red: r1/255.0, green: g1/255.0, blue: b1/255.0, opacity: 1)
                                }
                            }
                        }
                        
                        if let r2 = names["r2"] as? Double {
                            if let g2 = names["g2"] as? Double {
                                if let b2 = names["b2"] as? Double {
                                    self.skyColor2 = Color(red: r2/255.0, green: g2/255.0, blue: b2/255.0, opacity: 1)
                                }
                            }
                        }
                    }
                }
            } catch let error {
                print("Failed to save sensor data: \(error.localizedDescription)")
            }
        }
        
        if let relayData = data.relays {
            do {
                if let json = try JSONSerialization.jsonObject(with: relayData, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let value = json["relay1"] as? Int {
                        self.relay1 = (value == 1)
                    }
                    if let value = json["relay2"] as? Int {
                        self.relay2 = (value == 1)
                    }
                    if let value = json["relay3"] as? Int {
                        self.relay3 = (value == 1)
                    }
                    if let value = json["relay4"] as? Int {
                        self.relay4 = (value == 1)
                    }
                }
            } catch let error {
                print("Failed to save relay data: \(error.localizedDescription)")
            }
        }
    }
    
    func setRelay() {
        let url = URL(string: "http://\(ip)/relays")!
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "relay1=\(relay1val ? "1" : "0")&relay2=\(relay2val ? "1" : "0")&relay3=\(relay3val ? "1" : "0")&relay4=\(relay4val ? "1" : "0")".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let statusCode = json["status"] as? Int {
                        if statusCode != 200 {
                            print("Relay toggle error: status code \(statusCode)")
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
    func getAutomatedTasks() async -> Data? {
        var data: Data? = nil
        let url = URL(string: "http://\(ip)/tasks")!
        let request = URLRequest(url: url)
        do {
            (data, _) = try await URLSession.shared.data(for: request)
        } catch let error {
            print("Failed to load tasks: \(error.localizedDescription)")
        }
        return data
    }
    
    func saveFetchedAutomatedTasks(data: Data?) {
        if data != nil {
            do {
                let tasks = try JSONDecoder().decode([Automations.Condition].self, from: data!)
                automations.conditions.removeAll()
                
                for task in tasks {
                    automations.conditions.append(task)
                }
            } catch let error {
                print("Failed to save tasks: \(error.localizedDescription)")
            }
        }
    }
    
    func setAutomatedTasks() {
        var url = URL(string: "http://\(ip)/remove-tasks")!
        var request = URLRequest(url: url)
        var urlTask = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                // make sure this JSON is in the format we expect
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    // try to read out a string array
                    if let statusCode = json["status"] as? Int {
                        if statusCode != 200 {
                            print("Automated task remove error: status code \(statusCode)")
                        }
                    }
                }
            } catch let error as NSError {
                print("Failed to load: \(error.localizedDescription)")
            }
        }
        urlTask.resume()
        for automatedTask in automations.conditions {
            url = URL(string: "http://\(ip)/set-task")!
            request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = "id=\(automatedTask.id)&sensor=\(automatedTask.sensor)&comparison=\(automatedTask.comparison)&turnOn=\(automatedTask.turnOn)&minutes=\(automatedTask.minutes)&value=\(automatedTask.value)&relayID=\(automatedTask.relayID)".data(using: .utf8)
            urlTask = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        // try to read out a string array
                        if let statusCode = json["status"] as? Int {
                            if statusCode != 200 {
                                print("Automated task upload error: status code \(statusCode)")
                            }
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
            urlTask.resume()
        }
    }
    
    @Published var temperatureName: String = "Temperature"
    @Published var humidityName: String = "Humidity"
    @Published var windName: String = "Wind"
    @Published var skyName: String = "Sky"
    @Published var pressureName: String = "Pressure"
    @Published var temperature: String = "-"
    @Published var humidity: String = "-"
    @Published var wind: String = "-"
    @Published var windDirection : String = "-"
    @Published var skyInfo: String = "-"
    @Published var pressure: String = "-"
    @Published var rainfall: String = "-"
    @Published var relay1Name: String = "Relay 1"
    @Published var relay2Name: String = "Relay 2"
    @Published var relay3Name: String = "Relay 3"
    @Published var relay4Name: String = "Relay 4"
    @Published private var relay1val: Bool = false
    @Published private var relay2val: Bool = false
    @Published private var relay3val: Bool = false
    @Published private var relay4val: Bool = false
    @Published var skyColor1: Color = .cyan
    @Published var skyColor2: Color = .blue
    @Published var tempColor1: Color = .green
    @Published var tempColor2: Color = .yellow
    @Published var humidityColor1: Color = .blue
    @Published var humidityColor2: Color = .purple
    @Published var windColor1: Color = .red
    @Published var windColor2: Color = .indigo
    @Published var pressureColor1: Color = .purple
    @Published var pressureColor2: Color = .indigo
    @Published var rainfallColor1: Color = .indigo
    @Published var rainfallColor2: Color = .cyan
    
    var relay1: Bool {
        get {
            return relay1val
        } set(relayValue) {
            relay1val = relayValue
            setRelay()
        }
    }
    var relay2: Bool {
        get {
            return relay2val
        } set(relayValue) {
            relay2val = relayValue
            setRelay()
        }
    }
    var relay3: Bool {
        get {
            return relay3val
        } set(relayValue) {
            relay3val = relayValue
            setRelay()
        }
    }
    var relay4: Bool {
        get {
            return relay4val
        } set(relayValue) {
            relay4val = relayValue
            setRelay()
        }
    }
}
