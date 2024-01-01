//
//  DataManipulationManager.swift
//  Todoey
//
//  Created by 홍진표 on 12/19/23.
//

import Foundation
import RealmSwift

@objc protocol DataManagerDelegate: AnyObject {
    
    // MARK: - Function Prototypes
    /// `CREATE`
    @objc optional func save(category: Category, completionHandler: @escaping () -> Void) -> Void
    @objc optional func save(item: Item, completionHandler: @escaping () -> Void) -> Void
    
    /// `READ`
    @objc optional func loadCategories(completionHandler: @escaping () -> Void) -> Void
    @objc optional func loadItems(completionHandler: @escaping () -> Void) -> Void
    
    /// `UPDATE`
    @objc optional func update(data: Item, completionHandler: @escaping () -> Void) -> Void
    
    /// `DELETE`
    @objc optional func delete(at indexPath: IndexPath) -> Void
}

// MARK: - High-Level Module
final class DataManager: DataManagerDelegate {
    
    // MARK: - Properties
    let realmManager: RealmManagerDelegate
    
    var categories: Results<Category>?
    var items: Results<Item>?
    
    // MARK: - Init (For Dependency Injection)
    init(realmManager: RealmManagerDelegate) {
        self.realmManager = realmManager
    }
    
    func save(category: Category, completionHandler: @escaping () -> Void) {
        
        do {
            try realmManager.realm.write {
                realmManager.realm.add(category)
                
                completionHandler()
            }
        } catch {
            print("Error saving category: \(error.localizedDescription)")
        }
    }
    
    func save(item: Item, completionHandler: @escaping () -> Void) {
        
        do {
            try realmManager.realm.write {
                realmManager.realm.add(item)
                
                completionHandler()
            }
        } catch {
            print("Error saving item: \(error.localizedDescription)")
        }
    }
    
    func loadCategories(completionHandler: @escaping () -> Void) {
        
        categories = realmManager.realm.objects(Category.self)
        
        completionHandler()
    }
    
    func update(data: Item, completionHandler: @escaping () -> Void) {
        
        do {
            try realmManager.realm.write {
                data.done = !data.done
                
                completionHandler()
            }
        } catch {
            print("Error updating item: \(error.localizedDescription)")
        }
    }
}
