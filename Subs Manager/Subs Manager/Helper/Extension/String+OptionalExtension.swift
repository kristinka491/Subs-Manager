//
//  String+ViewControllerExtension.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 06.11.2022.
//

import UIKit

extension Optional where Wrapped == String {

    var isEmptyOrNil: Bool {
        return self?.isEmpty ?? true
    }
}
