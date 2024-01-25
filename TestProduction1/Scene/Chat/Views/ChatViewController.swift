//
//  ViewController.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 25.01.2024.
//

import UIKit

class ChatViewController: UIViewController {
    // MARK: - Properties
    private var model: ChatViewModelProtocol


    // MARK: - IBOutlets
    @IBOutlet weak var messageTextField: UITextField!

    @IBOutlet weak var chatTableView: UITableView! {
        didSet {
            chatTableView.estimatedRowHeight = 64.0
            chatTableView.rowHeight = UITableView.automaticDimension
            chatTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCell")
        }
    }


    // MARK: - Initialization
    required init?(coder: NSCoder) {
        self.model = ChatViewModel()

        super.init(coder: coder)
    }


    // MARK: - Class functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add Long Tap
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap))
        longPressGesture.minimumPressDuration = 0.5
        chatTableView.addGestureRecognizer(longPressGesture)
    }


    // MARK: - Actions
    @IBAction func sendMessageButtonTap(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty else {
            return
        }

        model.send(text)
        messageTextField.text = ""
        chatTableView.reloadData()
    }

    @objc func handleLongTap(longPressGesture: UILongPressGestureRecognizer) {
        guard let indexPath = chatTableView.indexPathForRow(at: longPressGesture.location(in: chatTableView)) else {
            print("Long press on table view, not row.")
            return
        }

        print("Long press on row at \(indexPath.row)")

        #warning("ADD ACTION !!!")
    }
}


// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}


// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.messagesCount
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }

        cell.configure(with: model.getMessage(by: indexPath))

        return cell
    }
}


// MARK: - UITableViewDelegate
extension ChatViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let message = model.getMessage(by: indexPath)

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
            let messageIDAction = UIAction(title: "Message ID", image: UIImage(systemName: "number.circle.fill")) { (action) in
                print("Message id: \(message.id.uuidString)");
            }

            let messageDateAction = UIAction(title: "Messsage Created at", image: UIImage(systemName: "pencil.tip.crop.circle.badge.plus.fill")) { (action) in
                print("Message created at \(message.created.formatted())");
            }

            return UIMenu(title: "Message Options", children: [messageIDAction, messageDateAction])
        }
    }
}
