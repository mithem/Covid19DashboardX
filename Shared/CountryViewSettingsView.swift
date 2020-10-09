//
//  CountryViewSettingsView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 07.10.20.
//

import SwiftUI

struct CountryViewSettingsView: View {
    let country: Country
    @AppStorage(UserDefaultsKeys.dataRepresentationType) var dataRepresentationType = DataRepresentationType.normal
    @State private var showingMovingAveragesConfigurationScreen = false
    let delegate: CountryViewSettingsViewDelegate
    var body: some View {
        Form {
            Picker("Data representation", selection: $dataRepresentationType) {
                ForEach(DataRepresentationType.allCases) { reprType in
                    Text(reprType.rawValue).tag(reprType)
                }
            }
            Button("Configure moving averages") {
                showingMovingAveragesConfigurationScreen = true
            }
            .sheet(isPresented: $showingMovingAveragesConfigurationScreen) {
                MovingAverageSelectionView(delegate: delegate)
            }
        }
        .navigationTitle("Visualization settings")
    }
    
    struct MovingAverageSelectionView: View {
        let delegate: CountryViewSettingsViewDelegate
        @State private var movingAverages = Set<DataStreamAnalyzer.MovingAverage>()
        @State private var n = 2
        @Environment(\.presentationMode) private var presentationMode
        var body: some View {
            NavigationView {
                List {
                    HStack {
                        Stepper("n: \(n)", value: $n, in: 1...200)
                        Button("Add") {
                            let movingAverage = DataStreamAnalyzer.MovingAverage(n: n, data: delegate.data)
                            print(movingAverages.insert(movingAverage).inserted) // - BUG: this shouldn't always print true
                        }
                    }
                    ForEach(Array(movingAverages)) { avg in
                        Text(String(avg.n))
                    }
                    Button("Apply") {
                        delegate.didConfigureMovingAverages(movingAverages)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                .navigationTitle("Configure moving averages")
            }
        }
    }
}

protocol CountryViewSettingsViewDelegate {
    var data: [Double] { get }
    func didConfigureMovingAverages(_ avgs: Set<DataStreamAnalyzer.MovingAverage>)
}
