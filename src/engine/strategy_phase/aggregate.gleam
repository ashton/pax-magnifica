import core/value_objects/game
import core/value_objects/player
import core/models/state/strategy_phase.{
  type StrategyPhaseState, StrategyPhaseState,
}
import engine/strategy_phase/commands.{
  type StrategyPhaseCommand, PickStrategyCard, StartStrategyPhase,
}
import engine/strategy_phase/events.{
  type StrategyPhaseEvent, StrategyCardPicked, StrategyCardTradeGoodsCleared,
  StrategyPhaseEnded, StrategyPhaseStarted, TradeGoodAddedToStrategyCard,
}
import gleam/dict
import gleam/list
import gleam/option.{type Option, Some}
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
  use _ <- result.try(case list.contains(picked_cards, card) {
    True -> Error("Strategy card has already been picked")
    False -> Ok(Nil)
  })
  use _ <- result.try(case list.contains(picked_players, player_id) {
    True -> Error("Player has already picked a strategy card this round")
    False -> Ok(Nil)
  })
  use _ <- result.try(case next_player(state) == player_id {
    True -> Ok(Nil)
    False -> Error("It is not this player's turn to pick")
  })
  Ok(command)
}

pub fn apply(
  state: Option(StrategyPhaseState),
  event: StrategyPhaseEvent,
) -> Option(StrategyPhaseState) {
  case event {
    StrategyPhaseStarted(_, player_order) -> {
      let card_trade_goods = case state {
        option.None -> dict.new()
        Some(s) -> s.card_trade_goods
      }
      Some(StrategyPhaseState(
        card_trade_goods: card_trade_goods,
        current_picks: [],
        player_order: player_order,
      ))
    }

    StrategyCardPicked(_, player_id, card) ->
      option.map(state, fn(s) {
        StrategyPhaseState(
          ..s,
          current_picks: list.append(s.current_picks, [#(player_id, card)]),
        )
      })

    TradeGoodAddedToStrategyCard(_, card) ->
      option.map(state, fn(s) {
        let current = dict.get(s.card_trade_goods, card) |> result.unwrap(0)
        StrategyPhaseState(
          ..s,
          card_trade_goods: dict.insert(s.card_trade_goods, card, current + 1),
        )
      })

    StrategyCardTradeGoodsCleared(_, card) ->
      option.map(state, fn(s) {
        StrategyPhaseState(
          ..s,
          card_trade_goods: dict.insert(s.card_trade_goods, card, 0),
        )
      })

    StrategyPhaseEnded(_) ->
      option.map(state, fn(s) {
        StrategyPhaseState(..s, current_picks: [])
      })
  }
}

fn next_player(state: StrategyPhaseState) -> String {
  let picked_players = list.map(state.current_picks, fn(p) { p.0 })
  state.player_order
  |> list.find(fn(p) { !list.contains(picked_players, p) })
  |> result.unwrap("")
}
