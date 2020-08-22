//
//  AppCoordinator.swift
//  CardsApp
//
//  Created by Марк on 22.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import Foundation
import RxSwift

class AppCoordinator {
    
    let bag = DisposeBag()
    
    func start(with appStorage: AppStateStorageProtocol) -> Observable<UIViewController> {
        let mainFlow = self.mainFlow(with: appStorage)
        let onboardingFlow = self.onboardingFlow(with: appStorage)
        return appStorage
            .getOnboardingPassed()
            .asObservable()
            .flatMap { $0 ? mainFlow : onboardingFlow }
    }
    
    func mainFlow(with appStorage: AppStateStorageProtocol) -> Observable<UIViewController> {
        let tabBarController = UITabBarController()
        let cardService = CardService()
        let cardsViewController = CardsViewController(with: cardService)
        cardsViewController.cardSelected
            .subscribe(onNext: { [weak self] card in self?.displayAlertForCard(card,
                                                                               above: tabBarController,
                                                                               with: cardService) })
            .disposed(by: bag)
        let infoViewController = InfoViewController(with: cardService)
        
        tabBarController.viewControllers = [
            cardsViewController,
            infoViewController,
            UIViewController.controllerWithTitle("3"),
            UIViewController.controllerWithTitle("4"),
            UIViewController.controllerWithTitle("5"),
        ].wrappedIntoNavigationController()
        return Observable.just(tabBarController)
    }
    
    func onboardingFlow(with appStorage: AppStateStorageProtocol) -> Observable<UIViewController> {
        let onboarding = OnboardingViewController()
        let mainFlow = self.mainFlow(with: appStorage)
        let continueTap = onboarding
            .continueButton.rx.tap
            .flatMap { _ in appStorage.setOnboardingPassed().andThen(Observable.just(0)) }
            .flatMap { _ in mainFlow }
        return Observable.merge([Observable.just(onboarding), continueTap])
    }
    
    func displayAlertForCard(_ card: Card, above parent: UIViewController, with cardService: CardServiceProtocol) {
        let alert = UIAlertController(title: card.title, message: card.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { [weak self] _ in
            guard let self = self else { return }
            cardService.saveCard(card).subscribe().disposed(by: self.bag)
        }))
        parent.present(alert, animated: true, completion: nil)
    }
}

extension UINavigationController {
    func withLargeTitile() -> Self {
        navigationBar.prefersLargeTitles = true
        return self
    }
}

extension UIViewController {
    static func controllerWithTitle(_ title: String) -> UIViewController {
        let vc = UIViewController()
        vc.title = title
        vc.view.backgroundColor = UIColor.white
        vc.tabBarItem.title = title
        vc.tabBarItem.image = UIImage(systemName: "arkit")
        return vc
    }
    
    func wrappedIntoNavigationController() -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: self).withLargeTitile()
        navigationController.title = title
        navigationController.tabBarItem.title = tabBarItem.title
        navigationController.tabBarItem.image = tabBarItem.image
        return navigationController
    }
}

extension Array where Element: UIViewController  {
    func wrappedIntoNavigationController() -> [UINavigationController] {
        return self.map { $0.wrappedIntoNavigationController() }
    }
}
