import core/models/player.{User}
import engine/lobby/aggregate
import engine/lobby/commands
import engine/lobby/events.{LobbyCreated, UserJoined}
import gleam/list
import unitest

pub fn handle_create_lobby_emits_lobby_created_test() {
  use <- unitest.tags(["unit", "lobby", "aggregate"])
  let command = commands.create_lobby("game_1")
  let assert Ok(events) = aggregate.handle(command)
  let assert Ok(event) = list.first(events)
  assert LobbyCreated("game_1") == event
}

pub fn handle_create_lobby_empty_id_returns_error_test() {
  use <- unitest.tags(["unit", "lobby", "aggregate"])
  let command = commands.create_lobby("")
  let assert Error(_) = aggregate.handle(command)
}

pub fn handle_join_lobby_emits_user_joined_test() {
  use <- unitest.tags(["unit", "lobby", "aggregate"])
  let user = User("Alice")
  let command = commands.join_lobby("game_1", user)
  let assert Ok(events) = aggregate.handle(command)
  let assert Ok(event) = list.first(events)
  assert UserJoined("game_1", user) == event
}
