//
//  HomeViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/12/24.
//

import UIKit

import ReactorKit
import RxSwift

class HomeViewController: UIViewController, StoryboardView {
    
    
    typealias Reactor = HomeViewReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var productList = [Product]()
    // Subject로 바꿀것인가 그냥 둘것인가
    var address = UserDefaults.standard.string(forKey: "Address")

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = HomeViewReactor()
        print("HomeViewController Addrss : \(address)")
    }
    
    func bind(reactor: HomeViewReactor) {
        reactor.state
            .map{ $0.product }
            .subscribe(onNext: { [weak self] product in
                print(product)
                /*
                 ToDo :
                 collectionView에 product를 넣어주기
                 */
            })
            .disposed(by: disposeBag)
        
        reactor.action.onNext(.getAllData)
    }
}
