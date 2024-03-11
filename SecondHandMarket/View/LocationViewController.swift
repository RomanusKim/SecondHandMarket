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

class LocationViewController : UIViewController, StoryboardView {
    var disposeBag: RxSwift.DisposeBag = DisposeBag()

    
    typealias Reactor = LocationReactor

    @IBOutlet weak var locationView: UIView!
    var animationView: LottieAnimationView?
    
    @IBOutlet weak var setLocationButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        animationView = LottieAnimationView.init(name: "location")
        animationView?.frame = locationView.bounds
        animationView?.contentMode = .scaleAspectFit
        animationView?.loopMode = .loop
        locationView.addSubview(animationView!)
    }
    
    func bind(reactor: LocationReactor) {
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animationView?.play()
    }
}
