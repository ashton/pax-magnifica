import core/models/state.{type State, Lobby}
import engine/lobby/events.{type LobbyEvent, LobbyCreated, UserJoined}
import gleam/list

pub fn apply(state: State, event: LobbyEvent) -> State {
  case event {
    LobbyCreated(_) -> Lobby(state: [])
    UserJoined(_, user) ->
      state.update_lobby(state, fn(users) { list.append(users, [user]) })
  }
}
