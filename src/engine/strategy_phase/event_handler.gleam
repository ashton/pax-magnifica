import core/models/state/strategy_phase.{type StrategyPhaseState, StrategyPhaseState}
import engine/strategy_phase/events.{
  type StrategyPhaseEvent, StrategyCardPicked, StrategyCardTradeGoodsCleared,
  StrategyPhaseEnded, StrategyPhaseStarted, TradeGoodAddedToStrategyCard,
}
import gleam/dict
import gleam/list
import gleam/option.{type Option, Some}
import gleam/result

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
