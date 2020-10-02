//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct SummaryView: View {
    @StateObject var manager = DataManager()
    var globalConfirmed: String {
        if let tc = manager.latestGlobal?.totalConfirmed {
            let formatter = NumberFormatter()
            formatter.usesGroupingSeparator = true
            formatter.numberStyle = .decimal
            return formatter.string(from: NSNumber(value: tc)) ?? "unkown"
        }
        return "unkown"
    }
    var body: some View {
        NavigationView {
            Group {
                if manager.latestMeasurements.count > 0 {
                    List {
                        Text("Global: \(globalConfirmed)")
                        ForEach(manager.latestMeasurements, id: \.countryCode) { measurement in
                            Text("\(measurement.country.capitalized): \(measurement.totalConfirmed)")
                        }
                    }
                } else {
                    Text("No data.")
                }
            }
            .onAppear(perform: manager.loadFromApi)
            .navigationTitle("Covid19 Dashboard")
        }
    }
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
