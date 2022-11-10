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

    var array: [String] {
        switch self {
        case .currency:
            return ["USD($)", "EUR(€)", "GBP(£)", "CNY(¥)", "PLN(zł)", "CAD($)"]
        case .remindMe:
            return ["Never", "This day", "The day before", "Three days before", "Five days before", "One week before", "Ten days before", "Two weeks before"]
        case .paymentCycle:
            return ["Every week", "Every ten days", "Every two weeks", "Every fifteen days", "Every twenty days", "Every three weeks", "Every twenty five days", "Every month", "Every two months", "Every three months", "Every half a year", "Every year"]
        }
    }
}

