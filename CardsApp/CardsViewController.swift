//
//  CardsViewController.swift
//  CardsApp
//
//  Created by Марк on 22.08.2020.
//  Copyright © 2020 Agranat Mark. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import InfiniteLayout

class CardsViewController: UIViewController {
    
    var cards = [Card]()
    let cardService: CardServiceProtocol
    let bag = DisposeBag()
    let cardSelected = PublishSubject<Card>()
    var needScrollToFirstItem = false
    let collectionView: InfiniteCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        return InfiniteCollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    var autoscrollTimerBag: DisposeBag?
    
    init(with cardService: CardServiceProtocol) {
        self.cardService = cardService
        super.init(nibName: nil, bundle: nil)
        title = "Cards"
        tabBarItem.image = UIImage(systemName: "airplayaudio")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isItemPagingEnabled = true
        collectionView.preferredCenteredIndexPath = nil 
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: "\(CardCell.self)")
        cardService.obtainCards()
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] cards in
                self?.cards = Array(cards[0...3])
                self?.collectionView.reloadData()
                self?.enableAutoscroll()
            }).disposed(by: bag)
    }
    
    func enableAutoscroll() {
        autoscrollTimerBag = DisposeBag()
        let autoscrollTimer = Observable<Int>.timer(.seconds(0), period: .seconds(2), scheduler: MainScheduler.instance)
        autoscrollTimer.subscribe(onNext: { [weak self] tick in
            guard let self = self else { return }
            let collectionView = self.collectionView
            let numberOfItems = collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: 0) ?? 0
            let indexPath = IndexPath(row: tick % numberOfItems, section: 0)
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }).disposed(by: autoscrollTimerBag!)
    }
    
    func disableAutoscroll() {
        autoscrollTimerBag = nil
    }
}

extension CardsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(CardCell.self)", for: indexPath) as! CardCell
        let realIndexPath = self.collectionView.indexPath(from: indexPath)
        let card = cards[realIndexPath.row]
        cell.fillWith(card)
        return cell
    }
}

extension CardsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width * 0.8,
                      height: collectionView.bounds.height * 0.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}

extension CardsViewController: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        disableAutoscroll()
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        disableAutoscroll()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        disableAutoscroll()
        let row = self.collectionView.indexPath(from: indexPath).row
        cardSelected.onNext(self.cards[row])
    }
}
