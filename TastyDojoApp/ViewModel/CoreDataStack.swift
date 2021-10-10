//
//  CoreDataStack.swift
//  TastyDojo
//
//  Created by Михаил on 08.10.2021
//

import Foundation
import CoreData

final class CoreDataStack {
    
    //MARK: - Properties
    
    static let shared = CoreDataStack()
  
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RecipeCoreDataModel")
        container.loadPersistentStores { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }
        
        return container
    }()
    
    //MARK: - Save Context Method
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
