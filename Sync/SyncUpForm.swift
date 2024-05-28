//
//  SyncUpForm.swift
//  Sync
//
//  Created by Paul  Colandrea on 5/28/24.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct SyncUpForm {
    @ObservableState
    struct State {
        var syncUp: SyncUp
    }
    
    enum Action: BindableAction {
      case binding(BindingAction<State>)
      case onDeleteAttendees(IndexSet)
        case addAttendeeButtonTapped
    }
    
    var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case let .onDeleteAttendees(indices):
                state.syncUp.attendees.remove(atOffsets: indices)
                if state.syncUp.attendees.isEmpty {
                    state.syncUp.attendees.append(
                        Attendee(id: Attendee.ID())
                    )
                }
                return .none
            }
        }
    }
}

//#Preview {
//    SyncUpForm()
//}
