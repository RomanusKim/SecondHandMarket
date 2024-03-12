//
//  LocationViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/11/24.
//

import UIKit
import Lottie
import ReactorKit
import RxSwift
import WebKit

protocol ZipCodeDelegate: AnyObject {
    func didReceive(address: String)
}

class LocationViewController : UIViewController, StoryboardView, ZipCodeDelegate {
    var disposeBag: RxSwift.DisposeBag = DisposeBag()

    
    typealias Reactor = LocationReactor

    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var setLocationButton: UIButton!
    @IBOutlet weak var myAddressLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    private let myAddressSubject = BehaviorSubject<String?>(value: nil)
    var myAddressObservable: Observable<String?> { return myAddressSubject.asObservable() }
    
    
    var animationView: LottieAnimationView?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = LottieAnimationView.init(name: "location")
        animationView?.frame = locationView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        locationView.addSubview(animationView!)
        
        self.reactor = LocationReactor()
    }
    
    func bind(reactor: LocationReactor) {
        setLocationButton
            .rx
            .tap
            .map{Reactor.Action.setLocation}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isSetLocationButtonClicked }
            .subscribe (onNext: { isSetLocationButtonClicked in
                print("isSetLocation : \(isSetLocationButtonClicked)")
                if isSetLocationButtonClicked {
                        //go to KakaoVC
                    let zipCodeViewController = ZipCodeViewController()
                    zipCodeViewController.delgate = self
                    self.present(zipCodeViewController, animated: true)
                }
            })
            .disposed(by: disposeBag)
        
        myAddressSubject
            .subscribe(onNext: {[weak self] address in
                self?.myAddressLabel.text = address
                if ((address?.isEmpty) != nil) {
                    print("isNotEmpty")
                    // 입장하기 버튼 활성화
                    UserDefaults.standard.setValue(address, forKey: "Address")
                    self?.nextButton.isEnabled = true
                }
            })
            .disposed(by: disposeBag)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView?.play()
    }
    
    func didReceive(address: String) {
        myAddressSubject.onNext(address)
    }
}
