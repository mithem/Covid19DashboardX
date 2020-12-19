//
//  FutureEstimationProvider.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 17.12.20.
//

import Foundation

class FutureEstimationProvider: ObservableObject {
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
        let a: Double
        let k: Double
        
        func estimationFunction(t: Double) -> Double {
            return a * pow(Double.eulersNumber, k * t)
        }
        
        init(cases: Int, new: Int) {
            
            // f(t) = ae^(kt)
            // f(t) / a = e^(kt)
            // kt = ln(f(t) / a)
            // k = ln(f(t) / a) / t
            
            let a = Double(cases)
            let y = Double(cases - new) // previous day's cases
            let t = -1.0 // f(x) one day before coordinate system center (current cases)
            
            let k = ln(y / a) / t
            
            self.init(a: a, k: k)
        }
        
        init(a: Double, k: Double) {
            self.a = a
            self.k = k
        }
    }
    
    // MARK: Life cycle
    
    init(provider: SummaryProvider, estimationInterval: Int, metric: BasicMeasurementMetric) {
        self.provider = provider
        self.estimationInterval = estimationInterval
        self.metric = metric
    }
    
    convenience init(provider: SummaryProvider) {
        let ud = UserDefaults()
        var eI = ud.integer(forKey: UserDefaultsKeys.estimationInterval)
        if eI == 0 {
            eI = 1
        }
        let ms = ud.string(forKey: UserDefaultsKeys.activeMetric) ?? ""
        let m = BasicMeasurementMetric(rawValue: ms) ?? .confirmed
        self.init(provider: provider, estimationInterval: eI, metric: m)
    }
}
