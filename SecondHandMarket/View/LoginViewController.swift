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
            .map { LoginReactor.Action.clickLogin(id: self.idTextField.text, password: self.passwordTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // 회원가입 화면
        signUpButton
            .rx.tap
            .map { LoginReactor.Action.clickSignUpButton }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
//        reactor.state
//            .map{$0.isLoginSuccess}
//            .subscribe(onNext: { isLoginSuccess in
//                    print("\(isLoginSuccess)")
//                // true - Next VC
//                // false - toast?
//            }).disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSignUpButtonClicked)
            .subscribe(onNext: { isSignUpButtonClicked in
                print("isSignUpButtonClicked : \(isSignUpButtonClicked)")
                if isSignUpButtonClicked { self.goToSignUpViewController() }
            })
            .disposed(by: disposeBag)
        
    }
    
    private func goToSignUpViewController() {
        guard let signUpViewController = self.storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") else {
            return
        }
        self.navigationController?.popToViewController(signUpViewController, animated: true)
    }
}
