//
//  MockDataManager.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

class MockDataManager: DataManager {
    static var forceError: Error? = nil
    
    override class func getSummary(completion: @escaping (Result<SummaryResponse, NetworkError>) -> Void) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success(MockData.summaryResponse))
        }
    }
    
    override class func getHistoryData(for country: Country, completion: @escaping (Result<(Country, [CountryHistoryMeasurementForDecodingOnly]), NetworkError>) -> Void) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success((MockData.countries[0], MockData.countryHistoryMeasurementsForDecodingOnly)))
        }
    }
    
    override class func getProvinceData(for country: Country, at date: Date? = nil, completion: @escaping DataManager.GetCountryDataCompletionHandler) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success(MockData.countries[0]))
        }
    }
    
    override class func getDetailedCountryData(for country: Country, at date: Date? = nil, completion: @escaping DataManager.GetCountryDataCompletionHandler) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success(MockData.countries[0]))
        }
    }
}
