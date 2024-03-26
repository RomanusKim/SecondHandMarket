//
//  SignUpReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/6/24.
//

import Foundation
import ReactorKit
import FirebaseAuth
import FirebaseFirestore

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
            return registUser(email: email ?? "", password: password ?? "")
                .flatMap { _ -> Observable<Mutation> in
                    let data = ["email": email ?? "", "username": name ?? "", "password": password ?? ""]
                    return self.saveUserData(data: data)
                        .map { _ in .registUser(true)}
                        .catchAndReturn(.registUser(false))
                }
        
        case let .clickDuplicateCheckButton(email):
            return checkForDuplicateEmail(email: email ?? "")
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
    
    private func checkForDuplicateEmail(email: String) -> Observable<Bool> {
            return Observable.create { observer in
                Firestore.firestore().collection("user").whereField("email", isEqualTo: email).getDocuments { snapshot, error in
                    if let error = error {
                        observer.onError(error)
                    } else {
                        let isDuplicate = !(snapshot?.documents.isEmpty ?? false)
                        observer.onNext(isDuplicate)
                        observer.onCompleted()
                    }
                }
                return Disposables.create()
            }
        }
    
    private func registUser(email: String, password: String) -> Observable<AuthDataResult> {
        return Observable.create { observer in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    observer.onError(error)
                } else if let result = result {
                    observer.onNext(result)
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
    }
    
    private func saveUserData(data: [String: Any]) -> Observable<Bool> {
        return Observable.create { observer in
            Firestore.firestore().collection("user").document().setData(data) { error in
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
