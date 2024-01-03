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
    @objc optional func save(data: Any, completionHandler: @escaping () -> Void) -> Void
    
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
    
    var categories: Results<Category>?  //  Results -> Auto-updating container
    var items: Results<Item>?
    
    // MARK: - Init (For Dependency Injection)
    init(realmManager: RealmManagerDelegate) {
        self.realmManager = realmManager
    }
    
    // MARK: - Data Manipulation Methods -> Function Implementation
    func save(data: Any, completionHandler: @escaping () -> Void) {
        
        if let category: Category = data as? Category {
            do {
                try realmManager.realm.write {
                    realmManager.realm.add(category)
                    
                    completionHandler()
                }
            } catch {
                print("Error saving category: \(error.localizedDescription)")
            }
        } else if let item: Item = data as? Item {
            do {
                try realmManager.realm.write {
                    realmManager.realm.add(item)
                    
                    completionHandler()
                }
            } catch {
                print("Error saving item: \(error.localizedDescription)")
            }
        } 
        else {
            print("Invalid Data")
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
