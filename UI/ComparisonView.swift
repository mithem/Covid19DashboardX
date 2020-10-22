//
//  ComparisonView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.10.20.
//

import SwiftUI

struct ComparisonView: View {
    let countries: [Country]
    let country: Country
    var body: some View {
        NavigationView {
            List(countries.filter {$0.code != country.code}) { country in
                NavigationLink(country.name.localizedCapitalized, destination: ComparisonDetailView(countries: (self.country, country)))
            }
            .navigationTitle("Compare countries")
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView(countries: countriesForPreviews, country: countriesForPreviews[0])
    }
}
