//
//  CardCell.swift
//  CardsApp
//
//  Created by Марк on 23.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    let cardView = CardView(frame: .zero)
    
    override init(frame: CGRect) {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.contentMode = .scaleAspectFit
        super.init(frame: frame)
        contentView.addSubview(cardView)
        NSLayoutConstraint.activate([
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fillWith(_ card: Card) {
        cardView.text = "\(card.title)\n\(card.description)"
        URL(string: card.image).map { cardView.sd_setImage(with: $0) }
    }
}
