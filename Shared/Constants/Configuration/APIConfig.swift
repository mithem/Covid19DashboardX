//
//  APIConfig.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

struct APIConfig {
    /// api.covid19api.com
    struct Provider1: APIProvider {
        static let userDisplayableName = "api.covid19api.com"
        static let baseURL = URL(string: "https://api.covid19api.com")!
        
        struct summary: APIEndpoint {
            typealias DataType = SummaryResponse
            typealias FallbackDataType = ServerCachingInProgressResponse
            static var ignoreLowDataMode = true
            static var url = "https://api.covid19api.com/summary"
        }
        
        struct total {
            struct country: APIEndpoint {
                typealias DataType = [CountryHistoryMeasurementForDecodingOnly]
                typealias FallbackDataType = [CountryHistoryMeasurementForDecodingOnly]
                static var ignoreLowDataMode = false
                static var url = "https://api.covid19api.com/total/country"
            }
        }
    }
    
    /// covid-api.com
    struct Provider2: APIProvider {
        
        static var userDisplayableName = "covid-api.com"
        static var baseURL = URL(string: "https://covid-api.com")!
        
        struct api {
            
            struct reports: APIEndpoint {
                
                struct total: APIEndpoint {
                    typealias DataType = GlobalMeasurementResponse
                    typealias FallbackDataType = GlobalMeasurementResponse
                    static var ignoreLowDataMode = true
                    static var url = "https://covid-api.com/api/reports/total"
                }
                
                typealias DataType = CountryProvincesResponse
                typealias FallbackDataType = CountryProvincesResponse
                static var ignoreLowDataMode = false
                static var url = "https://covid-api.com/api/reports"
                
            }
            
        }
    }
}
