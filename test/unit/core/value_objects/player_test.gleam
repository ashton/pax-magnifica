import core/models/strategy.{Leadership}
import core/models/strategy_card.{StrategyCard}
import core/value_objects/player
import unitest

// ── PlayerId ──────────────────────────────────────────────────────────────────

pub fn new_id_valid_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let assert Ok(id) = player.new_id("alice")
  assert player.id_value(id) == "alice"
}

pub fn new_id_empty_returns_error_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let assert Error(_) = player.new_id("")
}

// ── PlayerOrder ───────────────────────────────────────────────────────────────

pub fn new_order_valid_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let assert Ok(order) = player.new_order(["alice", "bob"])
  assert player.order_values(order) == ["alice", "bob"]
}

pub fn new_order_empty_returns_error_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let assert Error(_) = player.new_order([])
}

// ── PlayerCards ───────────────────────────────────────────────────────────────

pub fn new_cards_valid_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let entry = #(
    "alice",
    StrategyCard(card: Leadership, trade_goods: 0, exhausted: False),
  )
  let assert Ok(cards) = player.new_cards([entry])
  assert player.cards_values(cards) == [entry]
}

pub fn new_cards_empty_returns_error_test() {
  use <- unitest.tags(["unit", "value_objects", "player"])
  let assert Error(_) = player.new_cards([])
}
