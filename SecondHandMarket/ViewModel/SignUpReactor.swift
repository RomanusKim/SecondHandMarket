//
//  SignUpReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/6/24.
//

import Foundation
import ReactorKit

class SignUpReactor : Reactor {
    enum Action {
        case clickSignUpButton(name: String?, email: String?, password: String?)
        case clickDuplicateCheckButton(email: String?)
    }
    enum Mutation {
        case registUser(Bool)
        case checkDuplicateId(Bool)
    }
    struct State {
        var isRegistSuccess: Bool? = nil
        var isDuplicate: Bool? = nil
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        print(action.self)
        switch action {
        case let .clickSignUpButton(name, email, password):
            return UserAPI().registUser(email: email ?? "", password: password ?? "")
                .flatMap{ _ -> Observable<Mutation> in
                    let data = ["email": email ?? "", "username": name ?? "", "password": password ?? ""]
                    return UserAPI().saveUserData(data: data)
                        .map{ _ in .registUser(true)}
                        .catchAndReturn(.registUser(false))
                }
            
        case let .clickDuplicateCheckButton(email):
            return UserAPI().checkForDuplicateEmail(email: email ?? "")
                .map { Mutation.checkDuplicateId($0) }
                .catchAndReturn(.checkDuplicateId(false))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case let .registUser(isRegistSuccess):
            newState.isRegistSuccess = isRegistSuccess
        case let .checkDuplicateId(isDuplicate):
            newState.isDuplicate = isDuplicate
        }
        
        return newState
    }
}
