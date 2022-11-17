//
//  RemindMeEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 17.11.2022.
//

import UIKit

enum RemindMeEnum: String, CaseIterable {
    case thisDay = "This day"
    case dayBefore = "The day before"
    case threeDaysBefore = "Three days before"
    case fiveDaysBefore = "Five days before"
    case oneWeekBefore = "One week before"
    case tenDaysBefore = "Ten days before"
    case twoWeeksBefore = "Two weeks before"

    var amountOfDays: Int {
        switch self {
        case .thisDay:
            return 0
        case .dayBefore:
            return 1
        case .threeDaysBefore:
            return 3
        case .fiveDaysBefore:
            return 5
        case .oneWeekBefore:
            return 7
        case .tenDaysBefore:
            return 10
        case .twoWeeksBefore:
            return 14
        }
    }

    var stringsForNotifications: String {
        switch self {
        case .thisDay:
            return "this day"
        case .dayBefore:
            return "one day"
        case .threeDaysBefore:
            return "three days"
        case .fiveDaysBefore:
            return "five days"
        case .oneWeekBefore:
            return "one week"
        case .tenDaysBefore:
            return "ten days"
        case .twoWeeksBefore:
            return "two weeks"
        }
    }
}
