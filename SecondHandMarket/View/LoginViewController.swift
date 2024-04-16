//
//  LoginViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/5/24.
//

import Foundation
import ReactorKit
import UIKit
import RxSwift
import RxCocoa

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
        // 로그인
        loginButton
            .rx.tap
            .map { LoginReactor.Action.clickLogin(email: self.idTextField.text, password: self.passwordTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 회원가입 화면
        signUpButton
            .rx.tap
            .map { LoginReactor.Action.clickSignUpButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map{$0.isLoginSuccess}
            .distinctUntilChanged()
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] isLoginSuccess in
                if isLoginSuccess ?? false {
                    self?.navigationController?.goToViewController(identifier: "Location")
                }
            }).disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSignUpButtonClicked)
            .subscribe(onNext: { [weak self] isSignUpButtonClicked in
                if isSignUpButtonClicked {
                    self?.navigationController?.goToViewController(identifier: "SignUp")
                }
            })
            .disposed(by: disposeBag)
    }
}
