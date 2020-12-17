//
//  FutureEstimationProvider.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 17.12.20.
//

import Foundation

class FutureEstimationProvider {
    let provider: SummaryProvider
    @Published var estimationInterval: Int
    @Published var metric: BasicMeasurementMetric
    
    var data: [Double]? {
        let v = values()
        guard let cases = v.cases else { return nil }
        guard let new = v.new else { return nil }
        let function = EstimationFunction(cases: cases, new: new)
        return (0...estimationInterval).map {function.estimationFunction(t: Double($0))}
    }
    
    private func values() -> (cases: Int?, new: Int?) {
        switch metric {
        case .confirmed:
            return (cases: provider.totalConfirmed, new: provider.newConfirmed)
        case .deaths:
            return (cases: provider.totalDeaths, new: provider.newDeaths)
        case .recovered:
            return (cases: provider.totalRecovered, new: provider.newRecovered)
        case .active:
            return (cases: provider.activeCases, new: provider.newActive)
        }
    }

    struct EstimationFunction {
        let k: Double
        
        func estimationFunction(t: Double) -> Double {
            return pow(Double.eulersNumber, k * t)
        }
        
        init(cases: Int, new: Int) {
            
            // f(x) = ae^(kt)
            // f(x) / a = e^(kt)
            // kt = ln(f(x) / a)
            // k = ln(f(x) / a) / t
            
            let a = Double(cases)
            let y = Double(cases - new) // previous day's cases
            let t = -1.0 // f(x) one day before coordinate system center (current cases)
            
            let k = ln(y / a) / t
            
            self.init(k: k)
        }
        
        init(k: Double) {
            self.k = k
        }
    }
    
    // MARK: Life cycle
    
    init(provider: SummaryProvider, estimationInterval: Int, metric: BasicMeasurementMetric) {
        self.provider = provider
        self.estimationInterval = estimationInterval
        self.metric = metric
    }
}
