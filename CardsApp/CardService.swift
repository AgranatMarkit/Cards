//
//  CardService.swift
//  CardsApp
//
//  Created by Марк on 22.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit
import RxSwift

struct Card: Codable {
    let id: String
    let title: String
    let description: String
    let image: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ringtone_id"
        case title
        
        case description
        case image = "image_aws_url"
    }
}

protocol CardServiceProtocol {
    func obtainCards() -> Single<[Card]>
    func saveCard(_ card: Card) -> Completable
    func obtainSavedCard() -> Single<Card?>
}

class CardService: CardServiceProtocol {
    
    enum Constants: String {
        case cardsUrl = "https://ringtones-kodi.s3.amazonaws.com/data/top_ringtones.json"
        case cardStorageKey = "cardStorageKey"
    }
    
    let session = URLSession(configuration: .default)
    
    func obtainCards() -> Single<[Card]> {
        return session.rx.data(request: URLRequest(url: URL(string: Constants.cardsUrl.rawValue)!)).asSingle().map { (data) -> [Card] in
            let cards = try? JSONDecoder().decode([Card].self, from: data)
            return cards ?? []
        }
    }
    
    func saveCard(_ card: Card) -> Completable {
        return Completable.create { (observer) -> Disposable in
            let data = try? JSONEncoder().encode(card)
            data.map { UserDefaults.standard.set($0, forKey: Constants.cardStorageKey.rawValue) }
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func obtainSavedCard() -> Single<Card?> {
        return Single.create { (observer) -> Disposable in
            let data = UserDefaults.standard.value(forKey: Constants.cardStorageKey.rawValue) as? Data
            let card = data.flatMap { try? JSONDecoder().decode(Card.self, from: $0) }
            observer(.success(card))
            return Disposables.create()
        }
    }
}
