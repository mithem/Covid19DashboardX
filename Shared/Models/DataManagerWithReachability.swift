//
//  DataManagerWithReachability.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 05.01.21.
//

import Foundation
#if !os(watchOS)
import Reachability
#endif

/// Needed as is isn't possible to declare properties like reachability potentially unavailable
@available(iOS 14, *)
final class DataManagerWithReachablity: DataManager {
    private let reachability: Reachability
    
    override init() {
        self.reachability = try! Reachability()
        
        super.init()
        
        self.reachability.whenReachable = { reachability in
            if reachability.connection != .unavailable {
                if self.error == .some(.constrainedNetwork) || self.error == .some(.noNetworkConnection) {
                    DispatchQueue.main.async {
                        self.error = nil
                    }
                }
                for task in self._pendingTasks {
                    self.execute(task: task)
                }
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Couldn't start Reachability notifier: \(error.localizedDescription)")
        }
        
        if reachability.connection == .unavailable {
            DispatchQueue.main.async {
                self.error = .noNetworkConnection
                self.loadingTasks = .init()
                self._pendingTasks.insert(.summary)
                self._pendingTasks.insert(.globalSummary)
            }
        } else {
            execute(task: .summary)
            execute(task: .globalSummary)
        }
    }
}
