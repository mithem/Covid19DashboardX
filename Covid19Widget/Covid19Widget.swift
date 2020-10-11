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

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    
    typealias Intent = CountrySelectionIntent
    
    func placeholder(in context: Context) -> SimpleEntry {
        let config =  CountrySelectionIntent()
        config.countryCode = "USA"
        config.measurementMetric = .confirmed
        return SimpleEntry(date: Date(), configuration: config, data: dataForPreviews[0])
    }
    
    func getSnapshot(for configuration: CountrySelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), configuration: configuration, data: dataForPreviews[0])
        completion(entry)
    }
    
    func getTimeline(for configuration: CountrySelectionIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        if let code = configuration.countryCode {
            let currentDate = Date()
            let latest = CountrySummaryMeasurement(date: currentDate, totalConfirmed: 0, newConfirmed: 0, totalDeaths: 0, newDeaths: 0, totalRecovered: 0, newRecovered: 0)
            let metric = BasicMeasurementMetric.active
            DataManager.getData(for: code, previousCountry: Country(code: code, name: code, latest: latest)) { result in
                switch result {
                case .success(let country):
                    let data = country.measurements.map {Double($0.metric(for: metric))}
                    let avg = MovingAverage.calculateMovingAverage(from: data, with: 5)
                    let entry = SimpleEntry(date: currentDate, configuration: configuration, data: avg)
                    let timeline = Timeline(entries: [entry], policy: .after(currentDate + TimeInterval(86_400)))
                    completion(timeline)
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: CountrySelectionIntent
    let data: [Double]
}

struct Covid19WidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var widgetFamily
    
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
        LineChartView(data: entry.data, title: entry.configuration.countryCode?.uppercased() ?? notAvailableString, form: form, rateValue: nil)
    }
}


@main
struct Covid19Widget: Widget {
    let kind: String = "Covid19GraphWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: CountrySelectionIntent.self, provider: Provider()) { entry in
            Covid19WidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Covid19 Widget")
        .description("Shows Covid19 active cases in a configured country.")
        .supportedFamilies([.systemSmall, .systemLarge])
    }
}

struct Covid19Widget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: CountrySelectionIntent(), data: dataForPreviews[0]))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: CountrySelectionIntent(), data: dataForPreviews[1]))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            Covid19WidgetEntryView(entry: SimpleEntry(date: Date(), configuration: CountrySelectionIntent(), data: dataForPreviews[0]))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
