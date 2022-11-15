//
//  CategoreEnum.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 14.11.2022.
//

import UIKit

enum CategoryEnum: String, CaseIterable {
    case entertainment = "Entertainment"
    case music = "Music"
    case work = "Work"
    case utilities = "Utilities"

    var tag: Int {
        switch self {
        case .entertainment:
            return 101
        case .music:
            return 102
        case .work:
            return 103
        case .utilities:
            return 104
        }
    }
}

