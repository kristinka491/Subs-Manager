//
//  UserSubscription.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 09.11.2022.
//

import Foundation
import RealmSwift

class UserSubscription: Object {
    @Persisted(primaryKey: true) var id: UUID
    @Persisted var subscriptionName = ""
    @Persisted var currency = ""
    @Persisted var amount = ""
    @Persisted var paymentDate = ""
    @Persisted var paymentCycle = ""
    @Persisted var remindMe = ""
    @Persisted var category = ""
}



