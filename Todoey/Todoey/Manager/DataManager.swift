//
//  DataManipulationManager.swift
//  Todoey
//
//  Created by 홍진표 on 12/19/23.
//

import Foundation
import CoreData

@objc protocol DataManagerDelegate: AnyObject {
    
    // MARK: - Function Prototypes
    /// `CREATE`
    @objc optional func save(completionHandler: @escaping () -> Void) -> Void
    
    /// `READ`
    @objc optional func loadCategories(_ request: NSFetchRequest<Category>, completionHandler: @escaping () -> Void) -> Void
    @objc optional func loadItems(_ request: NSFetchRequest<Item>, _ predicate: NSPredicate?, completionHandler: @escaping () -> Void) -> Void
    
    /// `UPDATE`
    @objc optional func update(_ data: Array<Item>, at indexPath: IndexPath, completionHandler: @escaping () -> Void) -> Void
    
    /// `DELETE`
    @objc optional func delete(at indexPath: IndexPath) -> Void
}

// MARK: - High-Level Module
final class DataManager: DataManagerDelegate {
    
    // MARK: - Properties
    let coreDataManager: CoreDataManagerDelegate
    
    var categories: Array<Category> = Array<Category>()
    var items: Array<Item> = Array<Item>()
    
    // MARK: - Init (For Dependency Injection)
    init(coreDataManager: CoreDataManagerDelegate) {
        self.coreDataManager = coreDataManager
    }
    
    // MARK: - Data Manipulation Methods -> Function Implementation
    func save(completionHandler: @escaping () -> Void) {
        
        coreDataManager.saveContext()
        
        completionHandler()
    }
    
    func loadCategories(_ request: NSFetchRequest<Category> = Category.fetchRequest(), completionHandler: @escaping () -> Void) {
        
        do {
            categories = try coreDataManager.context.fetch(request)
        } catch {
            print("Error fetching data from context: \(error.localizedDescription)")
        }
        
        completionHandler()
    }
    
    func update(_ data: Array<Item>, at indexPath: IndexPath, completionHandler: @escaping () -> Void) {
        
        items[indexPath.row].done = !items[indexPath.row].done
        
        completionHandler()
    }
}
