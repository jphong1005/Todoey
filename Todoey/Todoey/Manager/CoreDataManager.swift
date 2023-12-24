//
//  CoreDataManager.swift
//  Todoey
//
//  Created by 홍진표 on 12/18/23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    // MARK: - Singleton Instance
    static let shared: CoreDataManager = CoreDataManager()
    
    // MARK: - (PRIVATE) - Init
    private init() {}
    
    // MARK: - Computed-Prop
    var context: NSManagedObjectContext {
        get {
            return persistentContainer.viewContext
        }
    }
    
    // MARK: - Core Data stack

    /// Initialize a Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        /// `NSPersistentContainer:` A container that encapsulates the Core Data stack in your app.
        
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container: NSPersistentContainer = NSPersistentContainer(name: "DataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error: NSError = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    // MARK: - Core Data Saving support

    func saveContext() -> Void {
        let context: NSManagedObjectContext = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror: NSError = error as NSError
                
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
