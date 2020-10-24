//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI
import Reachability

struct SummaryView: View, DataManagerDelegate {
    
    let reachability = try! Reachability()
    
    @ObservedObject var manager: DataManager
    @State private var showingActionSheet = false
    @State private var actionSheetConfig = ActionSheetConfig.sort
    @State private var searchTerm = ""
    @State private var favorites = [String]()
    @State private var lowercasedSearchTerm = ""
    @AppStorage(UserDefaultsKeys.activeMetric) var activeMetric = DefaultSettings.measurementMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    
    init() {
        self.manager = DataManager()
        manager.delegate = self
        reachability.whenReachable = {[self] reachability in
            if reachability.connection != .unavailable {
                DispatchQueue.main.async {
                    manager.error = nil
                }
                manager.loadSummary() // also refreshes CountryView
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Couldn't start Reachability notifier: \(error.localizedDescription)")
        }
    }
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName})]
        
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
        
        if manager.error != nil {
            buttons.insert(.default(Text("Refresh")) {manager.loadSummary()}, at: 0)
        }
        
        return buttons
    }
    
    var actionSheet: ActionSheet {
        switch actionSheetConfig {
        case .sort:
            return ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: actionSheetButtonsForSorting)
        case .error:
            return ActionSheet(title: Text("Error"), message: Text(manager.error?.localizedDescription ?? "unkown error."), buttons: [.default(Text("OK"))])
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if let error = manager.error {
                    Text(error.localizedDescription)
                        .padding()
                        .onAppear(perform: handleNetworkErrors)
                } else if manager.countries.count > 0 {
                    VStack {
                        List {
                            BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
                            SearchBar(searchTerm: $searchTerm)
                            Text("Global: ") + (manager.latestGlobal?.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorTreshold: manager.colorTreshold, colorGrayArea: manager.colorGrayArea, reversed: false) ?? Text(notAvailableString))
                            ForEach(manager.countries.filter { c in
                                if searchTerm.isEmpty { return true }
                                return c.name.lowercased().contains(lowercasedSearchTerm) || lowercasedSearchTerm.contains(c.code.lowercased())
                            }, id: \.code) { country in
                                CountryInlineView(country: country, colorNumbers: colorNumbers, activeMetric: $activeMetric, manager: manager)
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
                } else {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading…")
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
                if manager.error != nil {
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
