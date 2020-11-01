//
//  ComparisonDetailView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.10.20.
//

import SwiftUI

struct ComparisonDetailView: View {
    @Binding var isPresented: Bool
    let countries: (Country, Country)
    let columns: [GridItem] = Array(repeating: .init(.fixed(35)), count: 7)
    var body: some View {
        ScrollView(.init([.vertical, .horizontal])) {
            LazyHGrid(rows: columns) {
                Text("Country")
                    .bold()
                Text("Total confirmed")
                    .bold()
                Text("Total recovered")
                    .bold()
                Text("Total deaths")
                    .bold()
                Text("New confirmed")
                    .bold()
                Text("New recovered")
                    .bold()
                Text("New deaths")
                    .bold()
                ForEach([countries.0, countries.1]) { country in // just for less repitition
                    Text(country.name.localizedCapitalized)
                    Text(country.latest.totalConfirmed.humanReadable)
                    Text(country.latest.totalRecovered.humanReadable)
                    Text(country.latest.totalDeaths.humanReadable)
                    Text(country.latest.newConfirmed.humanReadable)
                    Text(country.latest.newRecovered.humanReadable)
                    Text(country.latest.newDeaths.humanReadable)
                }
            }
            .padding()
        }
        .navigationTitle("Compare countries")
        .navigationBarItems(trailing: Button("Done"){
            isPresented = false
        })
    }
}

struct ComparisonDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonDetailView(isPresented: .constant(false), countries: (Constants.countriesForPreviews[0], Constants.countriesForPreviews[1]))
    }
}
