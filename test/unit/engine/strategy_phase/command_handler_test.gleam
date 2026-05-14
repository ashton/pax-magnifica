import core/models/state/strategy_phase.{StrategyPhaseState}
import core/models/strategy.{Imperial, Leadership, Trade, Warfare}
import engine/strategy_phase/command_handler
import engine/strategy_phase/commands
import engine/strategy_phase/events.{
  StrategyCardPicked, StrategyCardTradeGoodsCleared, StrategyPhaseEnded,
  StrategyPhaseStarted, TradeGoodAddedToStrategyCard,
}
import gleam/dict
import gleam/list
import unitest

const game_id = "game_1"

fn empty_state(player_order) {
  StrategyPhaseState(
    card_trade_goods: dict.new(),
    current_picks: [],
    player_order: player_order,
  )
}

fn state_with_picks(picks) {
  StrategyPhaseState(
    card_trade_goods: dict.new(),
    current_picks: picks,
    player_order: ["alice", "bob", "charlie"],
  )
}

// ── StartStrategyPhase ────────────────────────────────────────────────────────

pub fn start_strategy_phase_emits_started_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let cmd = commands.start_strategy_phase(game_id, ["alice", "bob"])
  let assert Ok(event) = command_handler.process_start(cmd) |> list.first()
  assert event == StrategyPhaseStarted(game_id, ["alice", "bob"])
}

// ── PickStrategyCard ──────────────────────────────────────────────────────────

pub fn pick_emits_card_picked_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = empty_state(["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let events = command_handler.process_pick(state, cmd)
  assert list.contains(events, StrategyCardPicked(game_id, "alice", Leadership))
}

pub fn pick_card_with_no_trade_goods_does_not_clear_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = empty_state(["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let events = command_handler.process_pick(state, cmd)
  assert !list.contains(
    events,
    StrategyCardTradeGoodsCleared(game_id, Leadership),
  )
}

pub fn pick_card_with_trade_goods_emits_cleared_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state =
    StrategyPhaseState(
      card_trade_goods: dict.from_list([#(Leadership, 2)]),
      current_picks: [],
      player_order: ["alice", "bob"],
    )
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let events = command_handler.process_pick(state, cmd)
  assert list.contains(
    events,
    StrategyCardTradeGoodsCleared(game_id, Leadership),
  )
}

pub fn last_pick_emits_trade_good_for_remaining_cards_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  // only alice and bob; alice picks first, bob's pick is last
  let state = state_with_picks([#("alice", Leadership)])
  let state = StrategyPhaseState(..state, player_order: ["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let events = command_handler.process_pick(state, cmd)
  // all 8 cards minus Leadership (alice) minus Trade (bob) = 6 remaining
  let tg_events =
    list.filter(events, fn(e) {
      case e {
        TradeGoodAddedToStrategyCard(..) -> True
        _ -> False
      }
    })
  assert list.length(tg_events) == 6
}

pub fn last_pick_emits_phase_ended_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = state_with_picks([#("alice", Leadership)])
  let state = StrategyPhaseState(..state, player_order: ["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let events = command_handler.process_pick(state, cmd)
  assert list.contains(events, StrategyPhaseEnded(game_id))
}

pub fn non_last_pick_does_not_emit_phase_ended_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = empty_state(["alice", "bob", "charlie"])
  let cmd = commands.pick_strategy_card(game_id, "alice", Leadership)
  let events = command_handler.process_pick(state, cmd)
  assert !list.contains(events, StrategyPhaseEnded(game_id))
}

pub fn last_pick_does_not_add_tg_to_picked_cards_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = state_with_picks([#("alice", Leadership)])
  let state = StrategyPhaseState(..state, player_order: ["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let events = command_handler.process_pick(state, cmd)
  assert !list.contains(
    events,
    TradeGoodAddedToStrategyCard(game_id, Leadership),
  )
  assert !list.contains(events, TradeGoodAddedToStrategyCard(game_id, Trade))
}

pub fn last_pick_includes_warfare_in_remaining_test() {
  use <- unitest.tags(["unit", "strategy_phase", "command_handler"])
  let state = state_with_picks([#("alice", Leadership)])
  let state = StrategyPhaseState(..state, player_order: ["alice", "bob"])
  let cmd = commands.pick_strategy_card(game_id, "bob", Trade)
  let events = command_handler.process_pick(state, cmd)
  assert list.contains(events, TradeGoodAddedToStrategyCard(game_id, Warfare))
  assert list.contains(events, TradeGoodAddedToStrategyCard(game_id, Imperial))
}
