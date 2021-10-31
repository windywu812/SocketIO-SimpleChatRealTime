//
//  MessageTableViewCell.swift
//  SocketIO-RealTime
//
//  Created by Windy on 31/10/21.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "MessageTableViewCell"
    var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!
    
    // MARK: UI Element
    lazy var messageLabel: UILabel! = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var bubbleView: UIImageView! = {
        let containerView = UIImageView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        contentView.addSubview(bubbleView)
        contentView.addSubview(messageLabel)
        
        leadingConstraint = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        trailingConstraint = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.7),
            
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 4),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -4),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 8),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -8)
        ])
        
    }
    
    func configureCell(message: MessageModel) {
        if message.isSender {
            let bubbleImage = UIImage(named: "outgoing-message-bubble")?
                .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21))
                .withRenderingMode(.alwaysTemplate)
            bubbleView.image = bubbleImage
            bubbleView.tintColor = .systemGreen
            messageLabel.textColor = .white
            leadingConstraint.isActive = false
            trailingConstraint.isActive = true
        } else {
            let bubbleImage = UIImage(named: "incoming-message-bubble")?
                .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                                resizingMode: .stretch)
                .withRenderingMode(.alwaysTemplate)
            bubbleView.image = bubbleImage
            bubbleView.tintColor = .systemGray5
            messageLabel.textColor = .label
            leadingConstraint.isActive = true
            trailingConstraint.isActive = false
        }
        
        messageLabel.text = message.message
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
