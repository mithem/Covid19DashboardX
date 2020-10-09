//
//  DataStreamAnalyizer.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 08.10.20.
//

import Foundation

struct DataStreamAnalyzer {
    let originalData: [Double]
    private var _movingAvgs: Set<MovingAverage>
    var movingAvgs: Set<MovingAverage> {
        get { _movingAvgs }
        set {
            _movingAvgs = newValue
        }
    }
    
    init(originalData: [Double], movingAvgs: Set<MovingAverage> = Set()) {
        self.originalData = originalData
        self._movingAvgs = movingAvgs
    }
    
    struct MovingAverage: Hashable, Identifiable {
        var id: Int { n }
        func hash(into hasher: inout Hasher) { // only hash n so there is only one movingAvg per n
            hasher.combine(n)
        }
        
        let n: Int
        private var _data: [Double]
        var data: [Double] {
            get { _data }
            set {
                _data = _calculateMovingAverage(from: newValue)
            }
        }
        
        /// Initiialize MovingAverage with raw/original data
        /// - Parameters:
        ///   - n: n
        ///   - data: raw/originial data to calculate avgs from
        init(n: Int, data: [Double]) {
            self.n = n
            self._data = []
            self.data = data
        }
        
        func _avg(_ data: [Double]) -> Double { // how would I generalize this?
            var sum = 0.0
            for value in data {
                sum += value
            }
            return Double(sum) / Double(data.count)
        }
        
        /// Calculate moving avg for each point by calculating the avg from the **surrounding** (-n/2 to +n/2) data points
        /// - Parameter data: original data
        /// - Returns: (shorter) moving avg array
        /// - Complexity: Bad, like really bad (O(n*datalength))
        func _calculateMovingAverage(from data: [Double]) -> [Double] {
            let nHalfed = Double(n) / 2.0
            let negSpectrum: Int
            let posSpectrum: Int
            if nHalfed.truncatingRemainder(dividingBy: 2) == 1 {
                posSpectrum = Int(nHalfed - 1)
                negSpectrum =  -1 * Int(nHalfed + 1)
            } else {
                posSpectrum = Int(nHalfed)
                negSpectrum = -1 * Int(nHalfed)
            }
            var result = [Double]()
            var tempAverage: [Double]
            var idx: Int
            for cursor in 0..<data.count {
                tempAverage = []
                for nMinus in negSpectrum...posSpectrum {
                    idx = cursor + nMinus
                    if idx < 0 { continue }
                    if idx >= data.count { continue }
                    let someData = data[idx]
                    tempAverage.append(someData)
                }
                result.append(_avg(tempAverage))
            }
            return result
        }
    }
}
