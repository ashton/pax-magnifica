import core/models/strategy.{Leadership, Trade, Warfare}
import core/models/state/strategy_phase.{StrategyPhaseState}
import engine/strategy_phase/aggregate
import engine/strategy_phase/commands.{PickStrategyCard, StartStrategyPhase}
import gleam/dict
import unitest

const game_id = "game_1"

fn state_with_picks(picks) {
  StrategyPhaseState(
    card_trade_goods: dict.new(),
    current_picks: picks,
    player_order: ["alice", "bob", "charlie"],
  )
}

// ── StartStrategyPhase ────────────────────────────────────────────────────────

pub fn start_strategy_phase_returns_command_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let cmd = commands.start_strategy_phase(game_id, ["alice", "bob"])
  let assert StartStrategyPhase("game_1", ["alice", "bob"]) = cmd
}

pub fn validate_start_strategy_phase_valid_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let cmd = commands.start_strategy_phase(game_id, ["alice", "bob"])
  let assert Ok(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_strategy_phase_empty_player_order_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let cmd = StartStrategyPhase(game_id, [])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_strategy_phase_empty_game_id_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let cmd = StartStrategyPhase("", ["alice"])
  let assert Error(_) = aggregate.validate_start(cmd)
}

// ── PickStrategyCard ──────────────────────────────────────────────────────────

pub fn pick_strategy_card_returns_command_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let assert PickStrategyCard("game_1", "alice", Leadership) = cmd
}

pub fn validate_pick_valid_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([])
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let assert Ok(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_card_already_taken_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([#("alice", Leadership)])
  let cmd = commands.pick_strategy_card(game_id, "bob", Leadership)
  let assert Error(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_out_of_turn_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([])
  // alice is first — bob cannot pick before alice
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let assert Error(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_second_player_after_first_picks_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([#("alice", Leadership)])
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let assert Ok(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_empty_game_id_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([])
  let cmd = PickStrategyCard("", "alice", Leadership)
  let assert Error(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_empty_player_id_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([])
  let cmd = PickStrategyCard(game_id, "", Leadership)
  let assert Error(_) = aggregate.validate_pick(state, cmd)
}

pub fn validate_pick_player_already_picked_test() {
  use <- unitest.tags(["unit", "strategy_phase", "aggregate"])
  let state = state_with_picks([#("alice", Leadership)])
  // alice already picked — cannot pick again
  let cmd = commands.pick_strategy_card(game_id, "alice", Warfare)
  let assert Error(_) = aggregate.validate_pick(state, cmd)
}
