import core/models/state/strategic_action.{
  type StrategicActionState, StrategicActionState,
}
import core/value_objects/game
import core/value_objects/player
import engine/strategic_action/commands.{
  type StrategicActionCommand, ResolveSecondaryAbility, SkipSecondaryAbility,
  StartStrategicAction,
}
import engine/strategic_action/events.{
  type StrategicActionEvent, SecondaryAbilityResolved, SecondaryAbilitySkipped,
  StrategicActionEnded, StrategicActionStarted,
}
import gleam/list
import gleam/option.{type Option, Some}
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

pub fn apply(
  state: Option(StrategicActionState),
  event: StrategicActionEvent,
) -> Option(StrategicActionState) {
  case event {
    StrategicActionStarted(_, player_id, strategy, secondary_order) ->
      Some(
        StrategicActionState(
          strategy: strategy,
          initiating_player: player_id,
          secondary_order: secondary_order,
          responded_players: [],
        ),
      )

    SecondaryAbilityResolved(_, player_id)
    | SecondaryAbilitySkipped(_, player_id) ->
      option.map(state, fn(s) {
        StrategicActionState(
          ..s,
          responded_players: list.append(s.responded_players, [player_id]),
        )
      })

    StrategicActionEnded(_) -> state
  }
}
