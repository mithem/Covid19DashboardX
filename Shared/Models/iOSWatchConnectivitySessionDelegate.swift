//
//  iOSWatchConnectivitySessionDelegate.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 12.03.21.
//

import Foundation
import WatchConnectivity

class iOSWatchConnectivitySessionDelegate: NSObject, WCSessionDelegate {
    static let instance: iOSWatchConnectivitySessionDelegate = .init()
    var session: WCSession?
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        self.session = session
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    func send(_ msg: Message) {
        session?.sendMessage(msg.body, replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    enum Message {
        case invalidateTimelines
        
        var body: [String: String] {
            switch self {
            case .invalidateTimelines:
                return ["message": "invalidate timelines"]
            }
        }
    }
}
