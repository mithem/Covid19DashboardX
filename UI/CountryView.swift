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
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    @AppStorage(UserDefaultsKeys.ativeMetric) var activeMetric = BasicMeasurementMetric.confirmed
    @AppStorage(UserDefaultsKeys.currentN) var n = 1
    @State private var alteredData = [Double]()
    let country: Country
    
    @AppStorage(UserDefaultsKeys.maximumN) var maximumN = 90
    
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
                            .onChange(of: dataRepresentationType, perform: { _ in
                                calcMovingAvg()
                            })
                        }
                        LineView(data: alteredData)
                            .onAppear {
                                calcMovingAvg()
                            }
                            .onChange(of: activeMetric, perform: { _ in
                                calcMovingAvg()
                            })
                    }
                } else {
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
            if maximumN > 1 {
                Stepper("Moving average: \(n.nDaysHumanReadable)", value: $n, in: 1...(country.measurements.count == 0 ? 1 : (country.measurements.count < maximumN ? country.measurements.count : maximumN)))
                    .onChange(of: n, perform: { _ in
                        calcMovingAvg()
                    })
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
    
    func calcMovingAvg() {
        alteredData = MovingAverage.calculateMovingAverage(from: getData(country.measurements.map {Double($0.metric(for: activeMetric))}, dataRepresentation: dataRepresentationType), with: n)
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
