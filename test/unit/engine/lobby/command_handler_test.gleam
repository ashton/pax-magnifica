import core/models/player.{User}
import engine/lobby/command_handler
import engine/lobby/commands
import engine/lobby/events.{LobbyCreated, UserJoined}
import gleam/list

pub fn process_create_lobby_test() {
  let command = commands.create_lobby("game_1")

  let assert Ok(event) = command_handler.process(command) |> list.first()
  assert LobbyCreated("game_1") == event
}

pub fn process_join_lobby_test() {
  let user = User("Alice")
  let command = commands.join_lobby("game_1", user)

  let assert Ok(event) = command_handler.process(command) |> list.first()
  assert UserJoined("game_1", user) == event
}
