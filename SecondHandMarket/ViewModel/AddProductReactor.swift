//
//  AddProductReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/14/24.
//

import Foundation

import ReactorKit
import FirebaseStorage
import Firebase

class AddProductReactor : Reactor {
    enum Action {
        case productNameChanged(String?)
        case priceChanged(String?)
        case contentsChanged(String?)
        case clickAddButton(UIImage, String?, String?, String?)
    }
    enum Mutation {
        case setProductName(String?)
        case setPrice(String?)
        case setContents(String?)
        case saveProduct(Bool)
        
    }
    struct State {
        var productName: String? = ""
        var price: String? = ""
        var contents: String? = ""
        var isSavedSuccess: Bool? = nil
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .productNameChanged(let pName):
            return Observable.just(.setProductName(pName))
        case .priceChanged(let price):
            return Observable.just(.setPrice(price))
        case .contentsChanged(let contents):
            return Observable.just(.setContents(contents))
        case let.clickAddButton(image, pName, price, contents):
            return saveProducet(image: image, pName: pName ?? "", price: price ?? "", contents: contents ?? "")
                .map { _ in
                        .saveProduct(true)
                }
                .catchAndReturn(.saveProduct(false))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        switch mutation {
        case .setProductName(let pName):
            newState.productName = pName
        case .setPrice(let price):
            newState.price = price
        case .setContents(let contents):
            newState.contents = contents
        case let.saveProduct(isSavedSuccess):
            newState.isSavedSuccess = isSavedSuccess
        }
        
        return newState
    }

    private func saveProducet(image: UIImage, pName: String, price: String, contents: String) -> Observable<Bool> {
        
        return Observable.create { observer in
            
            guard let imageData = image.jpegData(compressionQuality: 0.5) else { return observer.onNext(false) as! Disposable }
            let metaData = StorageMetadata()
            let address = UserDefaults.standard.string(forKey: "Address") ?? ""
            
            
            metaData.contentType = "image/jpeg"
            
            
            metaData.customMetadata = ["name" : pName, "price" : price, "contents" : contents, "address" : address]
            
            let imageName = UUID().uuidString
            let firebaseReference = Storage.storage().reference().child("\(imageName)")
            
            firebaseReference.putData(imageData, metadata: metaData) {
                metaData, error in
                
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onNext(true)
                    observer.onCompleted()
                }
            }
            return Disposables.create()
        }
        
        
    }
}
