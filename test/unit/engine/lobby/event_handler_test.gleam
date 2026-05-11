import core/models/player.{User}
import core/models/state.{Initial, Lobby}
import engine/lobby/event_handler
import engine/lobby/events
import unitest

pub fn apply_lobby_created_transitions_to_lobby_test() {
  use <- unitest.tags(["unit", "lobby", "event_handler"])
  let event = events.LobbyCreated("game_1")

  assert Lobby(state: []) == event_handler.apply(Initial, event)
}

pub fn apply_user_joined_adds_user_to_lobby_test() {
  use <- unitest.tags(["unit", "lobby", "event_handler"])
  let user = User("Alice")
  let initial = Lobby(state: [])
  let event = events.UserJoined("game_1", user)

  assert Lobby(state: [user]) == event_handler.apply(initial, event)
}

pub fn apply_user_joined_appends_to_existing_users_test() {
  use <- unitest.tags(["unit", "lobby", "event_handler"])
  let alice = User("Alice")
  let bob = User("Bob")
  let initial = Lobby(state: [alice])
  let event = events.UserJoined("game_1", bob)

  assert Lobby(state: [alice, bob]) == event_handler.apply(initial, event)
}
