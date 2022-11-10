//
//  RealmDataStore.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import RealmSwift
import UIKit

class RealmDataStore {

    static let shared = RealmDataStore()
    private init() {}

    private let realm = try? Realm()

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

    func addUserSubscription(subscriptionName: String,
                             currency: String,
                             amount: String,
                             paymentCycle: String,
                             paymentDate: String) -> Bool {
        if let currentUserLogin = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserLogin),
           let user = realm?.object(ofType: User.self,
                                             forPrimaryKey: currentUserLogin) {
            let userSubscription = UserSubscription()
            userSubscription.id = UUID()
            userSubscription.subscriptionName = subscriptionName
            userSubscription.currency = currency
            userSubscription.amount = amount
            userSubscription.paymentCycle = paymentCycle
            userSubscription.paymentDate = paymentDate

            try? realm?.write {
                user.subscription.append(userSubscription)
            }
            return true
        }
        return false
    }

    func getUser(login: String, password: String) -> User? {
        if let user = realm?.object(ofType: User.self,
                                   forPrimaryKey: login),
           user.password == password {
            return user
        }
        return nil
    }

    func isUserRegistered(with login: String) -> Bool {
        return realm?.object(ofType: User.self,
                             forPrimaryKey: login) != nil
    }

    private func saveObject(user: User) {
        try? realm?.write {
            realm?.add(user)
        }
        print("Data Was Saved To Realm Database.")
    }
}

