//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct SummaryView: View {
    @StateObject var manager = DataManager()
    @State private var showingSortActionSheet = false
    var body: some View {
        NavigationView {
            Group {
                if manager.latestMeasurements.count > 0 {
                    List {
                        Text("Global: \(manager.latestGlobal?.confirmedSummary ?? "N/A")")
                        ForEach(manager.latestMeasurements, id: \.countryCode) { measurement in
                            Text("\(measurement.country.capitalized): \(measurement.confirmedSummary)")
                        }
                    }
                    .listStyle(InsetGroupedListStyle())
                    .animation(.easeInOut)
                } else {
                    Text("No data.")
                }
            }
            .onAppear {
                manager.loadFromApi()
            }
            .actionSheet(isPresented: $showingSortActionSheet) {
                ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: [.default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName}), .default(Text("Total confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("New confirmed"), action: {manager.sortBy = .newConfirmed}), .default(Text("Total deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("New deaths"), action: {manager.sortBy = .newDeaths}), .default(Text("Total recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("New recovered"), action: {manager.sortBy = .newRecovered}), .default(Text("Slug"), action: {manager.sortBy = .slug}), .default(Text(manager.reversed ? "Dereverse" : "Reverse"), action: {manager.reversed.toggle()}), .cancel()])
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
