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
    @State private var scaleOrderAndRefreshBtn = false
    
    @AppStorage(UserDefaultsKeys.measurementMetric) var activeMetric = DefaultSettings.measurementMetric
    @AppStorage(UserDefaultsKeys.colorNumbers) var colorNumbers = DefaultSettings.colorNumbers
    @AppStorage(UserDefaultsKeys.colorThresholdForPercentages) var colorPercentagesTreshold = DefaultSettings.colorTresholdForPercentages
    @AppStorage(UserDefaultsKeys.colorGrayAreaForPercentages) var colorPercentagesGrayArea = DefaultSettings.colorGrayAreaForPercentages
    @AppStorage(UserDefaultsKeys.colorTresholdForDeltas) var colorDeltaTreshold = DefaultSettings.colorTresholdForDeltas
    @AppStorage(UserDefaultsKeys.colorGrayAreaForDeltas) var colorDeltaGrayArea = DefaultSettings.colorGrayAreaForDeltas
    
    var actionSheetButtonsForSorting: [ActionSheet.Button] {
        var buttons: [ActionSheet.Button] = [.default(Text("refresh")) {manager.execute(task: .summary)}, .default(Text("country_code"), action: {manager.sortBy = .countryCode}), .default(Text("country_name"), action: {manager.sortBy = .countryName})]
        
        let confirmed: [ActionSheet.Button] = [.default(Text("total_confirmed"), action: {manager.sortBy = .totalConfirmed}), .default(Text("new_confirmed"), action: {manager.sortBy = .newConfirmed})]
        let deaths: [ActionSheet.Button] = [.default(Text("total_deaths"), action: {manager.sortBy = .totalDeaths}), .default(Text("new_deaths"), action: {manager.sortBy = .newDeaths})]
        let recovered: [ActionSheet.Button] = [.default(Text("total_recovered"), action: {manager.sortBy = .totalRecovered}), .default(Text("new_recovered"), action: {manager.sortBy = .newRecovered})]
        let active: [ActionSheet.Button] = [.default(Text("active_cases"), action: {manager.sortBy = .activeCases})]
        
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
        
        buttons.append(contentsOf: [.default(Text(manager.reversed ? "dereverse" : "reverse"), action: {manager.reversed.toggle()}), .cancel()])
        
        return buttons
    }
    
    var actionSheet: ActionSheet {
        switch actionSheetConfig {
        case .sort:
            return ActionSheet(title: Text("sort_countries"), message: Text("sort_countries_criteria_question"), buttons: actionSheetButtonsForSorting)
        case .error:
            return ActionSheet(title: Text("unable_to_load_data"), message: Text(manager.error?.localizedDescription ?? "unkown_error_period"), buttons: [.default(Text("ok"))])
        }
    }
    
    var body: some View {
        NavigationView {
            Group {
                if !manager.countries.isEmpty {
                    CountriesView
                } else if manager.loadingTasks.contains(.summary) {
                    VStack(spacing: 10) {
                        ProgressView()
                        Text("loading.uppercase")
                    }
                } else if let error = manager.error {
                    if error == NetworkError.cachingInProgress {
                        VStack {
                            Text("server_is_caching")
                            RefreshButton
                        }
                    } else {
                        Text(error.localizedDescription)
                            .padding()
                    }
                } else {
                    VStack {
                        Text("no_data_present")
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
                initScalingTimer()
            }
            .navigationBarItems(leading:
                                    Button(action: {
                                        actionSheetConfig = .sort
                                        showingActionSheet = true
                                    }) {
                                        Image(systemName: "arrow.up.arrow.down")
                                            .padding(UIConstants.navigationBarItemsPadding)
                                            .scaleEffect(scaleOrderAndRefreshBtn ? 1.5 : 1)
                                            .animation(.interpolatingSpring(mass: 0.1, stiffness: 1, damping: 0.25))
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
            .navigationTitle("summary_view_nav_title")
        }
    }
    
    var RefreshButton: some View {
        Button("refresh") {
            refresh()
        }
        .buttonStyle(CustomButtonStyle())
    }
    
    var CountriesView: some View {
        VStack {
            List {
                BasicMeasurementMetricPickerView(activeMetric: $activeMetric)
                SearchBar(searchTerm: $searchTerm)
                if let latestGlobal = manager.latestGlobal {
                    NavigationLink(destination: SummaryProviderDetailView(manager: manager, provider: latestGlobal)) {
                        Text("global_colon") + (latestGlobal.summaryFor(metric: activeMetric, colorNumbers: colorNumbers, colorDeltaTreshold: colorPercentagesTreshold, colorDeltaGrayArea: colorPercentagesGrayArea, reversed: false))
                    }
                    .modifier(AttachToRefreshContextMenu(manager: manager))
                } else if manager.loadingTasks.contains(.globalSummary) {
                    HStack {
                        Text("global_colon_loading")
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
                    Text("stay_safe")
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
    
    func refresh() {
        refreshSummaries(on: manager)
    }
    
    func initScalingTimer() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { timer in
            if manager.error != nil {
                scaleOrderAndRefreshBtn.toggle()
            } else {
                scaleOrderAndRefreshBtn = false
            }
        }
    }
}

fileprivate struct AttachToRefreshContextMenu: ViewModifier {
    @ObservedObject var manager: DataManager
    func body(content: Content) -> some View {
        content
            .contextMenu {
                Button(action: {
                    refreshSummaries(on: manager)
                }) {
                    Text("refresh_summaries")
                    Image(systemName: "arrow.clockwise")
                }
                Button(action: {
                    DispatchQueue.main.async {
                        manager.reset()
                    }
                    refreshSummaries(on: manager)
                }) {
                    Text("reset_all_data")
                    Image(systemName: "trash")
                }
            }
    }
}

fileprivate enum ActionSheetConfig {
    case sort, error
}

fileprivate func refreshSummaries(on manager: DataManager) {
    manager.execute(task: .summary)
    manager.execute(task: .globalSummary)
}

struct SummaryView_Previews: PreviewProvider {
    static var previews: some View {
        SummaryView(manager: MockDataManager())
    }
}
