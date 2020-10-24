//
//  CountryProvincesView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct CountryProvincesDetailView: View {
    @ObservedObject var manager: DataManager
    let country: Country
    @State private var showingComparisonView = false
    @AppStorage(UserDefaultsKeys.provinceMetric) var activeMetric = DefaultSettings.provinceMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    var body: some View {
        VStack {
            ProvinceSummaryMetricPickerView(activeMetric: $activeMetric)
            List {
                Text("Total: \(country.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: manager.colorTreshold, colorGrayArea: manager.colorGrayArea, reversed: false))")
                ForEach(country.provinces) { province in
                    ProvinceInlineView(province: province, colorNumbers: colorNumbers, activeMetric: activeMetric, manager: manager)
                }
                if manager.loading {
                    HStack(spacing: 10) {
                        ProgressView()
                        Text("Loading…")
                    }
                }
            }
            .animation(.easeInOut)
            Button("Compare") {
                showingComparisonView = true
            }
            .buttonStyle(CustomButtonStyle())
            .sheet(isPresented: $showingComparisonView) {
                ComparisonView(isPresented: $showingComparisonView, manager: manager, country: country)
            }
            .onAppear {
                if country.provinces.isEmpty {
                    manager.loadProvinceData(for: country)
                }
            }
        }
        .padding()
        .navigationTitle("Details: \(country.name.localizedCapitalized)")
    }
}

struct CountryProvincesView_Previews: PreviewProvider {
    static var previews: some View {
        CountryProvincesDetailView(manager: DataManager(), country: countriesForPreviews[0])
    }
}
