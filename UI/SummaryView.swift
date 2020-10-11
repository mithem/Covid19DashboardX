//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct SummaryView: View, DataManagerDelegate {
    @ObservedObject var manager: DataManager
    @State private var showingSortActionSheet = false
    @State private var searchTerm = ""
    @State private var favorites = [String]()
    @State private var lowercasedSearchTerm = ""
    @State private var showingErrorActionSheet = false
    @AppStorage(UserDefaultsKeys.ativeMetric) var activeMetric = BasicMeasurementMetric.confirmed
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    
    init() {
        self.manager = DataManager()
        manager.delegate = self
    }
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName})]
        
        let confirmed: [ActionSheet.Button] = [.default(Text("Total confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("New confirmed"), action: {manager.sortBy = .newConfirmed})]
        let deaths: [ActionSheet.Button] = [.default(Text("Total deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("New deaths"), action: {manager.sortBy = .newDeaths})]
        let recovered: [ActionSheet.Button] = [.default(Text("Total recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("New recovered"), action: {manager.sortBy = .newRecovered})]
        let active: [ActionSheet.Button] = [.default(Text("Active cases"), action: {manager.sortBy = .activeCases})]
        
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
    
    var body: some View {
        NavigationView {
            Group {
                if manager.countries.count > 0 {
                    VStack {
                        List {
                            BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
                            SearchBar(searchTerm: $searchTerm)
                            Text("Global: ") + (manager.latestGlobal?.summaryFor(metric: activeMetric, colorNumbers: colorNumbers) ?? Text(notAvailableString))
                            ForEach(manager.countries.filter { c in
                                if searchTerm.isEmpty { return true }
                                return c.name.lowercased().contains(lowercasedSearchTerm) || lowercasedSearchTerm.contains(c.code.lowercased())
                            }, id: \.code) { country in
                                CountryInlineView(country: country, colorNumbers: true, activeMetric: $activeMetric)
                                    .environmentObject(manager)
                            }
                            HStack {
                                Spacer()
                                Text("Stay safe ❤️")
                                    .foregroundColor(.secondary)
                                    .grayscale(0.35)
                                Spacer()
                                    .actionSheet(isPresented: $showingSortActionSheet) {
                                        ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: actionSheetButtonsForSorting)
                                    }
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
            .actionSheet(isPresented: $showingErrorActionSheet) {
                ActionSheet(title: Text("Error"), message: Text("Unkown error."), buttons: [.default(Text("OK"))])
            }
            .foregroundColor(showingErrorActionSheet ? .red : .primary)
            .onChange(of: searchTerm, perform: { value in
                lowercasedSearchTerm = searchTerm.lowercased()
            })
            .onAppear(perform: manager.loadSummary)
            .navigationBarItems(leading:
                                    Button(action: {
                                        showingSortActionSheet = true
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
    
    // MARK: DataManagerDelegate compliance
    func error(_ error: NetworkError) {
        showingErrorActionSheet = true
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
