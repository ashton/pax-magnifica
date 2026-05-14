import core/models/state/action_phase.{type ActionPhaseState, ActionPhaseState}
import core/models/strategy.{Leadership, Trade}
import core/models/strategy_card.{StrategyCard}
import engine/action_phase/queries
import gleam/option.{None}
import unitest

fn state_with_passed(passed: List(String)) -> ActionPhaseState {
  ActionPhaseState(
    player_order: ["alice", "bob", "charlie"],
    passed_players: passed,
    last_player: None,
    player_cards: [
      #(
        "alice",
        StrategyCard(card: Leadership, trade_goods: 0, exhausted: False),
      ),
      #("bob", StrategyCard(card: Trade, trade_goods: 0, exhausted: False)),
    ],
  )
}

pub fn has_passed_returns_true_for_passed_player_test() {
  use <- unitest.tags(["unit", "action_phase", "queries"])
  let state = state_with_passed(["alice"])
  assert queries.has_passed(state, "alice")
}

pub fn has_passed_returns_false_for_active_player_test() {
  use <- unitest.tags(["unit", "action_phase", "queries"])
  let state = state_with_passed(["alice"])
  assert !queries.has_passed(state, "bob")
}

pub fn has_passed_returns_false_when_no_one_has_passed_test() {
  use <- unitest.tags(["unit", "action_phase", "queries"])
  let state = state_with_passed([])
  assert !queries.has_passed(state, "alice")
}
