//
//  SensorValueArc.swift | Shape used to display an Arc based on a sensor's registered value
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct SensorValueArc: Shape {
    let minValue: Double
    let maxValue: Double
    var value: Double
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: min(rect.size.width, rect.size.height)/2.0, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: (value-minValue)/(maxValue-minValue)*360.00), clockwise: false)
        return path
    }
}
