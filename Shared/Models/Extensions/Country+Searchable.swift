//
//  Country+Searchable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension Country: Searchable {
    func isIncluded(searchTerm: String) -> Bool {
        if searchTerm.isEmpty { return true }
        return name.lowercased().contains(searchTerm) || searchTerm.contains(code.lowercased())
    }
}
