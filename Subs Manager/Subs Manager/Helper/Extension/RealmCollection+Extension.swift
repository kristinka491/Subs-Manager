//
//  RealmCollection+Extension.swift
//  Subs Manager
//
//  Created by Vlad Birukov on 15.11.2022.
//

import RealmSwift

extension RealmCollection {
    
    func toArray<T>() ->[T] {
        return self.compactMap { $0 as? T }
    }
}
