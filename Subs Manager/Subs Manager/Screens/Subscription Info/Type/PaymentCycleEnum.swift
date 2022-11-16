//
//  PaymentCycleEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 09.11.2022.
//

import Foundation

enum PaymentCycleEnum: String {
    case everyTwoWeeks = "Every two weeks"
    case everyMonth = "Every month"
    case everyYear = "Every year"

    var dateComponent: Calendar.Component {
        switch self {
        case .everyTwoWeeks:
            return .day
        case .everyMonth:
            return .month
        case .everyYear:
            return .year
        }
    }
}
