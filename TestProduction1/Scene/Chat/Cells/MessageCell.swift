//
//  MessageCell.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 25.01.2024.
//

import UIKit

protocol MessageCellProtocol {
    func configure(with model: Message)
}

class MessageCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var messageLabel: UILabel!

    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.layer.cornerRadius = 8
        }
    }


    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
    }


    // MARK: - Class functions
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }


    // MARK: - Custom functions
    func configure(with model: Message) {
        messageLabel.text = model.text
    }
}
