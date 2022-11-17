//
//  PickerTypeEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 08.11.2022.
//

import UIKit

enum PickerTypeEnum {
    case currency
    case remindMe
    case paymentCycle
    case category

    var array: [String] {
        switch self {
        case .currency:
            return CurrencyEnum.allCases.map { $0.rawValue }
        case .remindMe:
            return ["Never"] + RemindMeEnum.allCases.map { $0.rawValue }
        case .paymentCycle:
            return PaymentCycleEnum.allCases.map { $0.rawValue }
        case .category:
            return CategoryEnum.allCases.map { $0.rawValue }
        }
    }
}

