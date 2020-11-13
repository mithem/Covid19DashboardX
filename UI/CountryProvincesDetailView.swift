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
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorGrayArea = DefaultSettings.colorGrayAreaForPercentages
    
    @State private var searchTerm = ""
    @State private var lowercasedSearchTerm = ""
    var body: some View {
        VStack {
            ProvinceSummaryMetricPickerView(activeMetric: $activeMetric)
            List {
                if country.provinces.count > 0 {
                    SearchBar(searchTerm: $searchTerm)
                }
                Text("Total: \(country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: false))")
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
                    if manager.loading {
                        HStack(spacing: 10) {
                            ProgressView()
                            Text("Loading…")
                        }
                    } else if country.provinces.isEmpty {
                        Text("For this country, there isn't province data available.")
                    }
                }
            }
            .animation(.easeInOut)
            .onChange(of: searchTerm) { value in
                lowercasedSearchTerm = value.lowercased()
            }
        }
        .padding()
        .navigationTitle("Details: \(country.name.localizedCapitalized)")
    }
    
    var ProvincesList: some View {
        ForEach(country.provinces.filter { $0.isIncluded(lowercasedSearchTerm) }) { province in
            ProvinceInlineView(province: province, colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, activeMetric: activeMetric, manager: manager)
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
        CountryProvincesDetailView(manager: DataManager(), country: Constants.countriesForPreviews[0])
    }
}

