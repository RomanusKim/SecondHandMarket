//
//  LoginReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/4/24.
//

import Foundation
import ReactorKit

class LoginReactor : Reactor {
    
    enum Action {
        case clickLogin(id: String?, password: String?)
        case clickSignUpButton
    }
    enum Mutation {
        case doAuthCheck(id: String?, password: String?)
        case goToSignUpViewController
    }
    struct State {
        var isLoginSuccess: Bool = false
        var isSignUpButtonClicked: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .clickLogin(id, password):
            return Observable.just(.doAuthCheck(id: id, password: password))
        case .clickSignUpButton:
            return Observable.just(.goToSignUpViewController)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .doAuthCheck(id: let id, password: let password):
            newState.isLoginSuccess = authCheck(id: id ?? "", password: password ?? "")
        case .goToSignUpViewController:
            newState.isSignUpButtonClicked = true
        }
        
        return newState
    }
    
    
    private func authCheck(id: String, password: String) -> Bool {
        if id == "kes" && password == "1234" {
            return true
        } else {
            return false
        }
    }
}
