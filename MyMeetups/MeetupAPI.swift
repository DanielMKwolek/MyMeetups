//
//  MeetupAPI.swift
//  MyMeetups
//
//  Created by Daniel Kwolek on 9/28/16.
//  Copyright © 2016 Arcore. All rights reserved.
//

import Foundation
import CoreData

struct MeetupAPIConfiguration {
    let apiKey: String
    let baseURL: String
    
    init() {
        let bundle = Bundle.main
        guard let plistURL = bundle.url(forResource: "MeetupConfig", withExtension: "plist"), let plistData = try? Data.init(contentsOf: plistURL), let plistAny = try? PropertyListSerialization.propertyList(from: plistData, options: [], format: nil), let plist = plistAny as? [String: Any] else {
            fatalError("Could not load MeetupConfig.plist")
        }
        self.apiKey = plist["APIKey"] as! String
        self.baseURL = plist["BaseURL"] as! String
    }
}


struct MeetupAPI {
    static let config = MeetupAPIConfiguration()
    
    static func citiesFromJsonData(data: Data, error: Error?, context: NSManagedObjectContext) -> CityResult {
        if error != nil {
        return CityResult.Failure(error!)
        }
        return CityResult.Success([])
        // DONT LEAVE THIS LIKE THIS OR ELSE
    }
}

enum CityResult {
    case Success([City])
    case Failure(Error)
}

enum MeetupAPIMethods: String {
    case getCities = "/2/cities"
}
