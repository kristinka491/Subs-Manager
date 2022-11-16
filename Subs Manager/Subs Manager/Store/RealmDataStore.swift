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

    func getUser(with login: String) -> User? {
        let user = realm?.object(ofType: User.self,
                                 forPrimaryKey: login)
        user?.subscriptions.forEach { [weak self] subscription in
            self?.updatePaymentDateIfNeeded(model: subscription)
        }
        return user
    }

    func updatePaymentDateIfNeeded(model: UserSubscription) {
        let paymentDate = getDate(from: model.paymentDate)
        if paymentDate < Date() {
            let paymentCycle = PaymentCycleEnum(rawValue: model.paymentCycle) ?? .everyTwoWeeks
            let periodBetweenDates = periodBetweenDates(paymentDate, paymentCycle: paymentCycle)
            var nextPaymentDate = Date()

            switch paymentCycle {
            case .everyTwoWeeks:
                let numberOfDays = (Int(periodBetweenDates.days / 14) + 1) * 14
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyTwoWeeks.dateComponent,
                                                        value: numberOfDays,
                                                        to: paymentDate) ?? Date()
            case .everyMonth:
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyMonth.dateComponent,
                                                        value: periodBetweenDates.months + 1,
                                                        to: paymentDate) ?? Date()
            case .everyYear:
                nextPaymentDate = Calendar.current.date(byAdding: PaymentCycleEnum.everyYear.dateComponent,
                                                        value: periodBetweenDates.years + 1,
                                                        to: paymentDate) ?? Date()
            }

            try? realm?.write {
                model.paymentDate = getDateString(from: nextPaymentDate)
            }
        }
    }

    private func getDateString(from date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: date)
    }

    private func getDate(from string: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.date(from: string) ?? Date()
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

