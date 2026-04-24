import core/value_objects/game
import core/value_objects/player
import core/models/state/strategy_phase.{type StrategyPhaseState}
import engine/strategy_phase/commands.{
  type StrategyPhaseCommand, PickStrategyCard, StartStrategyPhase,
}
import gleam/list
import gleam/result

pub fn validate_start(
  command: StrategyPhaseCommand,
) -> Result(StrategyPhaseCommand, String) {
  let assert StartStrategyPhase(game_id, player_order) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_order(player_order))
  Ok(command)
}

pub fn validate_pick(
  state: StrategyPhaseState,
  command: StrategyPhaseCommand,
) -> Result(StrategyPhaseCommand, String) {
  let assert PickStrategyCard(game_id, player_id, card) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  let picked_cards = list.map(state.current_picks, fn(p) { p.1 })
  let picked_players = list.map(state.current_picks, fn(p) { p.0 })
  case list.contains(picked_cards, card) {
    True -> Error("Strategy card has already been picked")
    False ->
      case list.contains(picked_players, player_id) {
        True -> Error("Player has already picked a strategy card this round")
        False ->
          case next_player(state) == player_id {
            True -> Ok(command)
            False -> Error("It is not this player's turn to pick")
          }
      }
  }
}

fn next_player(state: StrategyPhaseState) -> String {
  let picked_players = list.map(state.current_picks, fn(p) { p.0 })
  state.player_order
  |> list.find(fn(p) { !list.contains(picked_players, p) })
  |> result.unwrap("")
}
