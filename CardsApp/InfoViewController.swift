//
//  InfoViewController.swift
//  CardsApp
//
//  Created by Марк on 23.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit
import RxSwift

class InfoViewController: UIViewController {
    
    let cardService: CardServiceProtocol
    let label = UILabel()
    let bag = DisposeBag()
    
    init(with cardService: CardServiceProtocol) {
        self.cardService = cardService
        super.init(nibName: nil, bundle: nil)
        title = "Info"
        tabBarItem.image = UIImage(systemName: "airplayvideo")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cardService.obtainSavedCard().subscribe(onSuccess: { [weak self] (card) in
            self?.label.text = card?.title
        }).disposed(by: bag)
    }
}
