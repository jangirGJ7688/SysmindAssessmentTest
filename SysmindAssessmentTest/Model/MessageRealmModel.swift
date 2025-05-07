//
//  MessageRealmModel.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 03/05/25.
//

import Foundation
import RealmSwift

class MessageRealmModel: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var sender: String
    @Persisted var content: String
    @Persisted var isPinned: Bool
}
