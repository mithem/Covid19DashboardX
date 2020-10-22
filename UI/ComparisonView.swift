//
//  ComparisonView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.10.20.
//

import SwiftUI

struct ComparisonView: View {
    @Binding var isPresented: Bool
    let countries: [Country]
    let country: Country
    var body: some View {
        NavigationView {
            List(countries.filter {$0.code != country.code}) { country in
                NavigationLink(country.name.localizedCapitalized, destination: ComparisonDetailView(isPresented: $isPresented, countries: (self.country, country)))
            }
            .navigationTitle("Compare countries")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct ComparisonView_Previews: PreviewProvider {
    static var previews: some View {
        ComparisonView(isPresented: .constant(true), countries: countriesForPreviews, country: countriesForPreviews[0])
    }
}
