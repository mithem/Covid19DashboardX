//
//  SummaryProviderSelectionView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 22.10.20.
//

import SwiftUI

struct SummaryProviderSelectionView<Provider: SummaryProvider, Destination: View>: View {
    @Binding var isPresented: Bool
    var providers: [Provider]
    let provider: Provider
    @State private var searchTerm = ""
    @State private var lowercasedSearchTerm = ""
    let destination: (Binding<Bool>, Provider) -> Destination
    var body: some View {
        NavigationView {
            VStack {
                SearchBar(searchTerm: $searchTerm)
                    .padding()
                List(providers.filter { p -> Bool in
                    if p.id == provider.id { return false } // no self-comparison
                    if searchTerm.isEmpty { return true }
                    return p.isIncluded(searchTerm: searchTerm)
                }) { provider in
                    NavigationLink(provider.description.localizedCapitalized, destination: destination($isPresented, provider))
                }
            }
            .onChange(of: searchTerm) { value in
                lowercasedSearchTerm = value.lowercased()
            }
            .navigationTitle("Select country")
            .navigationBarItems(leading: Button("Cancel") {
                isPresented = false
            })
        }
    }
}

struct SummaryProviderSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryProviderSelectionView(isPresented: .constant(true), providers: MockData.countries, provider: MockData.countries[0]) { _, _ in
            EmptyView()
        }
    }
}
