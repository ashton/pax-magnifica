import core/models/action.{type PlayerAction}
import core/models/common.{type Strategy}
import core/models/state/action_phase.{type ActionPhaseState}
import engine/action_phase/commands.{
  type ActionPhaseCommand, Pass, StartActionPhase, TakeAction,
}
import game/strategy_cards
import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/string

pub fn start_action_phase(
  game_id: String,
  initiative_order: List(#(String, Strategy)),
) -> ActionPhaseCommand {
  let sorted =
    list.sort(initiative_order, fn(a, b) {
      let a_initiative = card_initiative(a.1)
      let b_initiative = card_initiative(b.1)
      int.compare(a_initiative, b_initiative)
    })
  commands.StartActionPhase(game_id, sorted)
}

pub fn take_action(
  game_id: String,
  player_id: String,
  action: PlayerAction,
) -> ActionPhaseCommand {
  commands.TakeAction(game_id, player_id, action)
}

pub fn pass(game_id: String, player_id: String) -> ActionPhaseCommand {
  commands.Pass(game_id, player_id)
}

pub fn validate_start(
  command: ActionPhaseCommand,
) -> Result(ActionPhaseCommand, String) {
  let assert StartActionPhase(game_id, initiative_order) = command
  case string.is_empty(game_id) {
    True -> Error("Game id cannot be empty")
    False ->
      case initiative_order {
        [] -> Error("Initiative order cannot be empty")
        _ -> Ok(command)
      }
  }
}

pub fn validate_action(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> Result(ActionPhaseCommand, String) {
  let assert TakeAction(game_id, player_id, _) = command
  case string.is_empty(game_id) || string.is_empty(player_id) {
    True -> Error("Game id and player id cannot be empty")
    False ->
      case list.contains(state.passed_players, player_id) {
        True -> Error("Player has already passed and cannot take actions")
        False ->
          case next_player(state) == player_id {
            True -> Ok(command)
            False -> Error("It is not this player's turn")
          }
      }
  }
}

pub fn validate_pass(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> Result(ActionPhaseCommand, String) {
  let assert Pass(game_id, player_id) = command
  case string.is_empty(game_id) || string.is_empty(player_id) {
    True -> Error("Game id and player id cannot be empty")
    False ->
      case list.contains(state.passed_players, player_id) {
        True -> Error("Player has already passed")
        False ->
          case next_player(state) == player_id {
            True -> Ok(command)
            False -> Error("It is not this player's turn")
          }
      }
  }
}

fn next_player(state: ActionPhaseState) -> String {
  let active =
    list.filter(state.player_order, fn(p) {
      !list.contains(state.passed_players, p)
    })
  case state.last_player {
    option.None ->
      list.first(active) |> result.unwrap("")
    option.Some(last) -> {
      let after_last =
        state.player_order
        |> list.drop_while(fn(p) { p != last })
        |> list.drop(1)
        |> list.filter(fn(p) { !list.contains(state.passed_players, p) })
      case after_last {
        [] -> list.first(active) |> result.unwrap("")
        [next, ..] -> next
      }
    }
  }
}

fn card_initiative(card: Strategy) -> Int {
  strategy_cards.all
  |> list.find(fn(sc) { sc.card == card })
  |> result.map(fn(sc) { sc.initiative })
  |> result.unwrap(0)
}
