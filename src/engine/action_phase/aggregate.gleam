import core/models/action.{type PlayerAction, StrategicAction}
import core/models/strategy
import core/models/state/action_phase.{type ActionPhaseState}
import core/value_objects/game
import core/value_objects/player
import engine/action_phase/commands.{
  type ActionPhaseCommand, Pass, StartActionPhase, TakeAction,
}
import engine/action_phase/events.{type ActionPhaseEvent}
import gleam/list
import gleam/option
import gleam/result

pub fn handle_start(
  command: ActionPhaseCommand,
) -> Result(List(ActionPhaseEvent), String) {
  let assert StartActionPhase(game_id, initiative_order) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_cards(initiative_order))
  Ok([events.ActionPhaseStarted(game_id, initiative_order)])
}

pub fn handle_action(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> Result(List(ActionPhaseEvent), String) {
  let assert TakeAction(game_id, player_id, action) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  case list.contains(state.passed_players, player_id) {
    True -> Error("Player has already passed and cannot take actions")
    False ->
      case next_player(state) == player_id {
        False -> Error("It is not this player's turn")
        True ->
          case action {
            StrategicAction(strategy: strat) ->
              validate_strategic_action(state, command, player_id, strat)
            _ -> Ok(produce_action_events(game_id, player_id, action))
          }
      }
  }
}

pub fn handle_pass(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> Result(List(ActionPhaseEvent), String) {
  let assert Pass(game_id, player_id) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  case list.contains(state.passed_players, player_id) {
    True -> Error("Player has already passed")
    False ->
      case next_player(state) == player_id {
        True -> Ok(produce_pass_events(state, game_id, player_id))
        False -> Error("It is not this player's turn")
      }
  }
}

fn validate_strategic_action(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
  player_id: String,
  strat: strategy.Strategy,
) -> Result(List(ActionPhaseEvent), String) {
  let assert TakeAction(game_id, _, StrategicAction(_)) = command
  case list.find(state.player_cards, fn(pc) { pc.0 == player_id }) {
    Error(_) -> Error("Player does not hold a strategy card")
    Ok(#(_, sc)) ->
      case sc.card == strat {
        False -> Error("Player does not hold that strategy card")
        True ->
          case sc.exhausted {
            True -> Error("Strategy card is already exhausted")
            False ->
              Ok(produce_action_events(game_id, player_id, StrategicAction(strat)))
          }
      }
  }
}

fn produce_action_events(
  game_id: String,
  player_id: String,
  action: PlayerAction,
) -> List(ActionPhaseEvent) {
  let base = [events.PlayerTookAction(game_id, player_id, action)]
  let extra = case action {
    StrategicAction(strategy: strat) -> [events.StrategyCardExhausted(game_id, strat)]
    _ -> []
  }
  list.flatten([base, extra])
}

fn produce_pass_events(
  state: ActionPhaseState,
  game_id: String,
  player_id: String,
) -> List(ActionPhaseEvent) {
  let active_after_pass =
    list.filter(state.player_order, fn(p) {
      p != player_id && !list.contains(state.passed_players, p)
    })
  let end_events = case active_after_pass {
    [] -> [events.ActionPhaseEnded(game_id)]
    _ -> []
  }
  list.flatten([[events.PlayerPassed(game_id, player_id)], end_events])
}

fn next_player(state: ActionPhaseState) -> String {
  let active =
    list.filter(state.player_order, fn(p) {
      !list.contains(state.passed_players, p)
    })
  case state.last_player {
    option.None -> list.first(active) |> result.unwrap("")
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
