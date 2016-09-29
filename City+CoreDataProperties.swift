//
//  City+CoreDataProperties.swift
//  MyMeetups
//
//  Created by Daniel Kwolek on 9/28/16.
//  Copyright © 2016 Arcore. All rights reserved.
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City");
    }

    @NSManaged public var name: String
    @NSManaged public var state: String?

}
