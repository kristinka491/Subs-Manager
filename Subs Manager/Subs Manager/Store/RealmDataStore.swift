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
                             paymentDate: String,
                             remindMe: String,
                             category: String) -> Bool {
        if let currentUserLogin = UserDefaults.standard.string(forKey: UserDefaultsKeys.currentUserLogin),
            let currentUser = realm?.object(ofType: User.self,
                                          forPrimaryKey: currentUserLogin) {
            try? realm?.write {
                let userSubscription = UserSubscription()
                userSubscription.subscriptionName = subscriptionName
                userSubscription.currency = currency
                userSubscription.amount = amount
                userSubscription.paymentCycle = paymentCycle
                userSubscription.paymentDate = paymentDate
                userSubscription.remindMe = remindMe
                userSubscription.category = category

                currentUser.subscriptions.append(userSubscription)
            }
            return true
        }
        return false
    }

    func getUser(login: String, password: String) -> User? {
        if let user = getUser(with: login),
           user.password == password {
            return user
        }
        return nil
    }

    func getUser(with login: String) -> User? {
        return realm?.object(ofType: User.self,
                             forPrimaryKey: login)
    }

    func isUserRegistered(with login: String) -> Bool {
        return getUser(with: login) != nil
    }

    func deleteSubscription(with id: UUID) {
        if let userSubscription = realm?.object(ofType: UserSubscription.self,
                                                forPrimaryKey: id) {
            try? realm?.write {
                realm?.delete(userSubscription)
            }
        }
    }

    func updateSubscription(subscriptionId: UUID,
                            currency: String,
                            amount: String,
                            paymentCycle: String,
                            paymentDate: String,
                            remindMe: String,
                            category: String) -> Bool {
        if let userSubscription = realm?.object(ofType: UserSubscription.self,
                                                forPrimaryKey: subscriptionId) {
            try? realm?.write {
                userSubscription.currency = currency
                userSubscription.amount = amount
                userSubscription.paymentCycle = paymentCycle
                userSubscription.paymentDate = paymentDate
                userSubscription.remindMe = remindMe
                userSubscription.category = category
            }
            return true
        }
        return false
    }

    private func saveObject(user: User) {
        try? realm?.write {
            realm?.add(user)
        }
        print("Data Was Saved To Realm Database.")
    }
}

