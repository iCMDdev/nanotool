//
//  AutomatedTasksModel.swift
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import Foundation

class Automations: ObservableObject {
    enum SensorType {
        case Temperature
        case Humidity
        case Wind
        case Sky
    }
    struct Condition: Identifiable, Decodable {
        var id: Int
        var sensor: Int
        var comparison: Int
        var turnOn: Int = 0
        var minutes: Int
        var value: Int
        var relayID: Int = 1
    }
    
    func shiftConditions(startingWith: Int) {
        for i in startingWith..<conditions.endIndex {
            conditions[i].id=i
        }
    }
    
    @Published var conditions: [Condition] = []
}

let automations = Automations()
