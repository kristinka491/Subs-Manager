//
//  UserSubscription.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 09.11.2022.
//

import UIKit
import RealmSwift

class UserSubscription: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var subscriptionName = ""
    @Persisted var currency = ""
    @Persisted var amount = ""
    @Persisted var paymentDate = Date()
    @Persisted var paymentCycle = ""
    @Persisted var remindMe = ""
    @Persisted var category = ""
}



