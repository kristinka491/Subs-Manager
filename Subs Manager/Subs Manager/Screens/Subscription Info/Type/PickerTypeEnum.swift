//
//  PickerTypeEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 08.11.2022.
//

import UIKit

enum PickerTypeEnum: String, CaseIterable {
    case currency
    case remindMe

    var array: [String] {
        switch self {
        case .currency:
            return ["USD($)", "EUR(€)", "GBP(£)", "CNY(¥)", "PLN(zł)", "CAD($)"]
        case .remindMe:
            return ["Never", "This day", "The day before", "Three days before", "Five days before", "One week before", "Ten days before", "Two weeks before"]
        }
    }
}

