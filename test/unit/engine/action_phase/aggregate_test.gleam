import core/models/action.{ComponentAction, StrategicAction, TacticalAction}
import core/models/strategy.{Imperial, Leadership, Trade}
import core/models/strategy_card.{StrategyCard}
import core/models/state/action_phase.{ActionPhaseState}
import engine/action_phase/aggregate
import engine/action_phase/commands.{Pass, StartActionPhase, TakeAction}
import engine/action_phase/events.{
  ActionPhaseEnded, ActionPhaseStarted, PlayerPassed, PlayerTookAction,
  StrategyCardExhausted,
}
import gleam/list
import gleam/option.{None, Some}
import unitest

const game_id = "game_1"

fn sc(strategy, exhausted) {
  StrategyCard(card: strategy, trade_goods: 0, exhausted: exhausted)
}

fn state_for(player_order, passed) {
  ActionPhaseState(
    player_order: player_order,
    passed_players: passed,
    last_player: None,
    player_cards: [],
  )
}

// ── StartActionPhase ──────────────────────────────────────────────────────────

pub fn handle_start_emits_action_phase_started_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let alice_card = sc(Leadership, False)
  let bob_card = sc(Trade, False)
  let cmd =
    commands.start_action_phase(game_id, [
      #("alice", alice_card),
      #("bob", bob_card),
    ])
  let assert Ok(events) = aggregate.handle_start(cmd)
  let assert Ok(event) = list.first(events)
  assert event
    == ActionPhaseStarted(game_id, [#("alice", alice_card), #("bob", bob_card)])
}

pub fn handle_start_empty_game_id_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let cmd = StartActionPhase("", [#("alice", sc(Leadership, False))])
  let assert Error(_) = aggregate.handle_start(cmd)
}

pub fn handle_start_empty_initiative_order_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let cmd = StartActionPhase(game_id, [])
  let assert Error(_) = aggregate.handle_start(cmd)
}

pub fn start_action_phase_sorts_by_initiative_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  // Imperial=8, Leadership=1, Trade=5 — should sort to [alice, charlie, bob]
  let cmd =
    commands.start_action_phase(game_id, [
      #("alice", sc(Leadership, False)),
      #("bob", sc(Imperial, False)),
      #("charlie", sc(Trade, False)),
    ])
  let assert StartActionPhase(_, order) = cmd
  assert order == [
    #("alice", sc(Leadership, False)),
    #("charlie", sc(Trade, False)),
    #("bob", sc(Imperial, False)),
  ]
}

// ── TakeAction ────────────────────────────────────────────────────────────────

pub fn handle_action_emits_player_took_action_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.take_action(game_id, "alice", TacticalAction)
  let assert Ok(events) = aggregate.handle_action(state, cmd)
  assert list.contains(events, PlayerTookAction(game_id, "alice", TacticalAction))
}

pub fn handle_action_does_not_end_phase_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.take_action(game_id, "alice", TacticalAction)
  let assert Ok(events) = aggregate.handle_action(state, cmd)
  assert !list.contains(events, ActionPhaseEnded(game_id))
}

pub fn handle_action_out_of_turn_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob", "charlie"], [])
  let cmd = commands.take_action(game_id, "bob", TacticalAction)
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_action_after_previous_acted_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob", "charlie"],
      passed_players: [],
      last_player: Some("alice"),
      player_cards: [],
    )
  let cmd = commands.take_action(game_id, "bob", TacticalAction)
  let assert Ok(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_action_wraps_to_start_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: Some("bob"),
      player_cards: [],
    )
  let cmd = commands.take_action(game_id, "alice", ComponentAction)
  let assert Ok(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_action_passed_player_cannot_act_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], ["alice"])
  let state = ActionPhaseState(..state, last_player: Some("bob"))
  let cmd = commands.take_action(game_id, "alice", TacticalAction)
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_action_skips_passed_players_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob", "charlie"],
      passed_players: ["alice"],
      last_player: Some("charlie"),
      player_cards: [],
    )
  let cmd = commands.take_action(game_id, "bob", TacticalAction)
  let assert Ok(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_action_empty_ids_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice"], [])
  let cmd = TakeAction("", "alice", TacticalAction)
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

// ── StrategicAction ───────────────────────────────────────────────────────────

pub fn handle_strategic_action_emits_card_exhausted_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Leadership, False))],
    )
  let cmd = commands.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Ok(events) = aggregate.handle_action(state, cmd)
  assert list.contains(events, StrategyCardExhausted(game_id, Leadership))
}

pub fn handle_tactical_action_does_not_exhaust_card_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.take_action(game_id, "alice", TacticalAction)
  let assert Ok(events) = aggregate.handle_action(state, cmd)
  assert !list.contains(events, StrategyCardExhausted(game_id, Leadership))
}

pub fn handle_strategic_action_valid_card_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Leadership, False))],
    )
  let cmd = commands.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Ok(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_strategic_action_no_card_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_strategic_action_wrong_card_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Trade, False))],
    )
  let cmd = commands.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

pub fn handle_strategic_action_exhausted_card_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Leadership, True))],
    )
  let cmd = commands.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.handle_action(state, cmd)
}

// ── Pass ──────────────────────────────────────────────────────────────────────

pub fn handle_pass_emits_player_passed_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.pass(game_id, "alice")
  let assert Ok(events) = aggregate.handle_pass(state, cmd)
  assert list.contains(events, PlayerPassed(game_id, "alice"))
}

pub fn handle_last_pass_emits_action_phase_ended_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], ["alice"])
  let state = ActionPhaseState(..state, last_player: Some("alice"))
  let cmd = commands.pass(game_id, "bob")
  let assert Ok(events) = aggregate.handle_pass(state, cmd)
  assert list.contains(events, ActionPhaseEnded(game_id))
}

pub fn handle_non_last_pass_does_not_end_phase_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob", "charlie"], [])
  let cmd = commands.pass(game_id, "alice")
  let assert Ok(events) = aggregate.handle_pass(state, cmd)
  assert !list.contains(events, ActionPhaseEnded(game_id))
}

pub fn handle_pass_out_of_turn_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], [])
  let cmd = commands.pass(game_id, "bob")
  let assert Error(_) = aggregate.handle_pass(state, cmd)
}

pub fn handle_pass_already_passed_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice", "bob"], ["alice"])
  let state = ActionPhaseState(..state, last_player: Some("bob"))
  let cmd = commands.pass(game_id, "alice")
  let assert Error(_) = aggregate.handle_pass(state, cmd)
}

pub fn handle_pass_empty_ids_returns_error_test() {
  use <- unitest.tags(["unit", "action_phase", "aggregate"])
  let state = state_for(["alice"], [])
  let cmd = Pass("", "alice")
  let assert Error(_) = aggregate.handle_pass(state, cmd)
}
