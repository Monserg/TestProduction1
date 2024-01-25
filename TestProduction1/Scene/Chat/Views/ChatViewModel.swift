//
//  ChatViewModel.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 25.01.2024.
//

import Foundation

protocol ChatViewModelProtocol {
    var chat: [Message] { get set }
    var messagesCount: Int { get }

    func send(_ text: String)
    func loadChat() -> [Message]
    func getMessage(by index: IndexPath) -> Message
}

class ChatViewModel: ChatViewModelProtocol {
    // MARK: - Properties
    var chat: [Message] = []

    var messagesCount: Int {
        chat.count
    }


    // MARK: - Initialization
    init() {
        self.chat = loadChat()
    }


    // MARK: - Class functions
    func send(_ text: String) {
        chat.append(Message(text: text))

        Task {
            await saveChat()
        }
    }

    private func saveChat() async {
        guard
            let chatData = try? JSONEncoder().encode(chat)
        else {
            return
        }
        
        UserDefaults.standard.set(chatData, forKey: "chat")
    }

    func loadChat() -> [Message] {
        chat = []
        
        guard
            let chatData = UserDefaults.standard.value(forKey: "chat") as? Data,
            let chat = try? JSONDecoder().decode(Array.self, from: chatData) as [Message]
        else {
              return []
           }

        return chat
    }

    func getMessage(by index: IndexPath) -> Message {
        chat[index.row]
    }
}
