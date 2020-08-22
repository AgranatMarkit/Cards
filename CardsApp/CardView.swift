//
//  CardView.swift
//  CardsApp
//
//  Created by Марк on 23.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit

class CardView: UIImageView {
    
    var text: String? {
        set { label.text = newValue }
        get { label.text }
    }
    
    private class CardLabel: UILabel {
        
        var contentInset: UIEdgeInsets = .zero
        
        override var intrinsicContentSize: CGSize {
            var intrinsicContentSize = super.intrinsicContentSize
            intrinsicContentSize.height += contentInset.top + contentInset.bottom
            intrinsicContentSize.width += contentInset.left + contentInset.right
            return intrinsicContentSize
        }
    }
    
    private let label: CardLabel = {
        let label = CardLabel()
        label.textAlignment = .center
        label.backgroundColor = .white
        label.layer.masksToBounds = true
        label.contentInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.layer.cornerRadius = floor(min(label.bounds.width, label.bounds.height) / 2)
    }
}
