import core/models/common.{type Strategy}
import core/models/state/strategy_phase.{type StrategyPhaseState}
import engine/strategy_phase/commands.{
  type StrategyPhaseCommand, PickStrategyCard, StartStrategyPhase,
}
import gleam/list
import gleam/result
import gleam/string

pub fn start_strategy_phase(
  game_id: String,
  player_order: List(String),
) -> StrategyPhaseCommand {
  commands.StartStrategyPhase(game_id, player_order)
}

pub fn pick_strategy_card(
  game_id: String,
  player_id: String,
  card: Strategy,
) -> StrategyPhaseCommand {
  commands.PickStrategyCard(game_id, player_id, card)
}

pub fn validate_start(
  command: StrategyPhaseCommand,
) -> Result(StrategyPhaseCommand, String) {
  let assert StartStrategyPhase(game_id, player_order) = command
  case string.is_empty(game_id) {
    True -> Error("Game id cannot be empty")
    False ->
      case player_order {
        [] -> Error("Player order cannot be empty")
        _ -> Ok(command)
      }
  }
}

pub fn validate_pick(
  state: StrategyPhaseState,
  command: StrategyPhaseCommand,
) -> Result(StrategyPhaseCommand, String) {
  let assert PickStrategyCard(game_id, player_id, card) = command
  case string.is_empty(game_id) || string.is_empty(player_id) {
    True -> Error("Game id and player id cannot be empty")
    False -> {
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
  }
}

fn next_player(state: StrategyPhaseState) -> String {
  let picked_players = list.map(state.current_picks, fn(p) { p.0 })
  state.player_order
  |> list.find(fn(p) { !list.contains(picked_players, p) })
  |> result.unwrap("")
}
