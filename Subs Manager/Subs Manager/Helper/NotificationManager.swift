//
//  NotificationManager.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 17.11.2022.
//

import UIKit
import RealmSwift
import UserNotifications

class NotificationManager {

    private let userNotificationCenter = UNUserNotificationCenter.current()

    func setupNotifications(model: UserSubscription) {
        if RemindMeEnum.allCases.map({ $0.rawValue }).contains(where: { $0 == model.remindMe }) {
            self.requestNotificationAuthorization()
            self.userNotificationCenter.getPendingNotificationRequests { [weak self] notifications in
                DispatchQueue.main.async {
                    if notifications.contains(where: { $0.identifier == model.id.uuidString }) {
                        self?.cancelSubscriptionNotifications(with: model.id)
                    }
                    self?.setupRepeatableNotifications(model: model)
                }
            }
        }
    }

    func cancelSubscriptionNotifications(with id: UUID) {
        userNotificationCenter.removePendingNotificationRequests(withIdentifiers: [id.uuidString])
        userNotificationCenter.removeDeliveredNotifications(withIdentifiers: [id.uuidString])
    }

    private func setupRepeatableNotifications(model: UserSubscription) {
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = "It's time to pay! Your \(model.subscriptionName) period will expire in \(RemindMeEnum(rawValue: model.remindMe)?.stringsForNotifications ?? "")"
        notificationContent.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: getDateOfNotification(model: model))
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: true)

        let request = UNNotificationRequest(identifier: model.id.uuidString, content: notificationContent, trigger: trigger)

        userNotificationCenter.add(request) { (error : Error?) in
            if let theError = error {
                print(theError.localizedDescription)
            }
        }
    }

    private func getDateOfNotification(model: UserSubscription) -> Date {
        let remindMe = RemindMeEnum(rawValue: model.remindMe) ?? .thisDay
        return Calendar.current.date(byAdding: .day, value: -remindMe.amountOfDays, to: model.paymentDate) ?? Date()
    }

    private func requestNotificationAuthorization() {
        let authOptions = UNAuthorizationOptions(arrayLiteral: .alert, .badge, .sound)
        userNotificationCenter.requestAuthorization(options: authOptions) { (success, error) in
            if let error = error {
                print("Error: ", error)
            }
        }
    }
}
