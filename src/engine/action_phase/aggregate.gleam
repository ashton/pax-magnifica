import core/models/action.{type PlayerAction, StrategicAction}
import core/models/strategy
import core/models/state/action_phase.{type ActionPhaseState, ActionPhaseState}
import core/models/strategy_card.{StrategyCard}
import core/value_objects/game
import core/value_objects/player
import engine/action_phase/commands.{
  type ActionPhaseCommand, Pass, StartActionPhase, TakeAction,
}
import engine/action_phase/events.{
  type ActionPhaseEvent, ActionPhaseEnded, ActionPhaseStarted, PlayerPassed,
  PlayerTookAction, StrategyCardExhausted,
}
import engine/action_phase/queries
import gleam/list
import gleam/option.{type Option, Some}
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
  use _ <- result.try(case queries.has_passed(state, player_id) {
    True -> Error("Player has already passed and cannot take actions")
    False -> Ok(Nil)
  })
  use _ <- result.try(case next_player(state) == player_id {
    True -> Ok(Nil)
    False -> Error("It is not this player's turn")
  })
  case action {
    StrategicAction(strategy: strat) ->
      validate_strategic_action(state, game_id, player_id, strat)
    _ -> Ok(produce_action_events(game_id, player_id, action))
  }
}

pub fn handle_pass(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> Result(List(ActionPhaseEvent), String) {
  let assert Pass(game_id, player_id) = command
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  use _ <- result.try(case queries.has_passed(state, player_id) {
    True -> Error("Player has already passed")
    False -> Ok(Nil)
  })
  use _ <- result.try(case next_player(state) == player_id {
    True -> Ok(Nil)
    False -> Error("It is not this player's turn")
  })
  Ok(produce_pass_events(state, game_id, player_id))
}

fn validate_strategic_action(
  state: ActionPhaseState,
  game_id: String,
  player_id: String,
  strat: strategy.Strategy,
) -> Result(List(ActionPhaseEvent), String) {
  use #(_, sc) <- result.try(
    list.find(state.player_cards, fn(pc) { pc.0 == player_id })
    |> result.replace_error("Player does not hold a strategy card"),
  )
  use _ <- result.try(case sc.card == strat {
    True -> Ok(Nil)
    False -> Error("Player does not hold that strategy card")
  })
  use _ <- result.try(case sc.exhausted {
    False -> Ok(Nil)
    True -> Error("Strategy card is already exhausted")
  })
  Ok(produce_action_events(game_id, player_id, StrategicAction(strat)))
}

fn produce_action_events(
  game_id: String,
  player_id: String,
  action: PlayerAction,
) -> List(ActionPhaseEvent) {
  let extra = case action {
    StrategicAction(strategy: strat) -> [events.StrategyCardExhausted(game_id, strat)]
    _ -> []
  }
  [events.PlayerTookAction(game_id, player_id, action), ..extra]
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
  [events.PlayerPassed(game_id, player_id), ..end_events]
}

pub fn apply(
  state: Option(ActionPhaseState),
  event: ActionPhaseEvent,
) -> Option(ActionPhaseState) {
  case event {
    ActionPhaseStarted(_, player_cards) -> {
      let player_order = list.map(player_cards, fn(pc) { pc.0 })
      Some(ActionPhaseState(
        player_order: player_order,
        passed_players: [],
        last_player: option.None,
        player_cards: player_cards,
      ))
    }

    PlayerTookAction(_, player_id, _) ->
      option.map(state, fn(s) {
        ActionPhaseState(..s, last_player: Some(player_id))
      })

    StrategyCardExhausted(_, strat) ->
      option.map(state, fn(s) {
        let updated_cards =
          list.map(s.player_cards, fn(pc) {
            let #(pid, sc) = pc
            case sc.card == strat {
              True -> #(pid, StrategyCard(..sc, exhausted: True))
              False -> pc
            }
          })
        ActionPhaseState(..s, player_cards: updated_cards)
      })

    PlayerPassed(_, player_id) ->
      option.map(state, fn(s) {
        ActionPhaseState(
          ..s,
          passed_players: list.append(s.passed_players, [player_id]),
          last_player: Some(player_id),
        )
      })

    ActionPhaseEnded(_) -> state
  }
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
