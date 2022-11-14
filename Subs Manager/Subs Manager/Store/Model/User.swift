//
//  User.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 05.11.2022.
//

import Foundation
import RealmSwift

class User: Object {
    @Persisted(primaryKey: true) var login = ""
    @Persisted var name = ""
    @Persisted var password = ""

    @Persisted var subscriptions: List<UserSubscription>
}
