//
//  UsefulURLs.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 21.11.20.
//

import Foundation

struct UsefulURLs {
    static let whoCovid19AdviceForPublic = URL(string: "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/advice-for-public")!
    static let repoURL = URL(string: "https://github.com/mithem/Covid19DashboardX")!
    static let newFeatureSuggestion = URL(string: "https://github.com/mithem/Covid19DashboardX/issues/new?title=[FEAT]&labels=feature")!
    static let newBugReport = URL(string: "https://github.com/mithem/Covid19DashboardX/issues/new?title=[BUG]&labels=bug")!
    static let mailToMe = URL(string: "mailto:mithem@github.com.com")!
    static let covid19apiDotCom = URL(string: "https://covid19api.com")!
    static let covidDashApiDotCom = URL(string: "https://covid-api.com")!
    static let cellularSettings = URL(string: "prefs:root=MOBILE_DATA_SETTINGS_ID&path=CELLULAR_DATA_OPTIONS")!
    static let notificationSettings = URL(string: "prefs:root=NOTIFICATIONS_ID")!
}
