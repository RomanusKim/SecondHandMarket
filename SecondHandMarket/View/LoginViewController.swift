//
//  LoginViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/5/24.
//

import Foundation
import ReactorKit
import UIKit

class LoginViewController : UIViewController, StoryboardView {
    
    
    typealias Reactor = LoginReactor
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = LoginReactor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    
    
    func bind(reactor: LoginReactor) {
    
    }
}
