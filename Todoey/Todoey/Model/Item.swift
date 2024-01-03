//
//  Item.swift
//  Todoey
//
//  Created by 홍진표 on 12/29/23.
//

import Foundation
import RealmSwift

class Item: Object {
    
    // MARK: - Properties
    /// `Earlier`
    /*
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    var parentCategory: LinkingObjects<Category> = LinkingObjects(fromType: Category.self, property: "items")
     */
    
    /// `Later`
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated: Date?
    
    var parentCategory: LinkingObjects<Category> = LinkingObjects(fromType: Category.self, property: "items")   //  Relationship (-> Category와 역참조 관계)
}
