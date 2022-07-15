//
//  AutomatedTasksView.swift
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

// This view is used to display and edit the weather station's automations.
struct AutomatedTasksView: View {
    @EnvironmentObject var nanotool: NanotoolModel
    @Binding var isPresented: Bool
    @ObservedObject var automationsUI = automations
    var body: some View {
        VStack {
            HStack {
                Image("nanotoolAuto")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 30, height: 30)
                    .cornerRadius(8)
                    .shadow(radius: 15)
                Text("Automated tasks")
                    .font(.title2)
                    .bold()
                Spacer()
                Button {
                    // upload tasks
                    nanotool.setAutomatedTasks()
                } label: {
                    Image(systemName: "square.and.arrow.up.fill")
                        .imageScale(.large)
                }
                Button {
                    automationsUI.conditions.append(Automations.Condition(id: automationsUI.conditions.endIndex, sensor: 1, comparison: 3, minutes: 10, value: 10))
                } label: {
                    Image(systemName: "plus")
                        .imageScale(.large)
                }
                Button {
                    isPresented = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.gray)
                }
            }
            .padding()
            ScrollView {
                ForEach(0..<automationsUI.conditions.endIndex, id: \.self) { id in
                    RelayConditionView(id: id, valueInt: $automationsUI.conditions[id].value, valueSky: $automationsUI.conditions[id].value, minutes: $automationsUI.conditions[id].minutes, sensor: $automationsUI.conditions[id].sensor, comparison: $automationsUI.conditions[id].comparison, turnOn: $automationsUI.conditions[id].turnOn, relay: $automationsUI.conditions[id].relayID)
                        .background(.ultraThickMaterial)
                        .cornerRadius(20)
                        .padding(.horizontal)
                }
            }
        }
    }
}

