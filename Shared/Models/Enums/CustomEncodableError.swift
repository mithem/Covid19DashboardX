//
//  CustomEncodableError.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.12.20.
//

import Foundation

enum CustomEncodableError: Error {
    case other(_ error: Error)
}
