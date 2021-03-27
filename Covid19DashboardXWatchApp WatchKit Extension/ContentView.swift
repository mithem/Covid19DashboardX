//
//  ContentView.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 01.01.21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var manager: DataManager
    @AppStorage(UserDefaultsKeys.measurementMetric) var measurementMetric = DefaultSettings.measurementMetric
    
    var sharedWCSessionDelegate: SharedWCSessionDelegate = {
        return SharedWCSessionDelegate()
    }()
    
    var body: some View {
        if let error = manager.error {
            VStack {
                Text(error.localizedDescription)
                RefreshButton
            }
        } else if manager.countries.count > 0 || manager.latestGlobal != nil {
            List {
                BasicMeasurementMetricPickerView(activeMetric: $measurementMetric)
                if !manager.loadingTasks.isEmpty {
                    Text("Loading...")
                }
                if let latest = manager.latestGlobal {
                    SummaryProviderSquareView(provider: latest, metric: $measurementMetric)
                }
                ForEach(manager.countries) { country in
                    SummaryProviderSquareView(provider: country, metric: $measurementMetric)
                }
            }
            .listStyle(CarouselListStyle())
        } else {
            if manager.loadingTasks.contains(.summary) {
                VStack {
                    ProgressView()
                    Text("Loading...")
                }
            } else {
                VStack {
                    Text("No data.")
                    RefreshButton
                }
            }
        }
    }
    
    func refresh() {
        manager.execute(task: .globalSummary)
        manager.execute(task: .summary)
    }
    
    var RefreshButton: some View {
        Button(action: refresh) {
            Text("Refresh")
                .buttonStyle(CustomButtonStyle())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(manager: MockDataManager())
            .previewDevice("Apple Watch Series 6 - 44mm")
    }
}
