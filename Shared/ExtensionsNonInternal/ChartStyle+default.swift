//
//  ChartStyle+default.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 15.02.21.
//

import SwiftUI
import SwiftUICharts

extension ChartStyle {
    static var `default`: ChartStyle {
        .init(backgroundColor: .primary, foregroundColor: .orangeBright)
    }
}

struct ChartStylePreviewProvider: PreviewProvider {
    static var previews: some View {
        LineChart()
            .data([2.3, 1, 6.7, 3.5])
            .chartStyle(.default)
    }
}
