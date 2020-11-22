//
//  Constants.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct Constants {
    static let notAvailableString = "N/A"
    static let covidDashApiDotComDateFormat = "YYYY-mm-DD"
    
    
    /// A dictionary mapping ISO Alpha2 country-codes to Alpha3 ones
    /// https://stackoverflow.com/questions/11576947/ios-convert-iso-alpha-2-to-alpha-3-country-code
    static let alpha2_to_alpha3_countryCodes = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "ISO_CountryCodes", ofType: "plist")!)!
    
    
    struct NotificationIdentifiers {
        static let reminder = "com.mithem.Covid19DashboardX.notification.reminder"
    }
}
