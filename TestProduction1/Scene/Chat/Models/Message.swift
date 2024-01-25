//
//  Message.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 25.01.2024.
//

import Foundation

struct Message: Codable {
    // MARK: - Properties
    let id: UUID
    let text: String
    let created: Date


    // MARK: - Initialization
    init(id: UUID = UUID(), text: String, created: Date = Date()) {
        self.id = id
        self.text = text
        self.created = created
    }
}
