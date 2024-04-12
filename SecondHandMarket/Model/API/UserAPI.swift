//
//  UserAPI.swift
//  SecondHandMarket
//
//  Created by romanus on 4/12/24.
//

import Foundation
import RxSwift
import FirebaseAuth
import FirebaseFirestore

/*
 User 관련 API Class
 */
class UserAPI {
    
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
    
    
    func checkForDuplicateEmail(email: String) -> Observable<Bool> {
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
    
    func registUser(email: String, password: String) -> Observable<AuthDataResult> {
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
    
    func saveUserData(data: [String: Any]) -> Observable<Bool> {
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
