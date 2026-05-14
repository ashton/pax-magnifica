import core/models/player.{User}
import core/models/state.{Initial, Lobby}
import engine/lobby/aggregate
import engine/lobby/events
import unitest

pub fn apply_lobby_created_transitions_to_lobby_test() {
  use <- unitest.tags(["unit", "lobby", "state_fold"])
  let event = events.LobbyCreated("game_1")

  assert Lobby(state: []) == aggregate.apply(Initial, event)
}

pub fn apply_user_joined_adds_user_to_lobby_test() {
  use <- unitest.tags(["unit", "lobby", "state_fold"])
  let user = User("Alice")
  let initial = Lobby(state: [])
  let event = events.UserJoined("game_1", user)

  assert Lobby(state: [user]) == aggregate.apply(initial, event)
}

pub fn apply_user_joined_appends_to_existing_users_test() {
  use <- unitest.tags(["unit", "lobby", "state_fold"])
  let alice = User("Alice")
  let bob = User("Bob")
  let initial = Lobby(state: [alice])
  let event = events.UserJoined("game_1", bob)

  assert Lobby(state: [alice, bob]) == aggregate.apply(initial, event)
}
