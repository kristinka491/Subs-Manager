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
    private let notification = NotificationManager()

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
            let userSubscription = UserSubscription()
            try? realm?.write {
                userSubscription.subscriptionName = subscriptionName
                userSubscription.currency = currency
                userSubscription.amount = amount
                userSubscription.paymentCycle = paymentCycle
                userSubscription.paymentDate = DateFormatterHepler.getDate(from: paymentDate) 
                userSubscription.remindMe = remindMe
                userSubscription.category = category

                currentUser.subscriptions.append(userSubscription)
            }
            notification.setupNotifications(model: userSubscription)
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

    func isUserRegistered(with login: String) -> Bool {
        return getUser(with: login) != nil
    }

    func deleteSubscription(with id: UUID) {
        if let userSubscription = realm?.object(ofType: UserSubscription.self,
                                                forPrimaryKey: id) {
            try? realm?.write {
                realm?.delete(userSubscription)
            }
            notification.cancelSubscriptionNotifications(with: id)
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
                userSubscription.paymentDate = DateFormatterHepler.getDate(from: paymentDate) 
                userSubscription.remindMe = remindMe
                userSubscription.category = category
            }
            notification.setupNotifications(model: userSubscription)
            return true
        }
        return false
    }

    func getUser(with login: String) -> User? {
        let user = realm?.object(ofType: User.self,
                                 forPrimaryKey: login)
        user?.subscriptions.forEach { [weak self] subscription in
            self?.updatePaymentDateIfNeeded(model: subscription)
        }
        return user
    }

    func updatePaymentDateIfNeeded(model: UserSubscription) {
        if model.paymentDate < Date() {
            let paymentCycle = PaymentCycleEnum(rawValue: model.paymentCycle) ?? .everyTwoWeeks
            let periodBetweenDates = periodBetweenDates(model.paymentDate, paymentCycle: paymentCycle)
            var nextPaymentDate = Date()

            switch paymentCycle {
            case .everyTwoWeeks:
                let numberOfDays = (Int(periodBetweenDates.days / 14) + 1) * 14
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyTwoWeeks.dateComponent,
                                                        value: numberOfDays,
                                                        to: model.paymentDate) ?? Date()
            case .everyMonth:
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyMonth.dateComponent,
                                                        value: periodBetweenDates.months + 1,
                                                        to: model.paymentDate) ?? Date()
            case .everyYear:
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyYear.dateComponent,
                                                        value: periodBetweenDates.years + 1,
                                                        to: model.paymentDate) ?? Date()
            }

            try? realm?.write {
                model.paymentDate = nextPaymentDate
            }
            notification.setupNotifications(model: model)
        }
    }

    private func periodBetweenDates(_ paymentDate: Date,
                                    paymentCycle: PaymentCycleEnum) -> (days: Int, months: Int, years: Int) {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([paymentCycle.dateComponent], from: paymentDate, to: currentDate)

        return (components.day ?? 0, components.month ?? 0, components.year ?? 0)
    }
    
    private func saveObject(user: User) {
        try? realm?.write {
            realm?.add(user)
        }
        print("Data Was Saved To Realm Database.")
    }
}

