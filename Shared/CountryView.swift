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
    let countryName: String
    @State private var history: [CountryHistoryMeasurement]?
    var body: some View {
        Group {
            if let history = history {
                LineView(data: history.map {Double($0.confirmed)}, title: "Confirmed cases")
                    .padding()
            } else {
                ProgressView()
                    .onAppear {
                        manager.loadData(for: countryName)
                        print("loading")
                    }
            }
        }
        .navigationTitle(countryName.localizedCapitalized)
    }
    
    init(manager: DataManager, countryName: String) {
        self.manager = manager
        self.countryName = countryName
        history = manager.getHistory(for: countryName)
        manager.subscribers.append(self)
    }
}

extension CountryView: DataManagerHistorySubscriber {
    func didUpdateHistory(new countries: [Country]) {
        print("got \(countries.count) values")
        history = countries.first(where: {$0.name == countryName})?.measurements
        print("updated: \(history?.count ?? -1) values in total!")
    }
}

struct CountryView_Previews: PreviewProvider {
    static var previews: some View {
        CountryView(manager: DataManager(), countryName: countriesForPreviews[0].name)
    }
}
