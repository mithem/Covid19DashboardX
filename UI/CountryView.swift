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
    @AppStorage(UserDefaultsKeys.measurementMetric) var measurementMetric = DefaultSettings.measurementMetric
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
            if manager.error == nil || !country.measurements.isEmpty {
                if country.measurements.isEmpty {
                    LoadingView
                } else {
                    DataView
                }
            } else if let error = manager.error {
                if error == .constrainedNetwork {
                    if country.measurements.isEmpty {
                        VStack {
                            Text("low_data_mode_on_period")
                                .padding()
                            HStack {
                                Button("settings") {
                                    UIApplication.shared.open(UsefulURLs.cellularSettings)
                                }
                                Button("ignore") {
                                    UserDefaults().set(true, forKey: UserDefaultsKeys.ignoreLowDataMode)
                                    manager.loadHistoryData(for: country)
                                }
                            }
                            .buttonStyle(CustomButtonStyle())
                        }
                        .onAppear {
                            manager.loadHistoryData(for: country)
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
            } else if manager.loadingTasks.contains(.historyData(countryCode: country.code)) {
                LoadingView
                Spacer()
            } else {
                VStack {
                    Text("no_data_present")
                    RefreshButton
                }
            }
        }
        .navigationTitle(country.name.localizedCapitalized)
        .navigationBarItems(
            trailing:
                NavigationLink(destination: CountryViewSettingsView(country: country)) {
                    Image(systemName: "info.circle")
                }
                .padding(UIConstants.navigationBarItemsPadding)
                .hoverEffect()
        )
    }
    
    var DataView: some View {
        VStack {
            BasicMeasurementMetricPickerView(activeMetric: $measurementMetric)
            Spacer()
            VStack {
                VStack {
                    HStack {
                        Text(measurementMetric.humanReadable)
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
                    .onChange(of: measurementMetric, perform: { _ in
                        calcMovingAvg()
                    })
            }
            
            HStack {
                NavigationLink(destination: provincesDetailView, isActive: $showingCountryProvincesDetailView) {
                    Button("details") {
                        provincesDetailView.loadData()
                        showingCountryProvincesDetailView = true
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                Button("compare") {
                    showingComparisonView = true
                }
                .buttonStyle(CustomButtonStyle())
                .sheet(isPresented: $showingComparisonView) {
                    SummaryProviderSelectionView(isPresented: $showingComparisonView, providers: manager.countries, provider: country) { isPresented, country -> ComparisonDetailView in
                        showingComparisonView = isPresented.wrappedValue
                        return ComparisonDetailView(isPresented: $showingComparisonView, countries: (self.country, country))
                    }
                }
            }
            if maximumN > 1 {
                Stepper("\(NSLocalizedString("moving_avg_colon", comment: "moving_avg_colon"))\(n.nDaysHumanReadable)", value: $n, in: 1...(country.measurements.count == 0 ? 1 : (country.measurements.count < maximumN ? country.measurements.count : maximumN)))
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
            Text("loading.uppercase")
        }
        .onAppear {
            manager.loadHistoryData(for: country)
        }
    }
    
    var RefreshButton: some View {
        Button("refresh") {
            manager.loadHistoryData(for: country)
        }
        .buttonStyle(CustomButtonStyle())
    }
    
    func calcMovingAvg() {
        alteredData = MovingAverage.calculateMovingAverage(from: getData(country.measurements.map {Double($0.metric(for: measurementMetric))}, dataRepresentation: dataRepresentationType), with: n)
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                CountryView(manager: DataManager(), country: MockData.countries[0])
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
