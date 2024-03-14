//
//  AddProductViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/14/24.
//

import UIKit


import ReactorKit
import RxSwift

class AddProductViewController: UIViewController, StoryboardView {
    typealias Reactor = AddProductReactor
    
    var disposeBag: RxSwift.DisposeBag = DisposeBag()
    
    

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var priceTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = AddProductReactor()
        configureContestTextView() // contents 테두리 설정
    }
    
    private func configureContestTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    func bind(reactor: AddProductReactor) {
        productNameTextField.rx.text
            .map{ Reactor.Action.productNameChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        priceTextField.rx.text
            .map { Reactor.Action.priceChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        contentsTextView.rx.text
            .map{ Reactor.Action.contentsChanged($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .map{ Reactor.Action.clickAddButton(self.productNameTextField.text, self.priceTextField.text, self.contentsTextView.text)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSavedSuccess)
            .filter{$0}
            .subscribe(onNext : { _ in
                print("[ESES##] addProduct true")
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
