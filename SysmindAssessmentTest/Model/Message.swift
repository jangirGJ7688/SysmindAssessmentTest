//
//  Message.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 03/05/25.
//

import Foundation

struct Message: Identifiable, Codable, Equatable {
    let id: Int
    let title: String
    let sender: String
    let content: String
    var isPinned: Bool = false
}
