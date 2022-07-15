//
//  ChartViewModel.swift
//  nanotool
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import SwiftUI

struct ChartLine: Shape {
    var width: CGFloat
    var height: CGFloat
    var max: Bool
    
    func xMax() -> Double {
        var foundMax = false
        let val = values.max(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func xMin() -> Double {
        var foundMax = false
        let val = values.min(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func yMax() -> Date {
        values.max(by: {$0.date < $1.date})?.date ?? Date()
    }
    func yMin() -> Date {
        values.min(by: {$0.date < $1.date})?.date ?? Date()
    }
    var values: [ChartData.DataSet]
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        if max {
            if xMax() != xMin() {
                path.move(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-(values[0].maxValue ?? 0))/(xMax()-xMin()))))
            } else {
                path.move(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
            }
            
            for point in values {
                if xMax() != xMin() {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-(point.maxValue ?? 0))/(xMax()-xMin()))))
                } else {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
                }
            }
            
            for point in values.reversed() {
                if xMax() != xMin() {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-(point.minValue ?? 0))/(xMax()-xMin()))))
                } else {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
                }
            }
            
            if xMax() != xMin() {
                path.addLine(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-(values[0].maxValue ?? 0))/(xMax()-xMin()))))
            } else {
                path.addLine(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
            }
        } else {
            if xMax() != xMin() {
                path.move(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-values[0].value)/(xMax()-xMin()))))
            } else {
                path.move(to: CGPoint(x: width*(1-DateInterval(start: values[0].date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
            }
            
            for point in values {
                if xMax() != xMin() {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height*((xMax()-point.value)/(xMax()-xMin()))))
                } else {
                    path.addLine(to: CGPoint(x: width*(1-DateInterval(start: point.date, end: yMax()).duration/DateInterval(start: yMin(), end: yMax()).duration), y: height/2))
                }
            }
        }
        return path
    }
}

struct AxisLines: Shape {
    var width: CGFloat
    var height: CGFloat
    func xMax() -> Double {
        var foundMax = false
        let val = values.max(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func xMin() -> Double {
        var foundMax = false
        let val = values.min(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func yMax() -> Date {
        values.max(by: {$0.date < $1.date})?.date ?? Date()
    }
    func yMin() -> Date {
        values.min(by: {$0.date < $1.date})?.date ?? Date()
    }
    var values: [ChartData.DataSet]
    
    func timeDivider() -> Double {
        let secondsDifference = DateInterval(start: yMin(), end: yMax()).duration
        if secondsDifference < 60 {
            return 10
        } else if secondsDifference < 900 {
            return 60
        } else if secondsDifference < 1800 {
            return 300
        } else if secondsDifference < 3600 {
            return 600
        } else if secondsDifference < 64800 {
            return 3600
        } else {
            return 7200
        }
    }
    
    func valueDivider() -> Double {
        let valueDifference = xMax()-xMin()
        if valueDifference < 25 {
            return 1
        } else if valueDifference < 50 {
            return 5
        } else {
            return 10
        }
    }


    func path(in rect: CGRect) -> Path {
        var path = Path()
        // find & draw dates (x axis)
        let timeDiv: Double = timeDivider()
        var i = Double(Int(timeDiv)*Int(values[0].date.timeIntervalSince1970/timeDiv)) + timeDiv
        var max = Double(Int(yMax().timeIntervalSince1970))
        var min = Double(Int(yMin().timeIntervalSince1970))
        while i<max {
            path.move(to: CGPoint(x: width*CGFloat(1-(max-i)/(max-min)), y: 0))
            path.addLine(to: CGPoint(x: width*CGFloat(1-(max-i)/(max-min)), y: height))
            i = i + timeDiv
        }
        
        let valueDiv: Double = valueDivider()
        i = Double(Int(valueDiv)*Int(xMin()/valueDiv)) + valueDiv
        max = xMax()
        min = xMin()
        while i<max {
            path.move(to: CGPoint(x: 0, y: height*CGFloat((max-i)/(max-min))))
            path.addLine(to: CGPoint(x: width, y: height*CGFloat((max-i)/(max-min))))
            i = i + valueDiv
        }
        return path
    }
}

/*
 
 */

struct LineChart: View {
    @Binding var style: LinearGradient
    @State var lineWidth: Double = 2
    @Binding var data: [ChartData.DataSet]
    
    func xMax() -> Double {
        var foundMax = false
        let val = data.max(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func xMin() -> Double {
        var foundMax = false
        let val = data.min(by: {
            if $0.maxValue != nil {
                foundMax = true
                if $1.maxValue != nil {
                    return $0.maxValue! < $1.maxValue!
                } else {
                    return $0.maxValue! < $1.value
                }
            } else {
                if $1.maxValue != nil {
                    foundMax = true
                    return $0.value < $1.maxValue!
                } else {
                    return $0.value < $1.value
                }
            }
        })
        if foundMax {
            return val?.maxValue ?? 0
        } else {
            return val?.value ?? 0
        }
    }
    func yMax() -> Date {
        data.max(by: {$0.date < $1.date})?.date ?? Date()
    }
    func yMin() -> Date {
        data.min(by: {$0.date < $1.date})?.date ?? Date()
    }
    
    func valueHeight(point: ChartData.DataSet, height: Double) -> Double {
        if xMax()-xMin() != 0 {
            return height*((xMax()-point.value)/(xMax()-xMin()))
        } else {
            return 0;
        }
    }
    
    func timeAxis(width: Double, height: Double, minutes: Bool) -> [(padding: Double, value: String)] {
        var array: [(padding: Double, value: String)] = []
        // find & draw dates (x axis)
        let timeDiv: Double = timeDivider()
        var i = Double(Int(timeDiv)*Int(data[0].date.timeIntervalSince1970/timeDiv))+timeDiv
        let max = Double(Int(yMax().timeIntervalSince1970))
        let min = Double(Int(yMin().timeIntervalSince1970))
        while i<max {
            let date = Date(timeIntervalSince1970: i)
            let dateFormatter = DateFormatter()
            if minutes {
                dateFormatter.dateFormat = "hh:mm:ss"
            } else {
                dateFormatter.dateFormat = "hh"
            }
            let dateString = dateFormatter.string(from: date)
            array.append((padding: width*CGFloat(1-(max-i)/(max-min)), value: dateString))
            i = i + timeDiv
        }
        return array
    }
    
    func valueAxis(width: Double, height: Double) -> [(padding: Double, value: Double)] {
        var array: [(padding: Double, value: Double)] = []
        let valueDiv: Double = valueDivider()
        var i = Double(Int(valueDiv)*Int(xMin()/valueDiv))+valueDiv
        let max = xMax()
        let min = xMin()
        while i<max {
            array.append((padding: height*CGFloat((max-i)/(max-min)), value: i))
            i = i + valueDiv
        }
        return array
    }
    
    func timeDivider() -> Double {
        let secondsDifference = DateInterval(start: yMin(), end: yMax()).duration
        if secondsDifference < 60 {
            return 10
        } else if secondsDifference < 900 {
            return 60
        } else if secondsDifference < 1800 {
            return 300
        } else if secondsDifference < 3600 {
            return 600
        } else if secondsDifference < 64800 {
            return 3600
        } else {
            return 7200
        }
    }
    
    func valueDivider() -> Double {
        let valueDifference = xMax()-xMin()
        if valueDifference < 25 {
            return 1
        } else if valueDifference < 50 {
            return 5
        } else {
            return 10
        }
    }
    
    var body: some View {
        GeometryReader { g in
            if data.isEmpty == false {
                ZStack {
                    AxisLines(width: g.size.width-50, height: g.size.height-50, values: data)
                        .stroke(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.25), lineWidth: 2)
                        .frame(width: g.size.width-50, height: g.size.height-50)
                    if data[0].maxValue != nil {
                        ChartLine(width: g.size.width-50, height: g.size.height-50, max: true, values: data)
                            .fill(style)
                            .opacity(0.2)
                            .frame(width: g.size.width-50, height: g.size.height-50)
                    }
                    ChartLine(width: g.size.width-50, height: g.size.height-50, max: false, values: data)
                        .stroke(style, lineWidth: lineWidth)
                        .frame(width: g.size.width-50, height: g.size.height-50)
                    ForEach(valueAxis(width: g.size.width-50, height: g.size.height-50), id: \.padding) { point in
                        ZStack(alignment: .top) {
                            VStack{
                                HStack {
                                    Text("\(point.value, specifier: "%.0f")")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12).smallCaps())
                                    Spacer()
                                }
                                Spacer()
                            }
                            .padding(.top, point.padding+15)
                        }
                    }
                    .foregroundStyle(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.25))
                    .frame(width: g.size.width, height: g.size.height)
                    
                    ForEach(timeAxis(width: g.size.width-50, height: g.size.height-50, minutes: timeDivider()<3600), id: \.padding) { point in
                        ZStack(alignment: .top) {
                            VStack {
                                HStack {
                                    Text("\(point.value)")
                                        .foregroundColor(.gray)
                                        .font(.system(size: 12).smallCaps())
                                    Spacer()
                                }
                                .padding(.leading, point.padding+20)
                                Spacer()
                            }
                        }
                    }
                    .foregroundStyle(Color(red: 0.5, green: 0.5, blue: 0.5, opacity: 0.25))
                    .frame(width: g.size.width, height: g.size.height)
                }
            }
        }
    }
}

