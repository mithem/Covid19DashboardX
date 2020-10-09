//
//  CountryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI
import SwiftUICharts

struct CountryView: View, CountryViewSettingsViewDelegate {
    @EnvironmentObject var manager: DataManager
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    @AppStorage(UserDefaultsKeys.ativeMetric) var activeMetric = BasicMeasurementMetric.confirmed
    @State var dataStreamAnalyzer = DataStreamAnalyzer(originalData: [])
    let country: Country
    
    init(country: Country) {
        self.country = country
        let activeMetric = BasicMeasurementMetric(rawValue: UserDefaults().string(forKey: UserDefaultsKeys.ativeMetric) ?? "") ?? .confirmed
        self.dataStreamAnalyzer = DataStreamAnalyzer(originalData: country.measurements.map {Double($0.metric(for: activeMetric))}, movingAvgs: Set())
    }
    
    var body: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
            Spacer()
            Group {
                if country.measurements.count > 0 {
                    VStack {
                        VStack {
                            HStack {
                                Text(activeMetric.humanReadable)
                                    .font(.title)
                                    .bold()
                                Spacer()
                            }
                            HStack {
                                Text(dataRepresentationType.rawValue)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                        }
                        LineView(data: dataStreamAnalyzer.movingAvgs.first?.data ?? data)
                    }
                } else {
                    Spacer()
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading…")
                    }
                    .onAppear {
                        manager.loadData(for: country)
                    }
                    Spacer()
                }
            }
        }
        .padding()
        .navigationTitle(country.name.localizedCapitalized)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: CountryViewSettingsView(country: country, delegate: self)) {
                    Image(systemName: "info.circle")
                })
    }
    
    // - MARK: CountryViewSettingsViewDelegate compliance
    func didConfigureMovingAverages(_ avgs: Set<DataStreamAnalyzer.MovingAverage>) {
        avgs.forEach {$0.data.forEach {print("\($0.isFinite): \($0)")}}
        dataStreamAnalyzer.movingAvgs = avgs
    }
    var data: [Double] {
        getData(country.measurements.map {Double($0.metric(for: activeMetric))}, dataRepresentation: dataRepresentationType)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CountryView(country: countriesForPreviews[0])
            }
            .previewDisplayName("Success")
            NavigationView {
                CountryView(country: SpecialCountries.emptyCountry)
                    .environmentObject(DataManager())
            }
            .previewDisplayName("No internet")
        }
    }
}
