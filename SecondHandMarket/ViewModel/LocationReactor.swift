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
    }
    enum Mutation {
        case goToKakaoMapViewController
    }
    
    struct State {
        var isSetLocationButtonClicked = false
    }
    
    var initialState: State = State()
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .setLocation:
            return Observable.just(.goToKakaoMapViewController)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .goToKakaoMapViewController:
            newState.isSetLocationButtonClicked = true
        }
        
        return newState
    }
}
