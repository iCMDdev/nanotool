//
//  TaskConditionView.swift | View used to display an automation's condition
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct RelayConditionView: View {
    @State var id = 0
    @Binding var valueInt: Int
    @Binding var valueSky: Int
    @Binding var minutes: Int
    @Binding var sensor: Int
    @Binding var comparison: Int
    @Binding var turnOn: Int
    @Binding var relay: Int
    
    var body: some View {
        VStack {
            HStack {
                Text("Condition \(id+1)")
                    .font(.title2)
                    .bold()
                Spacer()
                Button {
                    //print(id)
                    automations.conditions.remove(at: id)
                    automations.shiftConditions(startingWith: id)
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            HStack {
                Text("If")
                Picker(selection: $sensor, label: Text("sensor")) {
                    Text("Temperature").tag(1)
                    Text("Humidity").tag(2)
                    Text("Wind").tag(3)
                    Text("Sky").tag(4)
                    Text("Pressure").tag(5)
                    Text("Rainfall").tag(6)
                }
                .onChange(of: sensor) { _ in
                    automations.conditions[id].sensor = sensor
                }
                Text("is")
                Picker(selection: $comparison, label: Text("comparison sign")) {
                    if sensor != 4 {
                        Text("<").tag(1)
                        Text("<=").tag(2)
                        Text("=").tag(3)
                        Text("not =").tag(4)
                        Text(">").tag(5)
                        Text(">=").tag(6)
                    } else {
                        Text("=").tag(3)
                        Text("not =").tag(4)
                    }
                }
                .onChange(of: comparison) { _ in
                    automations.conditions[id].comparison = comparison
                }
            }
            .padding(.horizontal, 5)
            HStack {
                if sensor != 4 {
                    Stepper(value: $valueInt) {
                        Text("\(valueInt)")
                            .foregroundColor(.blue)
                            .padding(.leading)
                            .padding(.trailing, -10)
                    }
                    .onChange(of: valueInt) { _ in
                        automations.conditions[id].value = valueInt
                    }
                    .frame(width: 140)
                    .background(.ultraThinMaterial)
                    .cornerRadius(8)
                } else {
                    Picker(selection: $valueSky, label: Text("sky condition")) {
                        Text("Clear").tag(1)
                        Text("Cloudy").tag(2)
                        Text("Night").tag(3)
                    }
                    .onChange(of: valueSky) { _ in
                        automations.conditions[id].value = valueSky
                    }
                }
            }
            .padding(.horizontal, 5)
            HStack {
                Text("For")
                Stepper(value: $minutes) {
                    Text("\(minutes)")
                        .foregroundColor(.blue)
                        .padding(.leading)
                        .padding(.trailing, -10)
                }
                .onChange(of: minutes) { _ in
                    automations.conditions[id].minutes = minutes
                }
                .frame(width: 140)
                .background(.ultraThinMaterial)
                .cornerRadius(8)
                Text("minutes")
            }
            .padding(.horizontal, 5)
            HStack {
                Text("Then turn")
                Picker(selection: $turnOn, label: Text("on / off")) {
                    Text("Off").tag(0)
                    Text("On").tag(1)
                }
                .onChange(of: turnOn) { _ in
                    automations.conditions[id].turnOn = turnOn
                }
                
                Picker(selection: $relay, label: Text("relay")) {
                    Text("Relay 1").tag(1)
                    Text("Relay 2").tag(2)
                    Text("Relay 3").tag(3)
                    Text("Relay 4").tag(4)
                }
                .onChange(of: relay) { _ in
                    automations.conditions[id].relayID = relay
                }
            }
            .padding(.horizontal, 5)
            .padding(.bottom)
        }
    }
}
