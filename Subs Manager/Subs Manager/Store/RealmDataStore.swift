//
//  RealmDataStore.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import RealmSwift

class RealmDataStore {

    static let shared = RealmDataStore()

    private init() {}

    func addUser(name: String,
                 login: String,
                 password: String) -> Bool {
        if !isUserRegistered(with: login) {
            let user = User()
            user.name = name
            user.login = login
            user.password = password
            saveObject(user: user)

            return true
        }
        return false
    }

    func getUser(login: String, password: String) -> User? {
        if let user = try! Realm().object(ofType: User.self,
                                          forPrimaryKey: login),
           user.password == password {
            return user
        }
        return nil
    }

    private func isUserRegistered(with login: String) -> Bool {
        return try! Realm().object(ofType: User.self,
                                   forPrimaryKey: login) != nil
    }

    private func saveObject(user: User) {
        let realm = try? Realm()
        try? realm?.write {
            realm?.add(user)
        }
        print("Data Was Saved To Realm Database.")
    }
}

