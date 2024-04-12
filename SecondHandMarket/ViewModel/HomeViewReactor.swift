//
//  HomeViewReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/15/24.
//

import Foundation
import ReactorKit
import FirebaseStorage
import Firebase

class HomeViewReactor : Reactor {
    enum Action {
        case getAllData
    }
    enum Mutation {
        case setData([Product])
    }
    struct State {
        var product: [Product]?
    }
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .getAllData:
            return getAllProduct()
                .map { Mutation.setData( $0 )}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = State()
        switch mutation {
        case .setData(let product):
            newState.product = product
        }
        
        return newState
    }
    
    private func getAllProduct() -> Observable<[Product]> {
        return Observable.create { observer in
            let storageReference = Storage.storage().reference()
            let bytes = Int64(1 * 1024 * 1024)
            
            storageReference.listAll { result, error in
                if let error = error {
                    observer.onError(error)
                    return
                }
                
                var products: [Product] = []
                
                for imageReference in result!.items {
                    imageReference.getMetadata { metaData, error in
                        if let metaData = metaData?.customMetadata {
                            imageReference.getData(maxSize: bytes) { data, error in
                                if let data = data, let image = UIImage(data: data) {
                                    let product = Product(
                                        image: image,
                                        name: metaData["name"] ?? "",
                                        price: metaData["price"] ?? "",
                                        contents: metaData["contents"] ?? ""
                                    )
                                    products.append(product)
                                    
                                    if products.count == result!.items.count {
                                        observer.onNext(products)
                                        observer.onCompleted()
                                    }
                                }
                            }
                        }
                    }
                }
            }
            return Disposables.create()
        }
    }
}
