//
//  CityStore.swift
//  MyMeetups
//
//  Created by Daniel Kwolek on 9/28/16.
//  Copyright © 2016 Arcore. All rights reserved.
//

import Foundation

class CityStore {
    
    var cityStore: [City] = []
    
    let session: URLSession = {
    let config = URLSessionConfiguration.default
    return URLSession(configuration: config)
    }()
    
    let coreDataStack = CoreDataStack(modelName: "MyMeetups")
    
    
    func processCitiesFromJSON(data: Data, error: Error) -> [City]{
        
            
            
            
            MeetupAPI.citiesFromJsonData(data: data, error: error, context: self.coreDataStack.privateQueueContext)
    }
    
    func fetchCities(completion: @escaping (CityResult) -> Void ) {
        
        let newurl = URL(string: ("\(MeetupAPI.config.baseURL)\(MeetupAPIMethods.getCities.rawValue)"))
        let request = URLRequest(url: newurl!)
        var returnValue = CityResult.Success([])
        
        let fetcherTask = self.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                returnValue = CityResult.Failure(error!)
                return
            }
            let Cities = self.processCitiesFromJSON(data: data, error: error)
            
            let pqc = self.coreDataStack.privateQueueContext
            
            let mainQueueContext = self.coreDataStack.mainQueueContext
            mainQueueContext.performAndWait {
                if mainQueueContext.hasChanges {
                    do {
                    try self.coreDataStack.saveChanges()
                    } catch let error {
                        returnValue = CityResult.Failure(error)
                        return
                    }
                }
            }
            
            
            
            
        }
        fetcherTask.resume()
        
        completion(returnValue)
        
//        let fetchTask = self.session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//            var result = MeetupAPI.citiesFromJsonData(data: data!, error: error, context: self.coreDataStack.mainQueueContext)
//            if case let .Success(cities) = result {
//
//                let pqc = self.coreDataStack.privateQueueContext
//                
//                pqc.performAndWait {
//                    try! pqc.obtainPermanentIDs(for: cities)
//                }
//                do {
//                    try self.coreDataStack.saveChanges()
//                } catch let errorrr {
//                    result = CityResult.Failure(errorrr)
//                }
//                
//                
//            }
//            
//                
//                
//            completion(result)
//        }
//            
//            
//        fetchTask.resume()
//        
    }
}
