//
//  SummaryView.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import SwiftUI
import Reachability
import UserNotifications

struct SummaryView: View {
    
    @ObservedObject var manager: DataManager
    @State private var showingActionSheet = false
    @State private var actionSheetConfig = ActionSheetConfig.sort
    @State private var searchTerm = ""
    @State private var favorites = [String]()
    @State private var lowercasedSearchTerm = ""
    
    @AppStorage(UserDefaultsKeys.activeMetric) var activeMetric = DefaultSettings.measurementMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorPercentagesTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorPercentagesGrayArea = DefaultSettings.colorGrayAreaForPercentages
    @AppStorage(UserDefaultsKeys.colorTresholdForDeltas) var colorDeltaTreshold = DefaultSettings.colorTresholdForDeltas
    @AppStorage(UserDefaultsKeys.colorGrayAreaForDeltas) var colorDeltaGrayArea = DefaultSettings.colorGrayAreaForDeltas
    
    init() {
        self.manager = DataManager()
    }
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("Refresh")) {manager.execute(task: .summary)}, .default(Text("Country code"), action: {manager.sortBy = .countryCode}), .default(Text("Country name"), action: {manager.sortBy = .countryName})]
        
        let confirmed: [ActionSheet.Button] = [.default(Text("Total confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("New confirmed"), action: {manager.sortBy = .newConfirmed})]
        let deaths: [ActionSheet.Button] = [.default(Text("Total deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("New deaths"), action: {manager.sortBy = .newDeaths})]
        let recovered: [ActionSheet.Button] = [.default(Text("Total recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("New recovered"), action: {manager.sortBy = .newRecovered})]
        let active: [ActionSheet.Button] = [.default(Text("Active cases"), action: {manager.sortBy = .activeCases})]
        
        switch activeMetric {
        case .confirmed:
            buttons.append(contentsOf: confirmed)
        case .deaths:
            buttons.append(contentsOf: deaths)
        case .recovered:
            buttons.append(contentsOf: recovered)
        case .active:
            buttons.append(contentsOf: active)
        }
        
        buttons.append(contentsOf: [.default(Text(manager.reversed ? "Dereverse" : "Reverse"), action: {manager.reversed.toggle()}), .cancel()])
        
        return buttons
    }
    
    var actionSheet: ActionSheet {
        switch actionSheetConfig {
        case .sort:
            return ActionSheet(title: Text("Sort countries"), message: Text("By which criteria would you like to sort countries?"), buttons: actionSheetButtonsForSorting)
        case .error:
            return ActionSheet(title: Text("Unable to load data"), message: Text(manager.error?.localizedDescription ?? "unkown error."), buttons: [.default(Text("OK"))])
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !manager.countries.isEmpty {
                    CountriesView
                } else if manager.loading {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("Loading...")
                    }
                } else if let error = manager.error {
                    if error == NetworkError.cachingInProgress {
                        VStack {
                            Text("The server is currently caching the newest data. Please try again in a bit.")
                            RefreshButton
                        }
                    } else {
                        Text(error.localizedDescription)
                            .padding()
                    }
                } else {
                    VStack {
                        Text("🤷 No data")
                        RefreshButton
                    }
                }
            }
            .actionSheet(isPresented: $showingActionSheet) {
                actionSheet
            }
            .onChange(of: searchTerm) { value in
                lowercasedSearchTerm = value.lowercased()
            }
            .onAppear {
                if manager.error != nil && manager.error != .constrainedNetwork {
                    actionSheetConfig = .error
                    showingActionSheet = true
                }
                removeNotifications()
            }
            .navigationBarItems(leading:
                                    Button(action: {
                                        actionSheetConfig = .sort
                                        showingActionSheet = true
                                    }) {
                                        Image(systemName: "arrow.up.arrow.down")
                                            .padding(UIConstants.navigationBarItemsPadding)
                                    }.onLongPressGesture {
                                        manager.reversed.toggle()
                                    }
                                    .hoverEffect(),
                                trailing:
                                    NavigationLink(destination: SettingsView(manager: manager)) {
                                        Image(systemName: "gear")
                                            .padding(UIConstants.navigationBarItemsPadding)
                                    }
            )
            .navigationTitle("Covid19 Summary")
        }
    }
    
    var RefreshButton: some View {
        Button("Refresh") {
            manager.execute(task: .summary)
        }
        .buttonStyle(CustomButtonStyle())
    }
    
    var CountriesView: some View {
        VStack {
            List {
                BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
                SearchBar(searchTerm: $searchTerm)
                if let latestGlobal = manager.latestGlobal {
                    NavigationLink(destination: SummaryProviderDetailView(provider: latestGlobal)) {
                        Text("Global: ") + (latestGlobal.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorPercentagesTreshold, colorDeltaGrayArea: colorPercentagesGrayArea, reversed: false))
                    }
                    .modifier(AttachToRefreshContextMenu(manager: manager))
                } else if manager.loading {
                    HStack {
                        Text("Global: loading…")
                        ProgressView()
                    }
                }
                ForEach(manager.countries.filter { c in
                    c.isIncluded(lowercasedSearchTerm)
                }, id: \.code) { country in
                    CountryInlineView(country: country, colorNumbers: colorNumbers, colorDeltaTreshold: colorDeltaTreshold, colorDeltaGrayArea: colorDeltaGrayArea, activeMetric: $activeMetric, manager: manager)
                        .modifier(AttachToRefreshContextMenu(manager: manager))
                }
                HStack {
                    Spacer()
                    Text("Stay safe ❤️")
                        .foregroundColor(.secondary)
                        .grayscale(0.35)
                    Spacer()
                }
                .onTapGesture {
                    UIApplication.shared.open(UsefulURLs.whoCovid19AdviceForPublic)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .animation(.easeInOut)
        }
    }
    
    func removeNotifications() {
        let ud = UserDefaults()
        guard let identifiers = ud.stringArray(forKey: UserDefaultsKeys.notificationIdentifiers) else { return }
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: identifiers) // Do not remove all for future-proofing
        ud.set([String](), forKey: UserDefaultsKeys.notificationIdentifiers)
    }
}

fileprivate struct AttachToRefreshContextMenu: ViewModifier {
    @ObservedObject var manager: DataManager
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: {
                    manager.execute(task: .summary)
                }) {
                    Text("Refresh summaries")
                    Image(systemName: "arrow.clockwise")
                }
                Button(action: {
                    DispatchQueue.main.async {
                        manager.countries = []
                    }
                    manager.execute(task: .summary)
                }) {
                    Text("Reset all data")
                    Image(systemName: "trash")
                }
            }
    }
}

fileprivate enum ActionSheetConfig {
    case sort, error
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView()
    }
}
