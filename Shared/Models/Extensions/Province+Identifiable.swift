//
//  Province+Identifiable.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

extension Province: Identifiable {
    var id: String { name }
}
