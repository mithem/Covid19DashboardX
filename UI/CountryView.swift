//
//  CountryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 04.10.20.
//

import SwiftUI
import SwiftUICharts

struct CountryView: View {
    @ObservedObject var manager: DataManager
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    @AppStorage(UserDefaultsKeys.activeMetric) var activeMetric = BasicMeasurementMetric.confirmed
    @AppStorage(UserDefaultsKeys.currentN) var n = 1
    @AppStorage(UserDefaultsKeys.maximumN) var maximumN = DefaultSettings.maximumN
    
    @State private var alteredData = [Double]()
    @State private var showingCountryProvincesDetailView = false
    @State private var showingComparisonView = false
    
    let country: Country
    let provincesDetailView: CountryProvincesDetailView
    
    init(manager: DataManager, country: Country) {
        self.manager = manager
        self.country = country
        self.provincesDetailView = CountryProvincesDetailView(manager: manager, country: country)
    }
    
    var body: some View {
        Group {
            if manager.error == nil {
                if country.measurements.isEmpty {
                    LoadingView
                } else {
                    DataView
                }
            } else if let error = manager.error {
                if error == .constrainedNetwork {
                    if country.measurements.isEmpty {
                    VStack {
                        Text("Low data mode on.")
                            .padding()
                        HStack {
                            Button("Settings") {
                                UIApplication.shared.open(UsefulURLs.cellularSettings)
                            }
                            .buttonStyle(CustomButtonStyle())
                            Button("Ignore") {
                                UserDefaults().set(true, forKey: UserDefaultsKeys.ignoreLowDataMode)
                                manager.loadHistoryData(for: country)
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                    }
                    .onAppear {
                        manager.loadHistoryData(for: country) // try
                    }
                    } else {
                        DataView
                    }
                } else {
                    VStack {
                        Text(error.localizedDescription)
                            .padding()
                        RefreshButton
                    }
                }
            } else if manager.loading {
                LoadingView
                Spacer()
            } else {
                VStack {
                    Text("🤷 No data.")
                    RefreshButton
                }
            }
        }
        .navigationTitle(country.name.localizedCapitalized)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: CountryViewSettingsView(country: country)) {
                    Image(systemName: "info.circle")
                })
    }
    
    var DataView: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
            Spacer()
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
            
            HStack {
                NavigationLink(destination: provincesDetailView, isActive: $showingCountryProvincesDetailView) {
                    Button("Details") {
                        provincesDetailView.loadData()
                        showingCountryProvincesDetailView = true
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                Button("Compare") {
                    showingComparisonView = true
                }
                .buttonStyle(CustomButtonStyle())
                .sheet(isPresented: $showingComparisonView) {
                    ComparisonView(isPresented: $showingComparisonView, manager: manager, country: country)
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
    }
    
    var LoadingView: some View {
        VStack(spacing: 10) {
            ProgressView()
            Text("Loading…")
        }
        .onAppear {
            manager.loadHistoryData(for: country)
        }
    }
    
    var RefreshButton: some View {
        Button("Refresh") {
            manager.loadHistoryData(for: country)
        }
        .buttonStyle(CustomButtonStyle())
    }
    
    func calcMovingAvg() {
        alteredData = MovingAverage.calculateMovingAverage(from: getData(country.measurements.map {Double($0.metric(for: activeMetric))}, dataRepresentation: dataRepresentationType), with: n)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CountryView(manager: DataManager(), country: countriesForPreviews[0])
            }
            .previewDisplayName("Success")
            NavigationView {
                CountryView(manager: DataManager(), country: SpecialCountries.emptyCountry)
                    .environmentObject(DataManager())
            }
            .previewDisplayName("No internet")
        }
    }
}
