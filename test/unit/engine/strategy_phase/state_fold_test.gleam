import core/models/strategy.{Imperial, Leadership, Trade, Warfare}
import engine/strategy_phase/aggregate
import engine/strategy_phase/events.{
  StrategyCardPicked, StrategyCardTradeGoodsCleared, StrategyPhaseEnded,
  StrategyPhaseStarted, TradeGoodAddedToStrategyCard,
}
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import unitest

const game_id = "game_1"

pub fn apply_phase_started_sets_player_order_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let event = StrategyPhaseStarted(game_id, ["alice", "bob", "charlie"])
  let assert Some(state) = aggregate.apply(None, event)
  assert state.player_order == ["alice", "bob", "charlie"]
}

pub fn apply_phase_started_clears_picks_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let event = StrategyPhaseStarted(game_id, ["alice", "bob"])
  let assert Some(state) = aggregate.apply(None, event)
  assert state.current_picks == []
}

pub fn apply_phase_started_preserves_trade_goods_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  // simulate a prior state with accumulated TGs
  let prior = StrategyPhaseStarted(game_id, ["alice"])
  let assert Some(s1) = aggregate.apply(None, prior)
  let s1_with_tg =
    aggregate.apply(
      Some(s1),
      TradeGoodAddedToStrategyCard(game_id, Warfare),
    )
  // new round starts — trade goods should persist
  let new_round = StrategyPhaseStarted(game_id, ["alice", "bob"])
  let assert Some(s2) = aggregate.apply(s1_with_tg, new_round)
  let assert Ok(tg) = dict.get(s2.card_trade_goods, Warfare)
  assert tg == 1
}

pub fn apply_card_picked_adds_to_picks_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let base = StrategyPhaseStarted(game_id, ["alice", "bob"])
  let assert Some(state) = aggregate.apply(None, base)
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      StrategyCardPicked(game_id, "alice", Leadership),
    )
  assert list.contains(state.current_picks, #("alice", Leadership))
}

pub fn apply_trade_good_added_increments_count_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let base = StrategyPhaseStarted(game_id, ["alice"])
  let assert Some(state) = aggregate.apply(None, base)
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      TradeGoodAddedToStrategyCard(game_id, Warfare),
    )
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      TradeGoodAddedToStrategyCard(game_id, Warfare),
    )
  let assert Ok(tg) = dict.get(state.card_trade_goods, Warfare)
  assert tg == 2
}

pub fn apply_trade_goods_cleared_resets_to_zero_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let base = StrategyPhaseStarted(game_id, ["alice"])
  let assert Some(state) = aggregate.apply(None, base)
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      TradeGoodAddedToStrategyCard(game_id, Imperial),
    )
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      StrategyCardTradeGoodsCleared(game_id, Imperial),
    )
  let tg = dict.get(state.card_trade_goods, Imperial) |> result.unwrap(0)
  assert tg == 0
}

pub fn apply_phase_ended_clears_picks_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let base = StrategyPhaseStarted(game_id, ["alice"])
  let assert Some(state) = aggregate.apply(None, base)
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      StrategyCardPicked(game_id, "alice", Leadership),
    )
  let assert Some(state) =
    aggregate.apply(Some(state), StrategyPhaseEnded(game_id))
  assert state.current_picks == []
}

pub fn apply_phase_ended_preserves_trade_goods_test() {
  use <- unitest.tags(["unit", "strategy_phase", "state_fold"])
  let base = StrategyPhaseStarted(game_id, ["alice"])
  let assert Some(state) = aggregate.apply(None, base)
  let assert Some(state) =
    aggregate.apply(
      Some(state),
      TradeGoodAddedToStrategyCard(game_id, Trade),
    )
  let assert Some(state) =
    aggregate.apply(Some(state), StrategyPhaseEnded(game_id))
  let assert Ok(tg) = dict.get(state.card_trade_goods, Trade)
  assert tg == 1
}
