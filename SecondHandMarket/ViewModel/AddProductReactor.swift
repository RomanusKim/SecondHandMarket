//
//  AddProductReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/14/24.
//

import Foundation

import ReactorKit

class AddProductReactor : Reactor {
    enum Action {
        case productNameChanged(String?)
        case priceChanged(String?)
        case contentsChanged(String?)
        case clickAddButton(String?, String?, String?)
    }
    enum Mutation {
        case setProductName(String?)
        case setPrice(String?)
        case setContents(String?)
        case saveProductInformation(String?, String?, String?)
        
    }
    struct State {
        var productName: String? = ""
        var price: String? = ""
        var contents: String? = ""
        var isSavedSuccess: Bool = false
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
        case .clickAddButton(let pName, let price, let contents):
            return Observable.just(.saveProductInformation(pName, price, contents))
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
        case .saveProductInformation(let pName, let price, let contents):
            newState.isSavedSuccess = saveProduct(pName: pName ?? "", price: price ?? "", contents: contents ?? "")
        }
        
        return newState
    }
    
    private func saveProduct(pName: String, price: String, contents: String) -> Bool {
        let newProduct = Product()
        newProduct.pName = pName
        newProduct.price = price
        newProduct.contents = contents
        
        // Realm 저장
        DataBaseManager.shared.saveProduct(product: newProduct)
        
        // 저장되었는지 확인하기
        let dbProduct = DataBaseManager.shared.getProducts()
        
        let productInDB = dbProduct.filter { _ in pName == newProduct.pName }
        if productInDB.first != nil {
            print("저장된 제품 : \(productInDB)")
            return true
        } else {
            print("저장 실패")
            return false
        }
    }
}
