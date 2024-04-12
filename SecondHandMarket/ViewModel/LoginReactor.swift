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
        case clickSignUpButton
        case clickLogin(email: String?, password: String?)
    }
    enum Mutation {
        case login(Bool)
        case goToSignUpViewController
    }
    struct State {
        var isLoginSuccess: Bool? = nil
        var isSignUpButtonClicked: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .clickLogin(email, password):
            return UserAPI().loginIn(email: email ?? "", password: password ?? "")
                .map{ Mutation.login($0) }
                .catchAndReturn(.login(false))
        case .clickSignUpButton:
            return Observable.just(.goToSignUpViewController)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .login(isLoginSuccess):
            newState.isLoginSuccess = isLoginSuccess
        case .goToSignUpViewController:
            newState.isSignUpButtonClicked = true
        }
        
        return newState
    }
}
