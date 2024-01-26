//
//  Sender.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 26.01.2024.
//

import Foundation

struct Sender: Codable {
    // MARK: - Properties
    let id: UInt8
    let name: String
    let avatarName: String

    static let me = Sender(id: 0, name: "XXX", avatarName: "me")
    static let sender1 = Sender(id: 1, name: "Shevchenko", avatarName: "sender1")
    static let sender2 = Sender(id: 1, name: "Franko", avatarName: "sender2")
}
