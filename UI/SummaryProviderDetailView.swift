//
//  SummaryProviderDetailView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct SummaryProviderDetailView<Provider: SummaryProvider>: View {
    @ObservedObject var manager: DataManager
    let provider: Provider
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(MeasurementMetric.allCases) { metric in
                    Card(metric: metric, value: provider.value(for: metric), exponentialProperty: provider.exponentialProperty)
                }
            }
            NavigationLink("future_estimations", destination: FutureEstimationProviderView(futureEstimationProvider: FutureEstimationProvider(provider: provider), manager: manager))
                .buttonStyle(CustomButtonStyle())
                .padding(.vertical)
        }
        .navigationTitle(provider.description)
    }
}

fileprivate struct Card: View {
    @Environment(\.colorScheme) private var colorScheme
    let metric: MeasurementMetric
    let value: String
    let exponentialProperty: ExponentialProperty
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(backgroundColor)
                .opacity(colorScheme == .dark ? 0.7 : 1)
            VStack {
                HStack {
                    Text(metric == .exponentialProperty ? exponentialProperty.humanReadable : metric.humanReadable)
                        .font(.subheadline)
                        .foregroundColor(foregroundColor)
                    Spacer()
                }
                .padding(.horizontal, 5)
                Text(metric == .exponentialProperty ? exponentialProperty.value?.daysHumanReadable ?? Constants.notAvailableString : value)
                    .foregroundColor(foregroundColor)
                    .font(.title)
                    .bold()
            }
        }
        .frame(width: 150, height: 80)
    }
    
    var foregroundColor: Color {
        switch backgroundColor {
        case .red, .yellow, .blue, .pink, .purple, .black:
            return .white
        default:
            return .black
        }
    }
    
    var backgroundColor: Color {
        switch metric {
        case .active, .totalConfirmed:
            return .yellow
        case .caseFatalityRate, .totalDeaths:
            return .purple
        case .newActive, .totalRecovered:
            return .pink
        case .newConfirmed:
            return .red
        case .newRecovered:
            return .blue
        default:
            return .gray
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Card(metric: .active, value: "100", exponentialProperty: .doublingTime(20))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct SummaryProviderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryProviderDetailView(manager: MockDataManager(), provider: MockData.countries[0].provinces[0])
        
    }
}
