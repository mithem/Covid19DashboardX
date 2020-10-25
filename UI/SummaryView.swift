//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI
import Reachability

struct SummaryView: View, DataManagerDelegate {
    
    @ObservedObject var manager: DataManager
    @State private var showingActionSheet = false
    @State private var actionSheetConfig = ActionSheetConfig.sort
    @State private var searchTerm = ""
    @State private var favorites = [String]()
    @State private var lowercasedSearchTerm = ""
    
    @AppStorage(UserDefaultsKeys.activeMetric) var activeMetric = DefaultSettings.measurementMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorGrayArea = DefaultSettings.colorGrayAreaForPercentages
    
    init() {
        self.manager = DataManager()
        manager.delegate = self
    }
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("Refresh")) {manager.loadSummary()}, .default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName})]
        
        let confirmed: [ActionSheet.Button] = [.default(Text("Total confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("New confirmed"), action: {manager.sortBy = .newConfirmed})]
        let deaths: [ActionSheet.Button] = [.default(Text("Total deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("New deaths"), action: {manager.sortBy = .newDeaths})]
        let recovered: [ActionSheet.Button] = [.default(Text("Total recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("New recovered"), action: {manager.sortBy = .newRecovered})]
        let active: [ActionSheet.Button] = [.default(Text("Active cases"), action: {manager.sortBy = .activeCases})]
        // let cfr: [ActionSheet.Button] = [.default(Text("Case fatality rate"), action: {manager.sortBy = .caseFatalityRate})] // For transition from covid19api.com to covid-api.com for summaries
        
        switch activeMetric {
        case .confirmed:
            buttons.append(contentsOf: confirmed)
        case .deaths:
            buttons.append(contentsOf: deaths)
        case .recovered:
            buttons.append(contentsOf: recovered)
        case .active:
            buttons.append(contentsOf: active)
        }
        
        buttons.append(contentsOf: [.default(Text(manager.reversed ? "Dereverse" : "Reverse"), action: {manager.reversed.toggle()}), .cancel()])
        
        return buttons
    }
    
    var actionSheet: ActionSheet {
        switch actionSheetConfig {
        case .sort:
            return ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: actionSheetButtonsForSorting)
        case .error:
            return ActionSheet(title: Text("Unable to load data"), message: Text(manager.error?.localizedDescription ?? "unkown error."), buttons: [.default(Text("OK"))])
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !manager.countries.isEmpty {
                    CountriesView
                } else if manager.loading {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading...")
                    }
                } else if let error = manager.error {
                    VStack {
                        Text(error.localizedDescription)
                            .padding()
                        //.onAppear(perform: handleNetworkErrors)
                    }
                } else {
                    VStack {
                        Text("🤷 No data")
                        RefreshButton
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                actionSheet
            }
            .onChange(of: searchTerm, perform: { value in
                lowercasedSearchTerm = searchTerm.lowercased()
            })
            .onAppear {
                if manager.error != nil && manager.error != .constrainedNetwork {
                    actionSheetConfig = .error
                    showingActionSheet = true
                }
            }
            .navigationBarItems(leading:
                                    Button(action: {
                                        actionSheetConfig = .sort
                                        showingActionSheet = true
                                    }) {
                                        Image(systemName: "arrow.up.arrow.down")
                                    }.onLongPressGesture {
                                        manager.reversed.toggle()
                                    },
                                trailing:
                                    NavigationLink(destination: SettingsView()) {
                                        Image(systemName: "gear")
                                    }
            )
            .navigationTitle("Covid19 Summary")
        }
    }
    
    var RefreshButton: some View {
        Button("Refresh") {
            manager.loadSummary()
        }
        .buttonStyle(CustomButtonStyle())
    }
    
    var CountriesView: some View {
            VStack {
                List {
                    BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
                    SearchBar(searchTerm: $searchTerm)
                    Text("Global: ") + (manager.latestGlobal?.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, reversed: false) ?? Text(notAvailableString))
                    ForEach(manager.countries.filter { c in
                        if searchTerm.isEmpty { return true }
                        return c.name.lowercased().contains(lowercasedSearchTerm) || lowercasedSearchTerm.contains(c.code.lowercased())
                    }, id: \.code) { country in
                        CountryInlineView(country: country, colorNumbers: colorNumbers, colorTreshold: colorTreshold, colorGrayArea: colorGrayArea, activeMetric: $activeMetric, manager: manager)
                            .contextMenu {
                                Button(action: {
                                    manager.loadSummary()
                                }) {
                                    Text("Refresh summaries")
                                    Image(systemName: "arrow.clockwise")
                                }
                                Button(action: {
                                    DispatchQueue.main.async {
                                        manager.countries = []
                                    }
                                    manager.loadSummary()
                                }) {
                                    Text("Reset all data")
                                    Image(systemName: "trash")
                                }
                            }
                    }
                    HStack {
                        Spacer()
                        Text("Stay safe ❤️")
                            .foregroundColor(.secondary)
                            .grayscale(0.35)
                        Spacer()
                    }
                    .onTapGesture {
                        UIApplication.shared.open(UsefulURLs.whoCovid19AdviceForPublic)
                    }
                }
                .listStyle(InsetGroupedListStyle())
                .animation(.easeInOut)
            }
    }
    
    func handleNetworkErrors() {
        if manager.countries.count == 0 {
            switch manager.error {
            case .urlError(_):
                manager.loadSummary()
            default:
                break
            }
        }
    }
    
    // MARK: DataManagerDelegate compliance
    func error(_ error: NetworkError) {
        actionSheetConfig = .error
        showingActionSheet = true
    }
}

fileprivate enum ActionSheetConfig {
    case sort, error
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
