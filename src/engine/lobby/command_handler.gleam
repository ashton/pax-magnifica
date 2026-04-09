import engine/lobby/commands.{type LobbyCommand, CreateLobby, JoinLobby}
import engine/lobby/events.{type LobbyEvent}

pub fn process(command: LobbyCommand) -> List(LobbyEvent) {
  case command {
    CreateLobby(id) -> [events.LobbyCreated(id)]
    JoinLobby(lobby, user) -> [events.UserJoined(lobby, user)]
  }
}
