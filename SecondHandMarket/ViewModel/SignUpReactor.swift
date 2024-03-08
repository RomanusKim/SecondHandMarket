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
        case clickSignUpButton(name: String?, id: String?, password: String?)
        case clickDuplicateCheckButton(id: String?)
    }
    enum Mutation {
        case createUser(name: String?, id: String?, password: String?)
        case checkDuplicateId(id: String?)
    }
    struct State {
        var isSignUpSuccess: Bool = false
        var isExistId: Bool = false
    }
    
    let initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        print(action.self)
        switch action {
        case let .clickSignUpButton(name, id, password): // 가입하기
            return Observable.just(.createUser(name: name, id: id, password: password))
        
        case let .clickDuplicateCheckButton(id): // ID 중복확인
            return Observable.just(.checkDuplicateId(id: id))
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .createUser(name: let name, id: let id, password: let password):
            newState.isSignUpSuccess = saveUser(name: name ?? "", id: id ?? "", password: password ?? "")
        case .checkDuplicateId(id: let id):
            newState.isExistId = duplicateCheck(id: id ?? "")
        }
        
        return newState
    }
    
    private func saveUser(name: String, id: String, password: String) -> Bool {
        let user = User()
        
        user.name = name
        user.id = id
        user.password = password
        
        // Realm 저장
        DataBaseManager.shared.saveUser(user: user)
        
        // 저장되었는지 확인하기
        let users = DataBaseManager.shared.getUser()
        
        let userWithId = users.filter { _ in id == user.id }
        if userWithId.first != nil {
            print("exist")
            return true
        } else {
            print("not esist")
            return false
        }
    }
    
    private func duplicateCheck(id: String) -> Bool {
        let users = DataBaseManager.shared.getUser()
        users.forEach { user in
            print("user : \(user)")
        }
        let userWithId = users.filter { _ in id == id }
        print("userwithId :: \(userWithId)")
        if userWithId.first?.id == id {
            print("duplicate exist")
            return true
        } else {
            print("duplicate not exist")
            return false
        }
        
    }
}
