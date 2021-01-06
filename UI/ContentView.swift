//
//  ContentView.swift
//  Shared
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        #if os(watchOS)
        SummaryView(manager: DataManager())
        #else
        SummaryView(manager: DataManagerWithReachablity())
        #endif
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
