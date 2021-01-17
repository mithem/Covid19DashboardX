//
//  MockDataManager.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

final class MockDataManager: DataManager {
    static var forceError: Error? = nil
    
    override class func getSummary(completion: @escaping (Result<SummaryResponse, NetworkError>) -> Void) {
        if let error = NetworkError(error: forceError) {
            completion(.failure(error))
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
    
    override class func getProvinceData(for country: Country, at date: Date? = nil, completion: @escaping (Result<CountryProvincesResponse, NetworkError>) -> Void) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success(MockData.countryProvincesResponse))
        }
    }
    
    override class func getGlobalSummary(completion: @escaping (Result<GlobalMeasurement, NetworkError>) -> Void) {
        if let error = forceError {
            completion(.failure(.init(error: error)))
        } else {
            completion(.success(MockData.latestGlobalFromSummaryResponse))
        }
    }
}
