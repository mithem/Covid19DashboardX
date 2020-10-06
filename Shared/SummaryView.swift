//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var manager = DataManager()
    @State private var showingSortActionSheet = false
    @State private var searchTerm = ""
    @AppStorage(UserDefaultsKeys.ativeMetric) var activeMetric = SummaryViewMetric.confirmed
    @State private var lowercasedSearchTerm = ""
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName})]
        
        let confirmed: [ActionSheet.Button] = [.default(Text("Total confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("New confirmed"), action: {manager.sortBy = .newConfirmed})]
        let deaths: [ActionSheet.Button] = [.default(Text("Total deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("New deaths"), action: {manager.sortBy = .newDeaths})]
        let recovered: [ActionSheet.Button] = [.default(Text("Total recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("New recovered"), action: {manager.sortBy = .newRecovered})]
        
        switch activeMetric {
        case .confirmed:
            buttons.append(contentsOf: confirmed)
        case .deaths:
            buttons.append(contentsOf: deaths)
        case .recovered:
            buttons.append(contentsOf: recovered)
        }
            
        buttons.append(contentsOf: [.default(Text(manager.reversed ? "Dereverse" : "Reverse"), action: {manager.reversed.toggle()}), .cancel()])
        return buttons
    }
    
    var body: some View {
        NavigationView {
            Group {
                if manager.countries.count > 0 {
                    List {
                        Picker("Measurement metric", selection: $activeMetric) {
                            Text("Confirmed").tag(SummaryViewMetric.confirmed)
                            Text("Deaths").tag(SummaryViewMetric.deaths)
                            Text("Recovered").tag(SummaryViewMetric.recovered)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        SearchBar(searchTerm: $searchTerm)
                        Text("Global: ") + (manager.latestGlobal?.summaryFor(metric: activeMetric) ?? Text("N/A"))
                        ForEach(manager.countries.filter { c in
                            if searchTerm.isEmpty { return true }
                            return c.name.lowercased().contains(lowercasedSearchTerm) || lowercasedSearchTerm.contains(c.code.lowercased())
                        }, id: \.code) { country in
                            NavigationLink(destination: CountryView(country: country).environmentObject(manager)) {
                                Text(country.name.localizedCapitalized + " ") + country.summaryFor(metric: activeMetric)
                            }
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .animation(.easeInOut)
                } else {
                    Text("No data.")
                }
            }
            .onChange(of: searchTerm, perform: { value in
                lowercasedSearchTerm = searchTerm.lowercased()
            })
            .onAppear(perform: manager.loadSummary)
            .actionSheet(isPresented: $showingSortActionSheet) {
                ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: actionSheetButtonsForSorting)
            }
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
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
