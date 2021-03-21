//
//  invalidateWatchOSComplicationTimeline.swift
//  Covid19DashboardXWatchApp WatchKit Extension
//
//  Created by Miguel Themann on 12.03.21.
//

import Foundation
import WatchConnectivity

/// Send message to watch to reload timelines for all complications
func invalidateWatchOSComplicationTimeline() {
    if WCSession.isSupported() {
        let session = WCSession.default
        session.delegate = iOSWatchConnectivitySessionDelegate.instance
        session.activate()
        iOSWatchConnectivitySessionDelegate.instance.send(.invalidateTimelines)
        print("Sent invalidation msg.")
    }
}
