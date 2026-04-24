import core/models/action.{ComponentAction, StrategicAction, TacticalAction}
import core/models/strategy.{Imperial, Leadership, Trade}
import core/models/strategy_card.{StrategyCard}
import core/models/state/action_phase.{ActionPhaseState}
import engine/action_phase/aggregate
import engine/action_phase/commands.{Pass, StartActionPhase, TakeAction}
import gleam/option.{None, Some}

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

pub fn start_action_phase_sorts_by_initiative_test() {
  // Imperial=8, Leadership=1, Trade=5 — should sort to [alice, charlie, bob]
  let cmd =
    aggregate.start_action_phase(game_id, [
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

pub fn validate_start_empty_initiative_order_test() {
  let cmd = StartActionPhase(game_id, [])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_game_id_test() {
  let cmd = StartActionPhase("", [#("alice", sc(Leadership, False))])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_valid_test() {
  let cmd =
    aggregate.start_action_phase(game_id, [#("alice", sc(Leadership, False))])
  let assert Ok(_) = aggregate.validate_start(cmd)
}

// ── TakeAction ────────────────────────────────────────────────────────────────

pub fn validate_take_action_first_player_test() {
  let state = state_for(["alice", "bob", "charlie"], [])
  let cmd = aggregate.take_action(game_id, "alice", TacticalAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_out_of_turn_test() {
  let state = state_for(["alice", "bob", "charlie"], [])
  let cmd = aggregate.take_action(game_id, "bob", TacticalAction)
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_after_previous_acted_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob", "charlie"],
      passed_players: [],
      last_player: Some("alice"),
      player_cards: [],
    )
  let cmd = aggregate.take_action(game_id, "bob", TacticalAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_wraps_to_start_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: Some("bob"),
      player_cards: [],
    )
  let cmd = aggregate.take_action(game_id, "alice", ComponentAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_passed_player_cannot_act_test() {
  let state = state_for(["alice", "bob"], ["alice"])
  let state = ActionPhaseState(..state, last_player: Some("bob"))
  let cmd = aggregate.take_action(game_id, "alice", TacticalAction)
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_skips_passed_players_test() {
  // alice passed, so after charlie it wraps to bob (skips alice)
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob", "charlie"],
      passed_players: ["alice"],
      last_player: Some("charlie"),
      player_cards: [],
    )
  let cmd = aggregate.take_action(game_id, "bob", TacticalAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_empty_ids_test() {
  let state = state_for(["alice"], [])
  let cmd = TakeAction("", "alice", TacticalAction)
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

// ── StrategicAction validation ────────────────────────────────────────────────

pub fn validate_strategic_action_valid_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Leadership, False))],
    )
  let cmd = aggregate.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_strategic_action_no_card_test() {
  let state = state_for(["alice", "bob"], [])
  let cmd = aggregate.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_strategic_action_wrong_card_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Trade, False))],
    )
  let cmd = aggregate.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_strategic_action_exhausted_card_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: None,
      player_cards: [#("alice", sc(Leadership, True))],
    )
  let cmd = aggregate.take_action(game_id, "alice", StrategicAction(Leadership))
  let assert Error(_) = aggregate.validate_action(state, cmd)
}

// ── Pass ──────────────────────────────────────────────────────────────────────

pub fn validate_pass_valid_test() {
  let state = state_for(["alice", "bob"], [])
  let cmd = aggregate.pass(game_id, "alice")
  let assert Ok(_) = aggregate.validate_pass(state, cmd)
}

pub fn validate_pass_out_of_turn_test() {
  let state = state_for(["alice", "bob"], [])
  let cmd = aggregate.pass(game_id, "bob")
  let assert Error(_) = aggregate.validate_pass(state, cmd)
}

pub fn validate_pass_already_passed_test() {
  let state = state_for(["alice", "bob"], ["alice"])
  let state = ActionPhaseState(..state, last_player: Some("bob"))
  let cmd = aggregate.pass(game_id, "alice")
  let assert Error(_) = aggregate.validate_pass(state, cmd)
}

pub fn validate_pass_empty_ids_test() {
  let state = state_for(["alice"], [])
  let cmd = Pass("", "alice")
  let assert Error(_) = aggregate.validate_pass(state, cmd)
}
