//
//  MovingAverage.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 08.10.20.
//

import Foundation
struct MovingAverage {
    static private func avg(_ data: [Double]) -> Double { // how would I generalize this?
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
    static func calculateMovingAverage(from data: [Double], with n: Int) -> [Double] {
        if n == 1 {
            return data
        }
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
            result.append(avg(tempAverage))
        }
        return result
    }
}
