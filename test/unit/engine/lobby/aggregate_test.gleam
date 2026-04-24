import core/models/player.{User}
import engine/lobby/aggregate
import engine/lobby/commands

pub fn validate_create_lobby_with_valid_id_test() {
  let command = commands.create_lobby("game_1")

  let assert Ok(result) = aggregate.validate_command(command)
  assert result == command
}

pub fn validate_create_lobby_with_empty_id_test() {
  let command = commands.create_lobby("")
  let assert Error(_) = aggregate.validate_command(command)
}

pub fn validate_join_lobby_test() {
  let command = commands.join_lobby("game_1", User("Alice"))

  let assert Ok(result) = aggregate.validate_command(command)
  assert result == command
}
