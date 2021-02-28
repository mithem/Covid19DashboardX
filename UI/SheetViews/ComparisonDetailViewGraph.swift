//
//  ComparisonDetailViewGraph.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 15.02.21.
//

import SwiftUI
import SwiftUICharts

struct ComparisonDetailViewGraph: View {
    @Binding var isPresented: Bool
    let countries: (Country, Country)
    var body: some View {
        VStack {
            MultiLineChartView(data: [(countries.0.measurements.map {$0.metric(for: .confirmed)}, .default), (countries.1.measurements.map {$0.metric(for: .confirmed)}, GradientColor.default.reversed)], title: BasicMeasurementMetric.confirmed.humanReadable) // Greetings, Swift 5.4! (https://swiftbysundell.com/tips/chained-implicit-member-expressions/)
            NavigationLink("Show numbers", destination: ComparisonDetailViewTable(isPresented: $isPresented, countries: countries))
                .buttonStyle(CustomButtonStyle())
                .navigationBarItems(trailing: Button("Done") {
                    isPresented = false
                })
        }
    }
}

struct ComparisonDetailViewGraph_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonDetailViewGraph(isPresented: .constant(true), countries: (MockData.countries[0], MockData.countries[1]))
    }
}
