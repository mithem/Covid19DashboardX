//
//  WCSession+send.swift
//  Covid19DashboardX (iOS)
//
//  Created by Miguel Themann on 24.03.21.
//

import Foundation
import WatchConnectivity

extension WCSession {
    func send(_ msg: MessageForWatch) {
        sendMessage(msg.dictionary(), replyHandler: nil)
    }
}
