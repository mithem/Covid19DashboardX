//
//  ModelDecodableTests.swift
//  Covid19DashboardXTests
//
//  Created by Miguel Themann on 29.09.20.
//

import XCTest
@testable import Covid19DashboardX

class ModelDecodableTests: XCTestCase {
    var formatter = DateFormatter()
    let decoder = CovidDashApiDotComJSONDecoder()
    let notDecodableMsg = "Unable to decode"
    
    func testProvinceDecoding1() {
        let input = #"{"data": [{"date": "2020-10-22","confirmed": 16810,"deaths": 238,"recovered": 16215,"confirmed_diff": 0,"deaths_diff": 0,"recovered_diff": 0,"last_update": "2020-10-23 04:24:46","active": 357,"active_diff": 0,"fatality_rate": 0.0142,"region": {"iso": "MDG","name": "Madagascar","province": "","lat": "-18.7669","long": "46.8691","cities": []}}]}"#.data(using: .utf8)!
        
        let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2020, month: 10, day: 22))!
        
        let expected = CountryProvincesResponse(data: [ProvinceMeasurementForDecodingOnly(date: date, confirmed: 16810, confirmedDiff: 0, deaths: 238, deathsDiff: 0, recovered: 16215, recoveredDiff: 0, active: 357, activeDiff: 0, fatalityRate: 0.0142, region: ProvinceMeasurementRegionForDecodingOnly(iso: "MDG", name: "Madagascar", province: "", lat: "-18.7669", long: "46.8691"))])
        
        do {
            let result = try decoder.decode(CountryProvincesResponse.self, from: input)
            
            XCTAssertNotNil(result, notDecodableMsg)
            
            XCTAssertEqual(result, expected)
        } catch {
            XCTAssertTrue(false, error.localizedDescription)
        }
    }
    
    func testProvinceDecoding2() {
        let input = #"{"data": [{"date": "2020-10-22","confirmed": 16810,"deaths": 238,"recovered": 16215,"confirmed_diff": 0,"deaths_diff": 0,"recovered_diff": 0,"last_update": "2020-10-23 04:24:46","active": 357,"active_diff": 0,"fatality_rate": 0.0142,"region": {"iso": "MDG","name": "Madagascar","province": "","lat": "","long": "","cities": []}},{"date": "2020-10-22","confirmed": 5,"deaths": 6,"recovered": 7,"confirmed_diff": 8,"deaths_diff": 9,"recovered_diff": 10,"last_update": "2020-10-23 04:24:46","active": 11,"active_diff": 12,"fatality_rate": 0.13,"region": {"iso": "MDH","name": "Madagascar Hills","province": "MadagascarHills","lat": "","long": "","cities": []}}]}"#.data(using: .utf8)!
        
        let date = Calendar.current.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: 2020, month: 10, day: 22))!
        
        let measurement1 = ProvinceMeasurementForDecodingOnly(date: date, confirmed: 16810, confirmedDiff: 0, deaths: 238, deathsDiff: 0, recovered: 16215, recoveredDiff: 0, active: 357, activeDiff: 0, fatalityRate: 0.0142, region: ProvinceMeasurementRegionForDecodingOnly(iso: "MDG", name: "Madagascar", province: "", lat: "", long: ""))
        let measurement2 = ProvinceMeasurementForDecodingOnly(date: date, confirmed: 5, confirmedDiff: 8, deaths: 6, deathsDiff: 9, recovered: 7, recoveredDiff: 10, active: 11, activeDiff: 12, fatalityRate: 0.13, region: ProvinceMeasurementRegionForDecodingOnly(iso: "MDH", name: "Madagascar Hills", province: "MadagascarHills", lat: "", long: ""))
        let expected = CountryProvincesResponse(data: [measurement1, measurement2])
        
        
        let result = try? decoder.decode(CountryProvincesResponse.self, from: input)
        
        XCTAssertNotNil(result, notDecodableMsg)
        
        guard let res = result else { return }
        
        XCTAssertEqual(res, expected)
    }
    
    func testProvinceDecoding3() {
        let input = #"{"data": [{"date": "2020-10-22","confirmed": 65085,"deaths": 1957,"recovered": 51191,"confirmed_diff": 1953,"deaths_diff": 7,"recovered_diff": 1077,"last_update": "2020-10-23 04:24:46","active": 11937,"active_diff": 869,"fatality_rate": 0.0301,"region": {"iso": "DEU","name": "Germany","province": "Baden-Wurttemberg","lat": "48.6616","long": "9.3501","cities": []}},{"date": "2020-10-22","confirmed": 86054,"deaths": 2734,"recovered": 69028,"confirmed_diff": 1964,"deaths_diff": 5,"recovered_diff": 619,"last_update": "2020-10-23 04:24:46","active": 14292,"active_diff": 1340,"fatality_rate": 0.0318,"region": {"iso": "DEU","name": "Germany","province": "Bayern","lat": "48.7904","long": "11.4979","cities": []}},{"date": "2020-10-22","confirmed": 24481,"deaths": 245,"recovered": 17736,"confirmed_diff": 783,"deaths_diff": 2,"recovered_diff": 359,"last_update": "2020-10-23 04:24:46","active": 6500,"active_diff": 422,"fatality_rate": 0.01,"region": {"iso": "DEU","name": "Germany","province": "Berlin","lat": "52.52","long": "13.405","cities": []}},{"date": "2020-10-22","confirmed": 6144,"deaths": 185,"recovered": 4807,"confirmed_diff": 196,"deaths_diff": 2,"recovered_diff": 92,"last_update": "2020-10-23 04:24:46","active": 1152,"active_diff": 102,"fatality_rate": 0.0301,"region": {"iso": "DEU","name": "Germany","province": "Brandenburg","lat": "52.4125","long": "12.5316","cities": []}},{"date": "2020-10-22","confirmed": 4020,"deaths": 63,"recovered": 2683,"confirmed_diff": 152,"deaths_diff": 0,"recovered_diff": 90,"last_update": "2020-10-23 04:24:46","active": 1274,"active_diff": 62,"fatality_rate": 0.0157,"region": {"iso": "DEU","name": "Germany","province": "Bremen","lat": "53.0793","long": "8.8017","cities": []}},{"date": "2020-10-22","confirmed": 10683,"deaths": 283,"recovered": 8102,"confirmed_diff": 276,"deaths_diff": 1,"recovered_diff": 75,"last_update": "2020-10-23 04:24:46","active": 2298,"active_diff": 200,"fatality_rate": 0.0265,"region": {"iso": "DEU","name": "Germany","province": "Hamburg","lat": "53.5511","long": "9.9937","cities": []}},{"date": "2020-10-22","confirmed": 29398,"deaths": 600,"recovered": 21146,"confirmed_diff": 958,"deaths_diff": 7,"recovered_diff": 317,"last_update": "2020-10-23 04:24:46","active": 7652,"active_diff": 634,"fatality_rate": 0.0204,"region": {"iso": "DEU","name": "Germany","province": "Hessen","lat": "50.6521","long": "9.1624","cities": []}},{"date": "2020-10-22","confirmed": 1946,"deaths": 21,"recovered": 1419,"confirmed_diff": 59,"deaths_diff": 0,"recovered_diff": 21,"last_update": "2020-10-23 04:24:46","active": 506,"active_diff": 38,"fatality_rate": 0.0108,"region": {"iso": "DEU","name": "Germany","province": "Mecklenburg-Vorpommern","lat": "53.6127","long": "12.4296","cities": []}},{"date": "2020-10-22","confirmed": 28078,"deaths": 723,"recovered": 22367,"confirmed_diff": 652,"deaths_diff": 3,"recovered_diff": 391,"last_update": "2020-10-23 04:24:46","active": 4988,"active_diff": 258,"fatality_rate": 0.0257,"region": {"iso": "DEU","name": "Germany","province": "Niedersachsen","lat": "52.6367","long": "9.8451","cities": []}},{"date": "2020-10-22","confirmed": 100247,"deaths": 1994,"recovered": 74816,"confirmed_diff": 2740,"deaths_diff": 14,"recovered_diff": 1031,"last_update": "2020-10-23 04:24:46","active": 23437,"active_diff": 1695,"fatality_rate": 0.0199,"region": {"iso": "DEU","name": "Germany","province": "Nordrhein-Westfalen","lat": "51.4332","long": "7.6616","cities": []}},{"date": "2020-10-22","confirmed": 15186,"deaths": 267,"recovered": 11579,"confirmed_diff": 546,"deaths_diff": 2,"recovered_diff": 158,"last_update": "2020-10-23 04:24:46","active": 3340,"active_diff": 386,"fatality_rate": 0.0176,"region": {"iso": "DEU","name": "Germany","province": "Rheinland-Pfalz","lat": "50.1183","long": "7.309","cities": []}},{"date": "2020-10-22","confirmed": 5065,"deaths": 178,"recovered": 3721,"confirmed_diff": 200,"deaths_diff": 0,"recovered_diff": 120,"last_update": "2020-10-23 04:24:46","active": 1166,"active_diff": 80,"fatality_rate": 0.0351,"region": {"iso": "DEU","name": "Germany","province": "Saarland","lat": "49.3964","long": "7.023","cities": []}},{"date": "2020-10-22","confirmed": 12071,"deaths": 272,"recovered": 7956,"confirmed_diff": 564,"deaths_diff": 3,"recovered_diff": 107,"last_update": "2020-10-23 04:24:46","active": 3843,"active_diff": 454,"fatality_rate": 0.0225,"region": {"iso": "DEU","name": "Germany","province": "Sachsen","lat": "51.1045","long": "13.2017","cities": []}},{"date": "2020-10-22","confirmed": 3645,"deaths": 73,"recovered": 2818,"confirmed_diff": 149,"deaths_diff": 2,"recovered_diff": 42,"last_update": "2020-10-23 04:24:46","active": 754,"active_diff": 105,"fatality_rate": 0.02,"region": {"iso": "DEU","name": "Germany","province": "Sachsen-Anhalt","lat": "51.9503","long": "11.6923","cities": []}},{"date": "2020-10-22","confirmed": 6284,"deaths": 164,"recovered": 5116,"confirmed_diff": 137,"deaths_diff": 1,"recovered_diff": 48,"last_update": "2020-10-23 04:24:46","active": 1004,"active_diff": 88,"fatality_rate": 0.0261,"region": {"iso": "DEU","name": "Germany","province": "Schleswig-Holstein","lat": "54.2194","long": "9.6961","cities": []}},{"date": "2020-10-22","confirmed": 5394,"deaths": 201,"recovered": 4294,"confirmed_diff": 144,"deaths_diff": 0,"recovered_diff": 59,"last_update": "2020-10-23 04:24:46","active": 899,"active_diff": 85,"fatality_rate": 0.0373,"region": {"iso": "DEU","name": "Germany","province": "Thuringen","lat": "51.011","long": "10.8453","cities": []}},{"date": "2020-10-22","confirmed": 93,"deaths": 0,"recovered": 0,"confirmed_diff": -5521,"deaths_diff": 0,"recovered_diff": 0,"last_update": "2020-10-23 04:24:46","active": 93,"active_diff": -5521,"fatality_rate": 0,"region": {"iso": "DEU","name": "Germany","province": "Unknown","lat": null,"long": null,"cities": []}}]}"#.data(using: .utf8)!
        
        let result = try? decoder.decode(CountryProvincesResponse.self, from: input)
        
        XCTAssertTrue(result?.data.count ?? 0 > 0)
    }
}

