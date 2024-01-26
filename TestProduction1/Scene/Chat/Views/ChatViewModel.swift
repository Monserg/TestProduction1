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
    var bottomIndexPath: IndexPath { get }

    func addIncomingMessage()
    func send(_ text: String)
    func loadChat() -> [Message]
    func getMessage(by index: IndexPath) -> Message
    func clearChat()
}

class ChatViewModel: ChatViewModelProtocol {
    // MARK: - Properties
    var chat: [Message] = []

    var messagesCount: Int {
        chat.count
    }

    var bottomIndexPath: IndexPath {
        let row = messagesCount == 0 ? messagesCount : messagesCount - 1
        return IndexPath(row: row, section: 0)
    }

    
    // MARK: - Initialization
    init() {
        self.chat = loadChat()
    }


    // MARK: - Class functions
    func addIncomingMessage() {
        var string = "Otherwise, it’s unclear where the iteration should start. Iterating over a one-sided range requires you to manually check where the loop should end, as it would otherwise continue indefinitely."

        string.removeSubrange(string.startIndex ..< string.index(string.startIndex, offsetBy: Int(arc4random_uniform(20))))
        let message = Message(text: string, sender: arc4random_uniform(2) == 0 ? .sender1 : .sender2)

        chat.append(message)

        Task {
            await saveChat()
        }
    }

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

    func clearChat() {
        chat = []

        Task {
            await saveChat()
        }
    }
}
