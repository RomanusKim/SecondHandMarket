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
    typealias Reactor = LocationReactor
    
    var disposeBag: RxSwift.DisposeBag = DisposeBag()

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
            .map{ Reactor.Action.setLocation }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        nextButton
            .rx
            .tap
            .map { Reactor.Action.clickNextButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isSetLocationButtonClicked)
            .compactMap { $0 }
            .subscribe (onNext: { isSetLocationButtonClicked in
                let zipCodeViewController = ZipCodeViewController()
                zipCodeViewController.delegate = self
                self.present(zipCodeViewController, animated: true)
            })
            .disposed(by: disposeBag)
        
        reactor.pulse(\.$isNextButtonClicked)
            .compactMap { $0 }
            .subscribe(onNext: { _ in
                self.goToHomeViewController()
            })
            .disposed(by: disposeBag)
        
        myAddressSubject
            .subscribe(onNext: {[weak self] address in
                self?.myAddressLabel.text = address
                if ((address?.isEmpty) != nil) {
                    print("isNotEmpty")
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
    
    private func goToHomeViewController() {
        guard let homeViewController =
                self.storyboard?
            .instantiateViewController(withIdentifier: "HomeViewController") else {
            return
        }
        self.navigationController?.pushViewController(homeViewController, animated: true)
    }
}
