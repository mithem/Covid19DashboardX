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
                NavigationLink("\(NSLocalizedString("total_colon", comment: "total_colon"))\(country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorPercentagesGrayArea, reversed: false))", destination: SummaryProviderDetailView(manager: manager, provider: country))
                if manager.loadingTasks.contains(.provinceData(countryCode: country.code)) {
                    HStack(spacing: 10) {
                        ProgressView()
                        Text("loading.uppercase")
                    }
                } else if country.provinces.isEmpty {
                    Text("no_province_data_for_country")
                }
                if let error = manager.error {
                    if error == .constrainedNetwork {
                        Text("low_data_mode_on_period")
                            .foregroundColor(.yellow)
                        ProvincesList
                    } else {
                        Text("\(NSLocalizedString("error_getting_provinces_data_colon", comment: "error_getting_provinces_data_colon"))\(error.localizedDescription)")
                        Button("refresh") {
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
        .navigationTitle("\(NSLocalizedString("details_colon", comment: "details_colon"))\(country.name.localizedCapitalized)")
    }
    
    var ProvincesList: some View {
        ForEach(country.provinces.filter { $0.isIncluded(lowercasedSearchTerm) }) { province in
            ProvinceInlineView(province: province, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, colorPercentagesTreshold: colorPercentagesTreshold, colorPercentagesGrayArea: colorDeltaGrayArea, activeMetric: activeMetric, manager: manager)
                .contextMenu {
                    Button(action: {
                        manager.loadProvinceData(for: country)
                    }) {
                        Text("refresh_provinces")
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

