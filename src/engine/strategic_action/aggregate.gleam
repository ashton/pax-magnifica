import core/models/state/strategic_action.{type StrategicActionState}
import core/models/strategy.{type Strategy}
import engine/strategic_action/commands.{
  type StrategicActionCommand, ResolveSecondaryAbility, SkipSecondaryAbility,
  StartStrategicAction,
}
import gleam/list
import gleam/string

pub fn start_strategic_action(
  game_id: String,
  player_id: String,
  strategy: Strategy,
  secondary_order: List(String),
) -> StrategicActionCommand {
  commands.StartStrategicAction(game_id, player_id, strategy, secondary_order)
}

pub fn resolve_secondary(
  game_id: String,
  player_id: String,
) -> StrategicActionCommand {
  commands.ResolveSecondaryAbility(game_id, player_id)
}

pub fn skip_secondary(
  game_id: String,
  player_id: String,
) -> StrategicActionCommand {
  commands.SkipSecondaryAbility(game_id, player_id)
}

pub fn validate_start(
  command: StrategicActionCommand,
) -> Result(StrategicActionCommand, String) {
  let assert StartStrategicAction(game_id, player_id, _, secondary_order) =
    command
  case string.is_empty(game_id) || string.is_empty(player_id) {
    True -> Error("Game id and player id cannot be empty")
    False ->
      case secondary_order {
        [] -> Error("Secondary order cannot be empty")
        _ -> Ok(command)
      }
  }
}

pub fn validate_secondary(
  state: StrategicActionState,
  command: StrategicActionCommand,
) -> Result(StrategicActionCommand, String) {
  let #(game_id, player_id) = case command {
    ResolveSecondaryAbility(game_id, player_id) -> #(game_id, player_id)
    SkipSecondaryAbility(game_id, player_id) -> #(game_id, player_id)
    StartStrategicAction(_, _, _, _) ->
      panic as "validate_secondary called with StartStrategicAction"
  }
  case string.is_empty(game_id) || string.is_empty(player_id) {
    True -> Error("Game id and player id cannot be empty")
    False ->
      case list.contains(state.secondary_order, player_id) {
        False -> Error("Player is not in the secondary order")
        True ->
          case list.contains(state.responded_players, player_id) {
            True -> Error("Player has already responded")
            False -> Ok(command)
          }
      }
  }
}
