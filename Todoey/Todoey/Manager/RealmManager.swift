//
//  RealmManager.swift
//  Todoey
//
//  Created by 홍진표 on 12/18/23.
//

import Foundation
import RealmSwift

protocol RealmManagerDelegate {
    
    // MARK: - Properties & Function Prototype
    var realm: Realm { get }
    var realmFilePath: String { get }
    
    func initRealm() -> Realm
}

// MARK: - Low-Level Module
final class RealmManager: RealmManagerDelegate {
    
    // MARK: - Singleton Instance
    static let shared: RealmManager = RealmManager()
    
    // MARK: - PRIVATE Init
    private init() {}
    
    // MARK: - RealmManagerDelegate Implementation
    var realm: Realm {
        get {
            return initRealm()
        }
    }
    
    var realmFilePath: String {
        get {
            return Realm.Configuration.defaultConfiguration.fileURL?.absoluteString ?? ""
        }
    }
    
    func initRealm() -> Realm {
        
        do {
            /// Get the default Realm
            return try! Realm()
        } catch {
            print("Error initializing new realm, \(error.localizedDescription)")
        }
    }
}
