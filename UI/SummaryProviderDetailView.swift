//
//  SummaryProviderDetailView.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 23.10.20.
//

import SwiftUI

struct SummaryProviderDetailView: View {
    let provider: SummaryProvider
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        VStack {
            LazyVGrid(columns: columns) {
                ForEach(MeasurementMetric.allCases) { metric in
                    Card(metric: metric, value: provider.value(for: metric))
                }
            }
            NavigationLink("Future estimations", destination: FutureEstimationProviderView(futureEstimationProvider: FutureEstimationProvider(provider: provider)))
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
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 15)
                .foregroundColor(backgroundColor)
                .opacity(colorScheme == .dark ? 0.7 : 1)
            VStack {
                HStack {
                    Text(metric.humanReadable)
                        .font(.subheadline)
                        .foregroundColor(foregroundColor)
                    Spacer()
                }
                .padding(.horizontal, 5)
                Text(value)
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
            Card(metric: .active, value: "100")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}

struct SummaryProviderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryProviderDetailView(provider: MockData.countries[0].provinces[0])
        
    }
}
