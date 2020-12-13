//
//  MockDataManager.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 22.11.20.
//

import Foundation

class MockDataManager: DataManager {
    static var forceError: Error? = nil
    
    override class func getSummary(completion: @escaping (Data?, NetworkError?) -> Void) {
        if let error = NetworkError(error: forceError) {
            switch NetworkError(error: error) {
            case .cachingInProgress:
                let data = ServerCachingInProgressResponse().encode()
                completion(data, nil)
            default:
                completion(nil, error)
            }
        } else {
            completion(MockData.summaryResponse.encode(), nil)
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
