//
//  SignUpViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/6/24.
//

import Foundation
import UIKit
import ReactorKit
import RxSwift
import RxCocoa
import SwiftMessages

class SignUpViewController : UIViewController, StoryboardView {
    
    typealias Reactor = SignUpReactor
    
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var newIdTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var duplicateCheckButton: UIButton!

    let isSignUpButtonEnabled = BehaviorSubject<Bool>(value: false)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SignUpReactor()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: SignUpReactor) {
        Observable.combineLatest(
            reactor.state.map(\.isDuplicate).distinctUntilChanged(),
            self.nameTextField.rx.text.orEmpty,
            self.newIdTextField.rx.text.orEmpty,
            self.newPasswordTextField.rx.text.orEmpty)
        .map { isDuplicate, name, email, password in
            return !(isDuplicate ?? false) && !email.isEmpty &&
            !name.isEmpty && !password.isEmpty
        }
        .bind(to: isSignUpButtonEnabled)
        .disposed(by: disposeBag)
        
        isSignUpButtonEnabled
            .bind(to: self.signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        
        signUpButton
            .rx.tap
            .map {
                SignUpReactor.Action.clickSignUpButton(
                    name: self.nameTextField.text,
                    email: self.newIdTextField.text,
                    password: self.newPasswordTextField.text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        duplicateCheckButton
            .rx.tap
            .map { SignUpReactor.Action.clickDuplicateCheckButton(email: self.newIdTextField.text) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isRegistSuccess)
            .distinctUntilChanged()
            .filter { $0 != nil }
            .subscribe(onNext: { [weak self] isRegistSuccess in
                if isRegistSuccess ?? false {
                    self?.navigationController?.popViewController(animated: true)
                } else {
                    self?.showMessage(title: "알림", body: "회원가입 실패")
                }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isDuplicate)
            .distinctUntilChanged()
            .filter { $0 != nil }
            .subscribe(onNext: { isDuplicate in
                if isDuplicate ?? false {
                    self.showMessage(title: "알림", body: "이미 등록된 이메일입니다.")
                } else {
                    self.showMessage(title: "알림", body: "사용 가능한 이메일입니다.")
                }
            })
            .disposed(by: disposeBag)

    }
    
    // CommonUtility로 옮기기
    private func showMessage(title: String, body: String) {
        let message = MessageView.viewFromNib(layout: .cardView)
        message.configureTheme(.info)
        message.configureContent(title: title, body: body)
        message.button?.isHidden = true
        
        SwiftMessages.show(view: message)
    }
    
}
