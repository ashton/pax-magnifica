import core/models/state/strategy_phase.{type StrategyPhaseState}
import engine/strategy_phase/commands.{
  type StrategyPhaseCommand, PickStrategyCard, StartStrategyPhase,
}
import engine/strategy_phase/events.{type StrategyPhaseEvent}
import game/strategy_cards
import gleam/dict
import gleam/list
import gleam/result

pub fn process_start(
  command: StrategyPhaseCommand,
) -> List(StrategyPhaseEvent) {
  let assert StartStrategyPhase(game_id, player_order) = command
  [events.StrategyPhaseStarted(game_id, player_order)]
}

pub fn process_pick(
  state: StrategyPhaseState,
  command: StrategyPhaseCommand,
) -> List(StrategyPhaseEvent) {
  let assert PickStrategyCard(game_id, player_id, card) = command

  let picked_cards = list.map(state.current_picks, fn(p) { p.1 })
  let remaining_after_pick =
    strategy_cards.all
    |> list.filter(fn(c) { c != card && !list.contains(picked_cards, c) })

  let card_tg =
    dict.get(state.card_trade_goods, card) |> result.unwrap(0)

  let is_last_pick =
    list.length(state.current_picks) + 1 == list.length(state.player_order)

  let base_events = [events.StrategyCardPicked(game_id, player_id, card)]

  let clear_events = case card_tg > 0 {
    True -> [events.StrategyCardTradeGoodsCleared(game_id, card)]
    False -> []
  }

  let end_events = case is_last_pick {
    True ->
      list.map(remaining_after_pick, fn(c) {
        events.TradeGoodAddedToStrategyCard(game_id, c)
      })
      |> list.append([events.StrategyPhaseEnded(game_id)])
    False -> []
  }

  list.flatten([base_events, clear_events, end_events])
}
