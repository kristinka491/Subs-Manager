//
//  CurrencyEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 17.11.2022.
//

import Foundation

enum CurrencyEnum: String, CaseIterable {
    case usd = "USD($)"
    case eur = "EUR(€)"
    case gbp = "GBP(£)"
    case cny = "CNY(¥)"
    case pln = "PLN(zł)"
    case cad = "CAD($)"

    func next() -> Self {
        let all = CurrencyEnum.allCases
        guard let idx = all.firstIndex(of: self) else { return .usd }
        let next = all.index(after: idx)
        return all[next == all.endIndex ? all.startIndex : next]
    }
}

