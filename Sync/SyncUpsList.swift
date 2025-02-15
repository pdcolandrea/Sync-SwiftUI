//
//  SyncUpsList.swift
//  Sync
//
//  Created by Paul  Colandrea on 5/23/24.
//

import SwiftUI
import ComposableArchitecture

struct SyncUpsListView: View {
    let store: StoreOf<SyncUpsList>
    
    var body: some View {
        List {
            ForEach(store.syncUps) { syncUp in
                Button {
                    
                } label: {
                    CardView(syncUp: syncUp)
                }
                .listRowBackground(syncUp.theme.mainColor)
            }
            .onDelete{ indexSet in
                store.send(.onDelete(indexSet))
            }
        }.toolbar {
            Button {
                store.send(.addSyncUpButtonTapped)
            } label: {
                Image(systemName: "plus")
            }
        }
        .navigationTitle("Daily Sync-Ups")
    }
}

@Reducer
struct SyncUpsList {
    @ObservableState
    struct State {
        var syncUps: IdentifiedArrayOf<SyncUp> = []
    }
    
    enum Action {
        case addSyncUpButtonTapped
        case onDelete(IndexSet)
        case onSyncUpTapped(id: SyncUp.ID)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .addSyncUpButtonTapped:
                return .none
                
            case let .onDelete(indexSet):
                state.syncUps.remove(atOffsets: indexSet)
                return .none
                
            case .onSyncUpTapped:
                return .none
            }
            
        }
    }
}

struct CardView: View {
    let syncUp: SyncUp
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(syncUp.title).font(.headline)
            Spacer()
            HStack() {
                Label("\(syncUp.attendees.count)", systemImage: "person.3")
                Spacer()
                Label(syncUp.duration.formatted(.units()), systemImage: "clock")
                                    .labelStyle(.trailingIcon)
            }.font(.caption)
        }
        .padding()
        .foregroundColor(syncUp.theme.accentColor)
    }
}

struct TrailingIconLabelStyle: LabelStyle {
  func makeBody(configuration: Configuration) -> some View {
    HStack {
      configuration.title
      configuration.icon
    }
  }
}


extension LabelStyle where Self == TrailingIconLabelStyle {
  static var trailingIcon: Self { Self() }
}


#Preview {
  NavigationStack {
    SyncUpsListView(
      store: Store(
        initialState: SyncUpsList.State(
          syncUps: [
            SyncUp(
              id: SyncUp.ID(),
              attendees: [
                Attendee(id: Attendee.ID(), name: "Blob"),
                Attendee(id: Attendee.ID(), name: "Blob Jr."),
                Attendee(id: Attendee.ID(), name: "Blob Sr."),
              ],
              title: "Point-Free Morning Sync"
            )
          ]
        )
      ) {
        SyncUpsList()
              ._printChanges()
      }
    )
  }
}
