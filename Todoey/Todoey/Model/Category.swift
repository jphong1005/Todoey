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
     */
    
    /// `Later`
    @Persisted var name: String = ""
    @Persisted var colour: String = ""
    
    let items: List<Item> = List<Item>()    //  1 : N 관계
}
