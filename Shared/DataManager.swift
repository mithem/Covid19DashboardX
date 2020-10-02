//
//  DataManager.swift
//  Covid19DashboardX
//
//  Created by Miguel Themann on 15.08.20.
//

import Foundation

class DataManager: ObservableObject {
    @Published var latestMeasurements: [CountryMeasurement]
    @Published var latestGlobal: GlobalMeasurement?
    private var subscribers: [DataManagerSubscriber]
    
    func loadFromApi() {
        guard let url = URL(string: "https://api.covid19api.com/summary") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromPascalCase
                decoder.dateDecodingStrategy = .iso8601
                let serverResponse = try? decoder.decode(Response.self, from: data)
                if let serverResponse = serverResponse {
                    DispatchQueue.main.async {
                        self.latestMeasurements = serverResponse.countries
                        self.latestGlobal = serverResponse.global
                    }
                    for subscriber in self.subscribers {
                        subscriber.managerDidUpdateMeasurements()
                    }
                } else {
                    print("Invalid response.")
                }
            } else {
                print("No response.")
            }
        }.resume()
    }
    
    func subscribe(_ someone: DataManagerSubscriber) {
        subscribers.append(someone)
    }
    
    init() {
        latestMeasurements = [CountryMeasurement]()
        subscribers = [DataManagerSubscriber]()
        latestGlobal = nil
    }
}

protocol DataManagerSubscriber {
    func managerDidUpdateMeasurements()
}
