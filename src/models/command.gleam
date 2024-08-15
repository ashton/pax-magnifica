import birl.{type Time, now}
import commands/game.{type GameCommand, handle_game_action}
import commands/player.{type PlayerCommand, handle_player_action}
import models/event.{type Event}

pub opaque type CommandAction {
  GameAction(GameCommand)
  PlayerAction(PlayerCommand)
}

pub opaque type Command {
  Command(issued_at: Time, issuer: String, action: CommandAction)
}

pub fn new(action: CommandAction, issuer issuer: String) -> Command {
  Command(issued_at: now(), issuer:, action:)
}

pub fn game_action(action: GameCommand) -> CommandAction {
  GameAction(action)
}

pub fn player_action(action: PlayerCommand) -> CommandAction {
  PlayerAction(action)
}

pub fn handle_command(command: Command) -> Event {
  case command.action {
    GameAction(game_action) -> handle_game_action(game_action)
    PlayerAction(player_action) -> handle_player_action(player_action)
  }
}
