//
//  PassengerData.swift
//  AvoidCoronaApp
//
//  Created by 정주현 on 2020/06/07.
//  Copyright © 2020 Azderica. All rights reserved.
//

import Foundation

struct PassengerData {
    private(set) var locations = [PassengerLocation]()
    
    private func getJsonData(forDataType dataType: LocationData) -> [PassengerLocation] {
        var locationsFromJson = [PassengerLocation]()
        let fileName: String
        let stationAttribute: String
        
        switch dataType {
        case .busData:
            fileName = "busdata"
            stationAttribute = "busstop"
        case .subwayData:
            fileName = "subwaydata"
            stationAttribute = "station"
        }
        
        do {
            // Get the data: latitude/longitude positions of police stations.
            if let path = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: path)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [[String: Any]] {
                    for item in object {
                        guard let station = item[stationAttribute] as? String, let lat = item["lat"] as? String, let long = item["long"] as? String, let passengers = item["passengers"] as? Int else {
                            print("Problem unpacking JSON data.")
                            throw JsonUnpackingError.couldNotCast
                        }
                        let passengerLocation = dataType == .busData ? PassengerLocation.busStation(station, Double(lat)!, Double(long)!, passengers) :
                            PassengerLocation.subwayStation(station, Double(lat)!, Double(long)!, passengers)
        
                        locationsFromJson.append(passengerLocation)
                    }
                } else {
                    print("Could not read the JSON.")
                }
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return locationsFromJson
    }

    init() {
        locations.append(contentsOf: getJsonData(forDataType: .busData))
        locations.append(contentsOf: getJsonData(forDataType: .subwayData))
    }

    enum JsonUnpackingError: Error {
        case couldNotCast
    }

    enum PassengerLocation {
        case busStation(String, Double, Double, Int)
        case subwayStation(String, Double, Double, Int)
    }
    
    enum LocationData {
        case busData
        case subwayData
    }
}
