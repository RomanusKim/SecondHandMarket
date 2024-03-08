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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = SignUpReactor()
//        DataBaseManager.shared.deleteUser()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func bind(reactor: SignUpReactor) {
        signUpButton
            .rx.tap
            .map {
                SignUpReactor.Action.clickSignUpButton(name: self.nameTextField.text, id: self.newIdTextField.text, password: self.newPasswordTextField.text)
            }
            .bind(to: reactor.action) // 구독
            .disposed(by: disposeBag)
        
        duplicateCheckButton
            .rx.tap
            .map {
                SignUpReactor.Action.clickDuplicateCheckButton(id: self.newIdTextField.text)
            }
            .bind(to: reactor.action) // 구독
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSignUpSuccess)
            .subscribe(onNext: { isSignUpSuccess in
                if isSignUpSuccess { self.navigationController?.popViewController(animated: true) }
            })
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isExistId)
            .subscribe(onNext: { isExistId in
                if isExistId {
                    print("Sign Up Fail!!")
                    self.showMessage()
                } else {
                    print("Sign Up Success!!")
                }
            })
            .disposed(by: disposeBag)

    }
    
    private func showMessage() {
        let message = MessageView.viewFromNib(layout: .cardView)
        message.configureTheme(.info)
        message.configureContent(title: "알림", body: "이미 등록된 사용자입니다.")
        message.button?.isHidden = true
        
        SwiftMessages.show(view: message)
    }
    
}
