//
//  MessageInCell.swift
//  TestProduction1
//
//  Created by Serhii Monastyrskyi on 26.01.2024.
//

import UIKit

protocol MessageCellProtocol {
    func configure(with model: Message)
}


class MessageInCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var createdDateLabel: UILabel!

    @IBOutlet weak var messageLabel: UILabel! {
        didSet {
            messageLabel.numberOfLines = Int(arc4random_uniform(6))
        }
    }

    @IBOutlet weak var bubbleView: UIView! {
        didSet {
            bubbleView.layer.cornerRadius = 8
        }
    }

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = 11
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
        createdDateLabel.text = model.created.formatted()
        avatarImageView.image = UIImage(named: model.sender.avatarName)
    }
}
