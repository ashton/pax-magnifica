import core/models/action.{ComponentAction, StrategicAction, TacticalAction}
import core/models/common.{Diplomacy, Imperial, Leadership, Trade}
import core/models/state/action_phase.{ActionPhaseState}
import engine/action_phase/aggregate
import engine/action_phase/commands.{Pass, StartActionPhase, TakeAction}
import gleam/option.{None, Some}

const game_id = "game_1"

fn state_for(player_order, passed) {
  ActionPhaseState(
    player_order: player_order,
    passed_players: passed,
    last_player: None,
  )
}

// ── StartActionPhase ──────────────────────────────────────────────────────────

pub fn start_action_phase_sorts_by_initiative_test() {
  // Imperial=8, Leadership=1, Trade=5 — should sort to [alice, charlie, bob]
  let cmd =
    aggregate.start_action_phase(game_id, [
      #("alice", Leadership),
      #("bob", Imperial),
      #("charlie", Trade),
    ])
  let assert StartActionPhase(_, order) = cmd
  assert order == [#("alice", Leadership), #("charlie", Trade), #("bob", Imperial)]
}

pub fn validate_start_empty_initiative_order_test() {
  let cmd = StartActionPhase(game_id, [])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_empty_game_id_test() {
  let cmd = StartActionPhase("", [#("alice", Leadership)])
  let assert Error(_) = aggregate.validate_start(cmd)
}

pub fn validate_start_valid_test() {
  let cmd =
    aggregate.start_action_phase(game_id, [#("alice", Leadership)])
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
    )
  let cmd = aggregate.take_action(game_id, "bob", StrategicAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_wraps_to_start_test() {
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob"],
      passed_players: [],
      last_player: Some("bob"),
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
  // alice passed, so after bob it's charlie's turn (wrapping skips alice)
  let state =
    ActionPhaseState(
      player_order: ["alice", "bob", "charlie"],
      passed_players: ["alice"],
      last_player: Some("charlie"),
    )
  let cmd = aggregate.take_action(game_id, "bob", TacticalAction)
  let assert Ok(_) = aggregate.validate_action(state, cmd)
}

pub fn validate_take_action_empty_ids_test() {
  let state = state_for(["alice"], [])
  let cmd = TakeAction("", "alice", TacticalAction)
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
