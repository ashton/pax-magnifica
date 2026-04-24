import core/models/action.{TacticalAction}
import core/models/common.{Diplomacy, Leadership}
import core/models/state/action_phase.{ActionPhaseState}
import engine/action_phase/aggregate
import engine/action_phase/command_handler
import engine/action_phase/events.{
  ActionPhaseEnded, ActionPhaseStarted, PlayerPassed, PlayerTookAction,
}
import gleam/list
import gleam/option.{None, Some}

const game_id = "game_1"

fn state_for(player_order, passed, last) {
  ActionPhaseState(
    player_order: player_order,
    passed_players: passed,
    last_player: last,
  )
}

pub fn start_emits_action_phase_started_test() {
  let cmd =
    aggregate.start_action_phase(game_id, [
      #("alice", Leadership),
      #("bob", Diplomacy),
    ])
  let assert Ok(event) = command_handler.process_start(cmd) |> list.first()
  assert event == ActionPhaseStarted(game_id, ["alice", "bob"])
}

pub fn take_action_emits_player_took_action_test() {
  let state = state_for(["alice", "bob"], [], None)
  let cmd = aggregate.take_action(game_id, "alice", TacticalAction)
  let assert Ok(event) =
    command_handler.process_action(state, cmd) |> list.first()
  assert event == PlayerTookAction(game_id, "alice", TacticalAction)
}

pub fn take_action_does_not_end_phase_test() {
  let state = state_for(["alice", "bob"], [], None)
  let cmd = aggregate.take_action(game_id, "alice", TacticalAction)
  let events = command_handler.process_action(state, cmd)
  assert !list.contains(events, ActionPhaseEnded(game_id))
}

pub fn pass_emits_player_passed_test() {
  let state = state_for(["alice", "bob"], [], None)
  let cmd = aggregate.pass(game_id, "alice")
  let assert Ok(event) =
    command_handler.process_pass(state, cmd) |> list.first()
  assert event == PlayerPassed(game_id, "alice")
}

pub fn last_pass_emits_action_phase_ended_test() {
  // bob is the last remaining player, alice already passed
  let state = state_for(["alice", "bob"], ["alice"], Some("alice"))
  let cmd = aggregate.pass(game_id, "bob")
  let events = command_handler.process_pass(state, cmd)
  assert list.contains(events, ActionPhaseEnded(game_id))
}

pub fn non_last_pass_does_not_end_phase_test() {
  let state = state_for(["alice", "bob", "charlie"], [], None)
  let cmd = aggregate.pass(game_id, "alice")
  let events = command_handler.process_pass(state, cmd)
  assert !list.contains(events, ActionPhaseEnded(game_id))
}
