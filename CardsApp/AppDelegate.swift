//
//  AppDelegate.swift
//  CardsApp
//
//  Created by Марк on 21.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    let bag = DisposeBag()
    var appCoordinator = AppCoordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let appStorage = AppStateStorage()
        appCoordinator.start(with: appStorage)
            .subscribe(onNext: { [weak window] (viewController) in
                window?.rootViewController = viewController
            }).disposed(by: bag)
        
        return true
    }
}

