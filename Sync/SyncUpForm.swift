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
            case .addAttendeeButtonTapped:
                state.syncUp.attendees.append(
                    Attendee(id: Attendee.ID())
                )
                return .none
                
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

struct SyncUpFormView {
    @Bindable var store: StoreOf<SyncUpForm>
    @FocusState var focus: Field?
    
    enum Field: Hashable {
      case attendee(Attendee.ID)
      case title
    }
    
    var body: some View {
        Form {
            Section {
              TextField("Title", text: $store.syncUp.title)
                    .focused($focus, equals: .title)
                    .onAppear(perform: {
                        focus = .title
                    })
              HStack {
                Slider(value: $store.syncUp.duration.minutes, in: 5...30, step: 1) {
                  Text("Length")
                }
                Spacer()
                Text(store.syncUp.duration.formatted(.units()))
              }
              ThemePicker(selection: $store.syncUp.theme)
            } header: {
              Text("Sync-up Info")
            }
            Section {
              ForEach($store.syncUp.attendees) { $attendee in
                  TextField("Name", text: $attendee.name)
                      .focused($focus, equals: .attendee(attendee.id))
              }
              .onDelete { indices in
                store.send(.onDeleteAttendees(indices))
              }


              Button("New attendee") {
                store.send(.addAttendeeButtonTapped)
                  focus = .attendee(store.syncUp.attendees.last!.id)
              }
            } header: {
              Text("Attendees")
            }
        }
    }
}

struct ThemePicker: View {
  @Binding var selection: Theme


  var body: some View {
    Picker("Theme", selection: $selection) {
      ForEach(Theme.allCases) { theme in
        ZStack {
          RoundedRectangle(cornerRadius: 4)
            .fill(theme.mainColor)
          Label(theme.name, systemImage: "paintpalette")
            .padding(4)
        }
        .foregroundColor(theme.accentColor)
        .fixedSize(horizontal: false, vertical: true)
        .tag(theme)
      }
    }
  }
}


extension Duration {
  fileprivate var minutes: Double {
    get { Double(components.seconds / 60) }
    set { self = .seconds(newValue * 60) }
  }
}

//#Preview {
//    SyncUpFormView()
//}
