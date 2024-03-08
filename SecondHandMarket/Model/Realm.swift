//
//  Realm.swift
//  SecondHandMarket
//
//  Created by romanus on 3/6/24.
//

import Foundation
import RealmSwift

class User : Object {
    @Persisted var name: String = ""
    @Persisted var id: String = ""
    @Persisted var password: String = ""
}

class DataBaseManager {
    static let shared = DataBaseManager()
    private let realm: Realm
    
    private init() {
        do {
            self.realm = try Realm()
        } catch let error {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }
    
    func saveUser(user: User) {
        do {
            try realm.write {
                realm.add(user)
            }
        } catch let error {
            print("Error Saving user: \(error.localizedDescription)")
        }
    }
    
    func getUser() -> Results<User> {
        return realm.objects(User.self)
    }
    
    func deleteUser() {
        do {
            try realm.write {
                realm.deleteAll()
            } 
        } catch let error {
            print("Error deleteAll user: \(error.localizedDescription)")
        }
    }
}