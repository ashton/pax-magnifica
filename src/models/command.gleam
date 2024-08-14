import birl.{type Time}
import commands/game.{type GameCommand, handle_game_action}
import commands/session.{type SessionCommand, handle_session_action}
import models/event.{type Event}

pub type CommandAction {
  GameAction(GameCommand)
  SessionAction(SessionCommand)
}

pub type Command {
  Command(issued_at: Time, issuer: String, action: CommandAction)
}

pub fn handle_command(command: Command) -> Event {
  case command.action {
    GameAction(game_action) -> handle_game_action(game_action)
    SessionAction(session_action) -> handle_session_action(session_action)
  }
}
