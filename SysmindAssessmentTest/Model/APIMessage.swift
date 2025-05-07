//
//  API.swift
//  SysmindAssignment
//
//  Created by Ganpat Jangir on 03/05/25.
//

import Foundation

struct APIMessage: Codable {
    let id: Int
    let name: String
    let email: String
    let body: String
}
