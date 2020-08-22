//
//  OnboardingViewController.swift
//  CardsApp
//
//  Created by Марк on 21.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class OnboardingViewController: UIViewController {
    
    private let bag = DisposeBag()
    let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title3)
        button.backgroundColor = .black
        return button
    }()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        view.addSubview(continueButton)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44),
            continueButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        ])
    }
}
