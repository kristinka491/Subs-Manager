//
//  User.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import Foundation
import RealmSwift

class User: Object {

    @objc dynamic var login = ""
    @objc dynamic var name = ""
    @objc dynamic var password = ""

    override static func primaryKey() -> String? {
        return "login"
    }
}
