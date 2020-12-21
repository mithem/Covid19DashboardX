//
//  FutureEstimationProvider.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 17.12.20.
//

import Foundation

class FutureEstimationProvider<Provider: SummaryProvider>: ObservableObject {
    let provider: Provider
    @Published var estimationInterval: Int
    @Published var metric: BasicMeasurementMetric
    
    typealias IntersectionPoint = (t: Double, y: Double)
    
    var data: [Double]? {
        let v = values()
        guard let cases = v.cases else { return nil }
        guard let new = v.new else { return nil }
        let function = EstimationFunction(cases: cases, new: new)
        return (0...estimationInterval).map {function.value(t: Double($0))}
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
        
        func value(t: Double) -> Double {
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
        
        func intersection(with f: EstimationFunction) -> IntersectionPoint {
            // ae^(kt) = be^(lt) | wolframalpha
            // t = (ln(b) - ln(a)) / (k - l)
            
            let t = (ln(f.a) - ln(a)) / (k - f.k)
            
            return (t: t, y: value(t: t))
        }
    }
    
    func intersection(with p: FutureEstimationProvider) -> IntersectionPoint? {
        let v1 = values()
        guard let c1 = v1.cases else { return nil }
        guard let n1 = v1.new else { return nil }
        let f1 = EstimationFunction(cases: c1, new: n1)
        
        let v2 = p.values()
        guard let c2 = v2.cases else { return nil }
        guard let n2 = v2.new else { return nil }
        let f2 = EstimationFunction(cases: c2, new: n2)
        
        return f1.intersection(with: f2)
    }
    
    // MARK: Life cycle
    
    init(provider: Provider, estimationInterval: Int, metric: BasicMeasurementMetric) {
        self.provider = provider
        self.estimationInterval = estimationInterval
        self.metric = metric
    }
    
    convenience init(provider: Provider) {
        let ud = UserDefaults()
        var eI = ud.integer(forKey: UserDefaultsKeys.estimationInterval)
        if eI == 0 {
            eI = 1
        }
        let ms = ud.string(forKey: UserDefaultsKeys.measurementMetric) ?? ""
        let m = BasicMeasurementMetric(rawValue: ms) ?? .confirmed
        self.init(provider: provider, estimationInterval: eI, metric: m)
    }
}
