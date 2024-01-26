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
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet var chatTableHeight: NSLayoutConstraint!
    @IBOutlet weak var messageViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var sendButton: UIButton! {
        didSet {
            sendButton.isEnabled = false
        }
    }

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }


    // MARK: - Class functions
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)

        if model.messagesCount > 0 {
            chatTableView.scrollToRow(at: model.bottomIndexPath, at: .bottom, animated: false)
        }

        NotificationCenter.default
            .addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }


    // MARK: - Actions
    @IBAction func sendMessageButtonTap(_ sender: UIButton) {
        guard let text = messageTextField.text, !text.isEmpty else {
            return
        }

        model.send(text)
        messageTextField.text = ""
        messageTextField.resignFirstResponder()
        chatTableView.reloadData()
        chatTableView.scrollToRow(at: model.bottomIndexPath, at: .bottom, animated: true)
    }

    @IBAction func clearButtonTap(_ sender: UIBarButtonItem) {
        showAlertView()
    }

    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        messageTextField.resignFirstResponder()
        messageViewBottomConstraint.constant = 0
        chatTableView.scrollToRow(at: model.bottomIndexPath, at: .bottom, animated: true)

        view.layoutIfNeeded()
    }

    @objc func keyboardWillChangeFrame(_ notification: Notification) {
        let beginFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let delta = (endFrame.origin.y - beginFrame.origin.y)
        
        chatTableView.contentOffset = CGPoint(x: 0, y: chatTableView.contentOffset.y - delta)
        messageViewBottomConstraint.constant = view.bounds.height - endFrame.origin.y

        view.layoutIfNeeded()
    }

    // MARK: - Custom functions
    private func showAlertView() {
        let alert = UIAlertController(title: "Info", message: "Are you ready ?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.model.clearChat()
            self.chatTableView.reloadData()
        }))

        alert.addAction(UIAlertAction(title: "No", style: .destructive, handler: { _ in }))

        present(alert, animated: true, completion: nil)
    }

    private func setupEmptyLabel() {
        emptyLabel.isHidden = model.messagesCount > 0
    }
}


// MARK: - UITextFieldDelegate
extension ChatViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        sendButton.isEnabled = false

        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let count = textField.text?.count {
            switch count {
            case let y where y == 0 && !string.isEmpty:
                sendButton.isEnabled = true

            case let x where x == 1 && string.isEmpty:
                sendButton.isEnabled = false

            default:
                sendButton.isEnabled = true
            }
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let length = textField.text?.count, length > 0 else {
            return false
        }

        textField.resignFirstResponder()
        sendButton.isEnabled = true

        return true
    }
}


// MARK: - UITableViewDataSource
extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        setupEmptyLabel()
        
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
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        viewWillLayoutSubviews()
    }

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

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: .zero)
        headerView.isUserInteractionEnabled = false
        headerView.backgroundColor = .clear

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let diff = tableView.contentSize.height - tableView.bounds.height
        
        return diff > 0 ? 0 : -diff
    }
}
