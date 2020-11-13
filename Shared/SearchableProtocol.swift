//
//  SearchableProtocol.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 13.11.20.
//

import Foundation

/// Indicates that an object is intended to be found in a list of the same type. Methods wil be called with a lowercased search term.
protocol Searchable {
    func isIncluded(searchTerm: String) -> Bool
    func isIncluded(_ searchTerm: String) -> Bool
}

extension Searchable {
    func isIncluded(_ searchTerm: String) -> Bool {
        return isIncluded(searchTerm: searchTerm)
    }
}
