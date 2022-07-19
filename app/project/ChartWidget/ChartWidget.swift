//
//  ChartWidget.swift | Home Screen widget
//  ChartWidget
//
//  Copyright 2022 Cristian Dinca (@iCMDgithub). See github.com/iCMDgithub/nanotool for license terms.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    @MainActor func placeholder(in context: Context) -> ChartEntry {
        ChartEntry(date: Date(), chartData: ChartData(sensor: .temperature, ip: "nanotool.local:5000"), configuration: SelectSensorIntent())
    }

    @MainActor func getSnapshot(for configuration: SelectSensorIntent, in context: Context, completion: @escaping (ChartEntry) -> ()) {
        let entry = ChartEntry(date: Date(), chartData: ChartData(sensor: configuration.sensor, ip: configuration.IP ?? "nanotool.local:5000"), configuration: configuration)
        completion(entry)
    }
    
    @MainActor func getTimeline(for configuration: SelectSensorIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [ChartEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        let chartData = ChartData(sensor: configuration.sensor, ip: configuration.IP ?? "nanotool.local:5000")
        chartData.fetchChart(date: Date(), sensor: chartData.sensor, ip: "nanotool.local:5000") { fetchedData in
            chartData.sensorData = fetchedData
            let entry = ChartEntry(date: currentDate, chartData: chartData, configuration: configuration)
            entries.append(entry)
            let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
            let timeline = Timeline(entries: entries, policy: .after(nextUpdate))
            completion(timeline)
        }
        
    }
}

struct ChartEntry: TimelineEntry {
    let date: Date
    let chartData: ChartData
    //let sensor: Sensor
    let configuration: SelectSensorIntent
}

struct ChartWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        DataChart(data: entry.chartData)
    }
}

@main
struct ChartWidget: Widget {
    let kind: String = "ChartWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: SelectSensorIntent.self, provider: Provider()) { entry in
            ChartWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Today's Chart")
        .description("View a sensor's registered values during the day.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}

struct ChartWidget_Previews: PreviewProvider {
    static var previews: some View {
        ChartWidgetEntryView(entry: ChartEntry(date: Date(), chartData: ChartData(sensor: .temperature, ip: "nanotool.local:5000"), configuration: SelectSensorIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
