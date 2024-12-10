import birl.{type Time, now}
import engine/commands/game.{type GameCommand, handle_game_command}
import engine/commands/player.{type PlayerCommand, handle_player_command}
import engine/models/event.{type Event, NoSource, game_event, player_event}

pub opaque type CommandAction {
  GameAction(GameCommand)
  PlayerAction(PlayerCommand)
}

pub opaque type Command {
  Command(issued_at: Time, issuer: String, action: CommandAction)
}

fn new(action: CommandAction, issuer issuer: String) -> Command {
  Command(issued_at: now(), issuer:, action:)
}

pub fn game_action(action: GameCommand, issuer issuer: String) -> Command {
  GameAction(action) |> new(issuer:)
}

pub fn player_action(action: PlayerCommand, issuer issuer: String) -> Command {
  PlayerAction(action) |> new(issuer:)
}

pub fn handle_command(command: Command) -> Event {
  case command.action {
    GameAction(game_action) ->
      handle_game_command(game_action) |> game_event(NoSource)
    PlayerAction(player_action) ->
      handle_player_command(player_action) |> player_event(NoSource)
  }
}
