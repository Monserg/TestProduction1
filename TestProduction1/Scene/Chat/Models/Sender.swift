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

    static let me = Sender(id: 0, name: "XXX")
    static let sender1 = Sender(id: 1, name: "Shevchenko")
    static let sender2 = Sender(id: 1, name: "Franko")
}
