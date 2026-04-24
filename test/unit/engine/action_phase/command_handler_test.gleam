import core/models/action.{StrategicAction, TacticalAction}
import core/models/strategy.{Diplomacy, Leadership}
import core/models/strategy_card.{StrategyCard}
import core/models/state/action_phase.{ActionPhaseState}
import engine/action_phase/aggregate
import engine/action_phase/command_handler
import engine/action_phase/events.{
  ActionPhaseEnded, ActionPhaseStarted, PlayerPassed, PlayerTookAction,
  StrategyCardExhausted,
}
import gleam/list
import gleam/option.{None, Some}

const game_id = "game_1"

fn sc(strategy) {
  StrategyCard(card: strategy, trade_goods: 0, exhausted: False)
}

fn state_for(player_order, passed, last) {
  ActionPhaseState(
    player_order: player_order,
    passed_players: passed,
    last_player: last,
    player_cards: [],
  )
}

pub fn start_emits_action_phase_started_test() {
  let alice_card = sc(Leadership)
  let bob_card = sc(Diplomacy)
  let cmd =
    aggregate.start_action_phase(game_id, [
      #("alice", alice_card),
      #("bob", bob_card),
    ])
  let assert Ok(event) = command_handler.process_start(cmd) |> list.first()
  assert event == ActionPhaseStarted(game_id, [#("alice", alice_card), #("bob", bob_card)])
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

pub fn strategic_action_emits_strategy_card_exhausted_test() {
  let state = state_for(["alice", "bob"], [], None)
  let cmd = aggregate.take_action(game_id, "alice", StrategicAction(Leadership))
  let events = command_handler.process_action(state, cmd)
  assert list.contains(events, StrategyCardExhausted(game_id, Leadership))
}

pub fn tactical_action_does_not_exhaust_card_test() {
  let state = state_for(["alice", "bob"], [], None)
  let cmd = aggregate.take_action(game_id, "alice", TacticalAction)
  let events = command_handler.process_action(state, cmd)
  assert !list.contains(events, StrategyCardExhausted(game_id, Leadership))
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
