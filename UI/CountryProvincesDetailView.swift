//
//  CountryProvincesDetailView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct CountryProvincesDetailView: View {
    @ObservedObject var manager: DataManager
    let country: Country
    
    @AppStorage(UserDefaultsKeys.provinceMetric) var activeMetric = DefaultSettings.provinceMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.colorTresholdForDeltas) var colorDeltaTreshold = DefaultSettings.colorTresholdForDeltas
    @AppStorage(UserDefaultsKeys.colorGrayAreaForDeltas) var colorDeltaGrayArea = DefaultSettings.colorGrayAreaForDeltas
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorPercentagesTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorPercentagesGrayArea = DefaultSettings.colorGrayAreaForPercentages
    
    @State private var searchTerm = ""
    @State private var lowercasedSearchTerm = ""
    var body: some View {
        VStack {
            ProvinceSummaryMetricPickerView(activeMetric: $activeMetric)
            List {
                if country.provinces.count > 0 {
                    SearchBar(searchTerm: $searchTerm)
                        .onChange(of: searchTerm) { value in
                            lowercasedSearchTerm = value.lowercased()
                        }
                }
                Text("Total: \(country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorPercentagesGrayArea, reversed: false))")
                if manager.loading {
                    HStack(spacing: 10) {
                        ProgressView()
                        Text("Loading…")
                    }
                } else if country.provinces.isEmpty {
                    Text("For this country, there isn't province data available.")
                }
                if let error = manager.error {
                    if error == .constrainedNetwork {
                        Text("Low data mode")
                            .foregroundColor(.yellow)
                        ProvincesList
                    } else {
                        Text("Error getting provinces data: \(error.localizedDescription)")
                        Button("Refresh") {
                            manager.loadProvinceData(for: country)
                        }
                        .foregroundColor(.accentColor)
                    }
                } else {
                    ProvincesList
                }
            }
            .animation(.easeInOut)
        }
        .padding()
        .navigationTitle("Details: \(country.name.localizedCapitalized)")
    }
    
    var ProvincesList: some View {
        ForEach(country.provinces.filter { $0.isIncluded(lowercasedSearchTerm) }) { province in
            ProvinceInlineView(province: province, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorDeltaGrayArea, activeMetric: activeMetric, manager: manager)
                .contextMenu {
                    Button(action: {
                        manager.loadProvinceData(for: country)
                    }) {
                        Text("Refresh provinces")
                        Image(systemName: "arrow.clockwise")
                    }
                }
        }
    }
    
    func loadData() {
        if country.provinces.isEmpty {
            manager.loadProvinceData(for: country)
        }
    }
}

struct CountryProvincesView_Previews: PreviewProvider {
    static var previews: some View {
        CountryProvincesDetailView(manager: DataManager(), country: MockData.countries[0])
    }
}

