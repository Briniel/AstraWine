//
//  StorageManager.swift
//  AstraWine
//
//  Created by Михаил Иванов on 08.10.2021.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    
    // MARK: - Core Data stack

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Shelf")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    private let viewContext: NSManagedObjectContext
    
    private init() {
        viewContext = persistentContainer.viewContext
    }
    
    // MARK: - Core Data Saving support

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    // MARK: - Shelf
    
    func fetchData() -> [Shelf] {
        let fetchReRequest = Shelf.fetchRequest()
        var shelfs: [Shelf] = []
        
        do {
            shelfs = try viewContext.fetch(fetchReRequest)
        } catch {
            print("Failed to fetch data", error)
        }
        
        return shelfs
    }
    
    func saveShelf(_ name: String, _ completion: (Shelf) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Shelf", in: viewContext) else {
            return
        }
        guard let shelf = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Shelf else {
            return
        }
        
        shelf.name = name
        
        saveContext()
        completion(shelf)
    }
    
    func editShelf(_ shelf: Shelf, newName: String) {
        shelf.name = newName
        saveContext()
    }
    
    func deleteShelf(_ shelf: Shelf) {
        viewContext.delete(shelf)
        saveContext()
    }
    
    // MARK: - Bottle
    
    func saveBottle(_ name: String, to shelf: Shelf, _ completion: (Bottle) -> Void) {
        guard let entityDescription = NSEntityDescription.entity(forEntityName: "Bottle", in: viewContext) else {
            return
        }
        guard let bottle = NSManagedObject(entity: entityDescription, insertInto: viewContext) as? Bottle else {
            return
        }
        
        bottle.name = name
        shelf.addToBottles(bottle)
        
        saveContext()
        completion(bottle)
    }
    
    func editBottle(_ bottle: Bottle, newValue: BottleValue) {
        bottle.name = newValue.name
        bottle.dateTasting = newValue.tastingDate
        bottle.placeTasting = newValue.tastingPlace
        bottle.country = newValue.country
        bottle.region = newValue.region
        bottle.grapeSort = newValue.sourtWine
        bottle.colorWine = newValue.colorWine
        bottle.dateHarvest = newValue.harvestYear ?? Int64(0)
        bottle.fortressWine = newValue.fortress ?? Double(0)
        bottle.price = newValue.price ?? Int64(0)
        bottle.manufacturer = newValue.manufacturer
        bottle.distributor = newValue.distributor
        bottle.appearance = newValue.appearance
        bottle.scent = newValue.scent
        bottle.taste = newValue.taste
        bottle.storagePotential = newValue.storage
        bottle.flowTemp = newValue.temperament ?? Double(0)
        bottle.gastronomicCompanions = newValue.gastronomic
        bottle.placeOfPurchase = newValue.placeBuy
        bottle.notes = newValue.notes
        
        saveContext()
    }
    
    func deletBottle(_ bottle: Bottle) {
        viewContext.delete(bottle)
        saveContext()
    }
}

enum DataError: Error {
    case noData
    case otherError
}
