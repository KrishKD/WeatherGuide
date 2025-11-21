//
//  CoreDataStack.swift
//  WeatherGuide
//
//  Created by krishna on 11/13/25.
//  Copyright © 2025 Devaraj, Krishna Kumar. All rights reserved.
//

import Foundation
import Observation
import CoreData
import CoreLocation

class CoreDataStack {
    static let shared = CoreDataStack()
    
    private init() { }
    
    @ObservationIgnored
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "WeatherGuide")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()
}

extension CoreDataStack {
    func save() async {
        guard persistentContainer.viewContext.hasChanges else { return }
        
        do {
            try persistentContainer.viewContext.save()
        } catch {
            print("Failed to save the context: \(error.localizedDescription)")
        }
    }
    
    func createLocationObjectModel(from placemark: CLPlacemark) async {
        guard let coordinates = placemark.location?.coordinate else { return }
        
        let locationModel = Location(context: persistentContainer.viewContext)
        locationModel.latitude = coordinates.latitude
        locationModel.longitude = coordinates.longitude
        locationModel.locality = placemark.locality
        locationModel.administrativeArea = placemark.administrativeArea
        locationModel.dateModified = Date()
    }
    
    func hasDuplicateObject(for locality: String?) -> Bool {
        let request = Location.fetchRequest()
        request.predicate = NSPredicate(format: "locality == %@", locality ?? "")
        
        do {
            return try persistentContainer.viewContext.fetch(request).first != nil
        } catch {
            return false
        }
    }
    
    func fetchLocations() async -> [Location] {
        let request = Location.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "dateModified", ascending: false)]
        
        do {
            return try persistentContainer.viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
