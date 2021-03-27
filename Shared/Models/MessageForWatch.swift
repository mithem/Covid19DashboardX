//
//  MessageForWatch.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 24.03.21.
//

import Foundation

enum MessageForWatch: String, Codable {
    case reloadComplications
    
    func dictionary() -> [String: String] {
        return ["message": self.rawValue]
    }
    
    init?(_ dict: [String: Any]) {
        guard let dict = dict as? [String: String] else { return nil }
        guard let msg = dict["message"] else { return nil }
        self.init(rawValue: msg)
    }
}
