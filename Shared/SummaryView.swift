//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct SummaryView: View {
    @StateObject var manager = DataManager()
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        NavigationView {
            Group {
//                if manager.latestMeasurements.count > 0 {
//                    List {
//                        Text("Global: \(globalConfirmed)")
//                        ForEach(manager.latestMeasurements, id: \.countryCode) { measurement in
//                            Text("\(measurement.country.capitalized): \(measurement.totalConfirmed)")
//                        }
//                    }
//                } else {
//                    Text("No data.")
//                }
                LazyVGrid(columns: columns) {
                    ForEach(manager.latestMeasurements) { measurement in
                        ForEach(measurement) { description in
                            Text(description)
                        }
                    }
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
