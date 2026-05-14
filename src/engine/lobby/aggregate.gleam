import core/models/state.{type State, Lobby}
import core/value_objects/game
import engine/lobby/commands.{type LobbyCommand, CreateLobby, JoinLobby}
import engine/lobby/events.{type LobbyEvent, LobbyCreated, UserJoined}
import gleam/list
import gleam/result

fn validate(command: LobbyCommand) -> Result(LobbyCommand, String) {
  case command {
    CreateLobby(id) ->
      game.new_id(id)
      |> result.replace(command)
    JoinLobby(_, _) -> Ok(command)
  }
}

pub fn validate_command(command: LobbyCommand) -> Result(LobbyCommand, String) {
  validate(command)
}

pub fn handle(command: LobbyCommand) -> Result(List(LobbyEvent), String) {
  use _ <- result.try(validate(command))
  case command {
    CreateLobby(id) -> Ok([events.LobbyCreated(id)])
    JoinLobby(lobby, user) -> Ok([events.UserJoined(lobby, user)])
  }
}

pub fn apply(state: State, event: LobbyEvent) -> State {
  case event {
    LobbyCreated(_) -> Lobby(state: [])
    UserJoined(_, user) ->
      state.update_lobby(state, fn(users) { list.append(users, [user]) })
  }
}
