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

    @IBOutlet weak var leadingInBubbleViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingOutBubbleViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var trailingInBubbleViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var trailingOutBubbleViewConstraint: NSLayoutConstraint!

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
        bubbleView.backgroundColor = model.owned ? .cyan : .green
        
        leadingInBubbleViewConstraint.priority = UILayoutPriority(model.owned ? 750 : 1000)
        leadingOutBubbleViewConstraint.priority = UILayoutPriority(model.owned ? 1000 : 750)

        trailingInBubbleViewConstraint.priority = UILayoutPriority(model.owned ? 750 : 1000)
        trailingOutBubbleViewConstraint.priority = UILayoutPriority(model.owned ? 1000 : 750)
    }
}
