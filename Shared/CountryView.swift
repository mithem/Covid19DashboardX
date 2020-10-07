//
//  CountryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI
import SwiftUICharts

struct CountryView: View {
    @EnvironmentObject var manager: DataManager
    @AppStorage(UserDefaultsKeys.ativeMetric) var activeMetric = BasicMeasurementMetric.confirmed
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    let country: Country
    var body: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
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
                        LineView(data: getData(country.measurements, metric: activeMetric, dataRepresentation: dataRepresentationType))
                    }
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading…")
                    }
                    .onAppear {
                        manager.loadData(for: country)
                    }
                }
            }
        }
        .padding()
        .navigationTitle(country.name.localizedCapitalized)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: CountryViewSettingsView(country: country)) {
                    Image(systemName: "info.circle")
                })
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
