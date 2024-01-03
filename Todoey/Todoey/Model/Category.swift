//
//  Category.swift
//  Todoey
//
//  Created by 홍진표 on 12/29/23.
//

import Foundation
import RealmSwift

class Category: Object {
    
    // MARK: - Properties
    /// `Earlier`
    /*
    @objc dynamic var name: String = ""
    @objc dynamic var colour: String = ""
    
    let items: List<Item> = List<Item>()
     */
    
    /// `Later`
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String?
    @Persisted var colour: String?
    @Persisted var items: List<Item>    //  1:N 관계
    
    convenience init(name: String, colour: String, items: List<Item>) {
        self.init()
        
        self.name = name
        self.colour = colour
        self.items = List<Item>()
    }
}
