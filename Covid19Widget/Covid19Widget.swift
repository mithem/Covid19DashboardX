//
//  Covid19Widget.swift
//  Covid19Widget
//
//  Created by Miguel Themann on 10.10.20.
//

import WidgetKit
import SwiftUI
import Intents
import SwiftUICharts

struct Provider: TimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = CountrySelectionIntent
    @AppStorage(UserDefaultsKeys.widgetCountry) var code = DefaultSettings.widgetCountry
    
    func placeholder(in context: Context) -> SimpleEntry {
        return SimpleEntry(date: Date(), data: MockData.dataForPreviews[0])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), data: MockData.dataForPreviews[0])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
            let currentDate = Date()
            let latest = CountrySummaryMeasurement(date: currentDate, totalConfirmed: 0, newConfirmed: 0, totalDeaths: 0, newDeaths: 0, totalRecovered: 0, newRecovered: 0, active: 0, newActive: 0, caseFatalityRate: 0.005)
            let metric = BasicMeasurementMetric.active
            DataManager.getHistoryData(for: Country(code: code, name: code, latest: latest)) { result in
                switch DataManager.parseHistoryData(result) {
                case .success(let country):
                    let data = country.measurements.map {Double($0.metric(for: metric))}
                    let avg = MovingAverage.calculateMovingAverage(from: data, with: 5)
                    let entry = SimpleEntry(date: currentDate, data: avg)
                    let timeline = Timeline(entries: [entry], policy: .after(currentDate + TimeInterval(86_400)))
                    completion(timeline)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let data: [Double]
}

struct Covid19WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    @AppStorage(UserDefaultsKeys.widgetCountry) var code = DefaultSettings.widgetCountry
    
    var form: CGSize {
        switch widgetFamily {
        case .systemSmall:
            return ChartForm.small
        case .systemMedium:
            return ChartForm.small
        case .systemLarge:
            return ChartForm.extraLarge
        @unknown default:
            return ChartForm.small
        }
    }
    
    var body: some View {
        LineChartView(data: entry.data, title: code.uppercased(), form: form, rateValue: nil)
    }
}


@main
struct Covid19Widget: Widget {
    let kind: String = "Covid19GraphWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Covid19WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Covid19 Widget")
        .description("Shows Covid19 active cases in a configured country.")
        .supportedFamilies([.systemSmall])
    }
}

struct Covid19Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), data: MockData.dataForPreviews[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), data: MockData.dataForPreviews[1]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), data: MockData.dataForPreviews[0]))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
