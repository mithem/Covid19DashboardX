//
//  APIProvider.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 13.12.20.
//

import Foundation

protocol APIProvider {
    static var userDisplayableName: String { get }
    static var baseURL: URL { get }
}
