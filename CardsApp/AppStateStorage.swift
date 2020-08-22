//
//  AppStateStorage.swift
//  CardsApp
//
//  Created by Марк on 22.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import Foundation
import RxSwift

protocol AppStateStorageProtocol: AnyObject {
    func setOnboardingPassed() -> Completable
    func getOnboardingPassed() -> Single<Bool>
    func clear()
}

class AppStateStorage: AppStateStorageProtocol {
    enum Keys: String {
        case onpoardingPassed = "onboardingPassed"
    }
    
    func setOnboardingPassed() -> Completable {
        return Completable.create { (observer) -> Disposable in
            UserDefaults.standard.set(true, forKey: Keys.onpoardingPassed.rawValue)
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func getOnboardingPassed() -> Single<Bool> {
        return Single<Bool>.create { (observer) -> Disposable in
            let onboaringPassed = UserDefaults.standard.value(forKey: Keys.onpoardingPassed.rawValue) as? Bool ?? false
            observer(.success(onboaringPassed))
            return Disposables.create()
        }
    }
    
    func clear() {
        UserDefaults.standard.set(nil, forKey: Keys.onpoardingPassed.rawValue)
    }
}
