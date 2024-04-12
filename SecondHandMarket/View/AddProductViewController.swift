//
//  AddProductViewController.swift
//  SecondHandMarket
//
//  Created by romanus on 3/14/24.
//

import UIKit


import ReactorKit
import RxSwift
import FirebaseStorage
import Firebase

class AddProductViewController: UIViewController, StoryboardView {
    typealias Reactor = AddProductReactor
    
    var disposeBag: DisposeBag = DisposeBag()
    
    

    @IBOutlet weak var productNameTextField: UITextField!
    @IBOutlet weak var contentsTextView: UITextView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var productImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reactor = AddProductReactor()
        configureContestTextView() // contents 테두리 설정
        configureImageView() // imageView 테두리 설정
        
        // image tap gesture
        let tapGestureImageRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapGestureImageRecognizer)
    }
    
    @objc func imageTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    private func configureContestTextView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.contentsTextView.layer.borderColor = borderColor.cgColor
        self.contentsTextView.layer.borderWidth = 0.5
        self.contentsTextView.layer.cornerRadius = 5.0
    }
    
    private func configureImageView() {
        let borderColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1.0)
        self.productImage.layer.borderColor = borderColor.cgColor
        self.productImage.layer.borderWidth = 0.5
        self.productImage.layer.cornerRadius = 5.0
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
            .map{ Reactor.Action.clickAddButton(
                self.productImage.image!,
                self.productNameTextField.text,
                self.priceTextField.text,
                self.contentsTextView.text)
            }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.isSavedSuccess)
            .distinctUntilChanged()
            .filter{ $0 != nil }
            .subscribe(onNext : { _ in
                print("[ESES##] addProduct true")
                self.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
//    static func downloadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
//            let storageReference = Storage.storage().reference(forURL: urlString)
//            let megaByte = Int64(1 * 1024 * 1024)
//            storageReference.getData(maxSize: megaByte) { data, error in
//                guard let imageData = data else {
//                    completion(nil)
//                    return
//                }
//                completion(UIImage(data: imageData))
//            }
//        }
}

extension AddProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            selectedImage.jpegData(compressionQuality: 0.5)
            productImage.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
