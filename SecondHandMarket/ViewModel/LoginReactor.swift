//
//  LoginReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/4/24.
//

import Foundation
import ReactorKit
import FirebaseAuth

class LoginReactor : Reactor {
    
    enum Action {
//        case clickLogin(id: String?, password: String?)
        case clickSignUpButton
        case clickLogin(email: String?, password: String?)
    }
    enum Mutation {
//        case doAuthCheck(id: String?, password: String?)
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
            return loginIn(email: email ?? "", password: password ?? "")
                .map { Mutation.login($0) }
                .catchAndReturn( .login(false) )
        case .clickSignUpButton:
            return Observable.just(.goToSignUpViewController)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
//        case .doAuthCheck(id: let id, password: let password):
//            newState.isLoginSuccess = true
        case let .login(isLoginSuccess):
            newState.isLoginSuccess = isLoginSuccess
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
    
    func loginIn(email: String, password: String) -> Observable<Bool> {
        return Observable.create { observer in
            Auth.auth().signIn(withEmail: email, password: password) {
                result, error in
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
