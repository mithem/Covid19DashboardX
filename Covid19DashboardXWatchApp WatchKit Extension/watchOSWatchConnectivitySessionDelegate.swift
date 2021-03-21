//
//  watchOSWatchConnectivitySessionDelegate.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.03.21.
//

import Foundation
import WatchConnectivity

class watchOSWatchConnectivitySessionDelegate: NSObject, WCSessionDelegate {
    static var instance: watchOSWatchConnectivitySessionDelegate { .init() }
    var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
}
