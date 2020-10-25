//
//  ComparisonView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.10.20.
//

import SwiftUI

struct ComparisonView: View {
    @Binding var isPresented: Bool
    @ObservedObject var manager: DataManager
    let country: Country
    @State private var searchTerm = ""
    @State private var lowercasedSearchTerm = ""
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchTerm: $searchTerm)
                    .padding()
                List(manager.countries.filter { c in
                    if searchTerm.isEmpty { return true }
                    if c.code == country.code { return true } // no self-comparison
                    return c.name.lowercased().contains(lowercasedSearchTerm) || lowercasedSearchTerm.contains(c.code.lowercased())
                }) { country in
                    NavigationLink(country.name.localizedCapitalized, destination: ComparisonDetailView(isPresented: $isPresented, countries: (self.country, country)))
                }
            }
            .onChange(of: searchTerm) { value in
                lowercasedSearchTerm = value.lowercased()
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
        ComparisonView(isPresented: .constant(true), manager: DataManager(), country: countriesForPreviews[0])
    }
}
