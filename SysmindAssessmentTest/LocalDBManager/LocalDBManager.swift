//
//  LocalDBManager.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 04/05/25.
//

import Foundation
import RealmSwift
import Combine

class LocalDBManager {
    
    private var realm: Realm?
    
    init() {
        do {
            self.realm = try Realm()
        } catch let error {
            debugPrint("Ganpat error in Realm initialization \(error.localizedDescription)")
        }
    }
    
    func saveMessagesToLocalDB(_ messages: [APIMessage]) {
        do {
            try realm?.write {
                for msg in messages {
                    if self.realm?.object(ofType: MessageRealmModel.self, forPrimaryKey: msg.id) == nil {
                        let obj = MessageRealmModel()
                        obj.id = msg.id
                        obj.title = msg.name
                        obj.sender = msg.email
                        obj.content = msg.body
                        obj.isPinned = false
                        self.realm?.add(obj)
                    }
                }
            }
        } catch let error {
            debugPrint("Ganpat error in adding messgaes to DB \(error.localizedDescription)")
        }
    }
    
    func updateMessageState(for message: Message) {
        do {
            try realm?.write {
                if let obj = self.realm?.object(ofType: MessageRealmModel.self, forPrimaryKey: message.id) {
                    obj.isPinned = message.isPinned
                    self.realm?.add(obj, update: .modified)
                }
            }
        } catch let error {
            debugPrint("Ganpat error in updating messgae to DB \(error.localizedDescription)")
        }
    }
    
    func fetchAllMessagesFromLocalDB() -> [Message] {
        let messages = realm?.objects(MessageRealmModel.self)
        if let msgs = messages {
             return msgs.map({Message(id: $0.id, title: $0.title, sender: $0.sender, content: $0.content, isPinned: $0.isPinned)})
        }
        return []
    }
}
