//
//  RelayView.swift | View that display a relay toggle button
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct RelayView: View {
    @Binding var name: String
    @Binding var relayOn: Bool
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if colorScheme == .light {
            VStack {
                Text("nanotool")
                    .font(.footnote)
                TextField("Enter relay name", text: $name)
                    .font(.title
                    .bold())
                    .multilineTextAlignment(.center)
                Spacer()
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(relayOn ? .green : .gray)
                Button {
                    relayOn.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.88, green: 0.88, blue: 0.90))
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 20, x: 20, y: 20)
                            .shadow(color: Color.white.opacity(0.7), radius: 20, x: -15, y: -15)
                        HStack {
                            Text("\(relayOn ? "On" : "Off")")
                                .foregroundColor(.gray)
                                .font(.system(size: 56.0))
                                .bold()
                        }
                    }
                }
                Spacer()
            }
            .foregroundColor(.black)
            .padding()
            .background(.linearGradient(Gradient(colors: [Color(red: 0.88, green: 0.88, blue: 0.90), Color(red: 0.80, green: 0.80, blue: 0.85)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        } else {
            VStack {
                Text("nanotool")
                    .font(.footnote)
                TextField("Enter relay name", text: $name)
                    .font(.title
                    .bold())
                    .multilineTextAlignment(.center)
                Spacer()
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(relayOn ? .green : .gray)
                Button {
                    relayOn.toggle()
                } label: {
                    ZStack {
                        Circle()
                            .fill(Color(red: 0.20, green: 0.20, blue: 0.20))
                            .padding()
                            .shadow(color: Color.black.opacity(0.7), radius: 20, x: 20, y: 20)
                            .shadow(color: Color.white.opacity(0.1), radius: 20, x: -15, y: -15)
                        HStack {
                            Text("\(relayOn ? "On" : "Off")")
                                .foregroundColor(.gray)
                                .font(.system(size: 56.0))
                                .bold()
                        }
                    }
                }
                Spacer()
            }
            .foregroundColor(.white)
            .padding()
            .background(.linearGradient(Gradient(colors: [Color(red: 0.20, green: 0.20, blue: 0.20), Color(red: 0.15, green: 0.15, blue: 0.15)]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}
