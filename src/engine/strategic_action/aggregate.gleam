import core/value_objects/game
import core/value_objects/player
import core/models/state/strategic_action.{type StrategicActionState}
import engine/strategic_action/commands.{
  type StrategicActionCommand, ResolveSecondaryAbility, SkipSecondaryAbility,
  StartStrategicAction,
}
import gleam/list
import gleam/result

pub fn validate_start(
  command: StrategicActionCommand,
) -> Result(StrategicActionCommand, String) {
  let assert StartStrategicAction(game_id, player_id, _, secondary_order) =
    command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(player.new_order(secondary_order))
  Ok(command)
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
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  case list.contains(state.secondary_order, player_id) {
    False -> Error("Player is not in the secondary order")
    True ->
      case list.contains(state.responded_players, player_id) {
        True -> Error("Player has already responded")
        False -> Ok(command)
      }
  }
}
