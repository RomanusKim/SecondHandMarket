//
//  LocationReactor.swift
//  SecondHandMarket
//
//  Created by romanus on 3/11/24.
//

import Foundation
import ReactorKit

class LocationReactor : Reactor {
    
    enum Action {
        case setLocation
        case clickNextButton
    }
    enum Mutation {
        case goToKakaoMapViewController
        case goToHomeViewController
    }
    
    struct State {
        var isSetLocationButtonClicked = false
        var isNextButtonClicked = false
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setLocation:
            return Observable.just(Mutation.goToKakaoMapViewController)
        case .clickNextButton:
            return Observable.just(Mutation.goToHomeViewController)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goToKakaoMapViewController:
            newState.isSetLocationButtonClicked = true
            newState.isNextButtonClicked = false
        case .goToHomeViewController:
            newState.isSetLocationButtonClicked = false
            newState.isNextButtonClicked = true
        }
        
        return newState
    }
}
