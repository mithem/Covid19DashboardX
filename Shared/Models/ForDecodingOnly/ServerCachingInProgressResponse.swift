//
//  ServerCachingInProgressResponse.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 11.12.20.
//

import Foundation

struct ServerCachingInProgressResponse: CustomCodable, Equatable {
    typealias Decoder = CustomJSONDecoder
    typealias Encoder = CustomJSONEncoder
    
    let message: String
    
    init(message: String) {
        self.message = message
    }
    
    init() {
        self.init(message: "Caching in progress")
    }
}
