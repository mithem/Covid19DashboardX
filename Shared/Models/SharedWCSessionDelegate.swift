//
//  SharedWCSessionDelegate.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 26.03.21.
//

import WatchConnectivity
import ClockKit

class SharedWCSessionDelegate: NSObject, WCSessionDelegate {
    
    static var instance: SharedWCSessionDelegate { .init() }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        session.delegate = self
    }
    
    #if os(watchOS)
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        guard let msg = MessageForWatch(message) else {
            NSLog("Invalid message received: \(message)")
            return
        }
        switch msg {
        case .reloadComplications:
            let server = CLKComplicationServer.sharedInstance()
            for complication in server.activeComplications ?? [] {
                server.reloadTimeline(for: complication)
            }
        }
    }
    #endif
}

@available(iOS 14, *)
extension SharedWCSessionDelegate {
    func sessionDidDeactivate(_ session: WCSession) {}
    func sessionDidBecomeInactive(_ session: WCSession) {}
}
