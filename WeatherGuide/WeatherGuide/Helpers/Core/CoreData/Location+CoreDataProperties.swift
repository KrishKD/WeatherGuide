//
//  Location+CoreDataProperties.swift
//  WeatherGuide
//
//  Created by krishna on 11/18/25.
//  Copyright © 2025 Devaraj, Krishna Kumar. All rights reserved.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var locality: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var administrativeArea: String?
    @NSManaged public var dateModified: Date?

}

extension Location : Identifiable {

}
