import engine/tactical_action/aggregate
import engine/tactical_action/commands
import engine/tactical_action/events.{SystemActivated, TacticTokenSpent}
import gleam/list
import helpers/hex as h
import helpers/state
import unitest

const game_id = "game_1"

const player_id = "alice"

pub fn activate_system_emits_system_activated_and_token_spent_test() {
  use <- unitest.tags([
    "unit",
    "tactical_action",
    "system_activation",
    "aggregate",
  ])
  let s = state.with_history([])
  let cmd = commands.activate_system(game_id, player_id, h.origin())
  let assert Ok(events) = aggregate.handle_activate(s, cmd)
  assert list.contains(events, SystemActivated(game_id, player_id, h.origin()))
  assert list.contains(events, TacticTokenSpent(game_id, player_id))
}

pub fn activate_system_empty_game_id_returns_error_test() {
  use <- unitest.tags([
    "unit",
    "tactical_action",
    "system_activation",
    "aggregate",
  ])
  let s = state.with_history([])
  let cmd = commands.activate_system("", player_id, h.origin())
  let assert Error(_) = aggregate.handle_activate(s, cmd)
}

pub fn activate_system_empty_player_id_returns_error_test() {
  use <- unitest.tags([
    "unit",
    "tactical_action",
    "system_activation",
    "aggregate",
  ])
  let s = state.with_history([])
  let cmd = commands.activate_system(game_id, "", h.origin())
  let assert Error(_) = aggregate.handle_activate(s, cmd)
}

pub fn activate_already_activated_system_returns_error_test() {
  use <- unitest.tags([
    "unit",
    "tactical_action",
    "system_activation",
    "aggregate",
  ])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.activate_system(game_id, player_id, h.origin())
  let assert Error(_) = aggregate.handle_activate(s, cmd)
}

pub fn activate_different_system_when_one_already_activated_succeeds_test() {
  use <- unitest.tags([
    "unit",
    "tactical_action",
    "system_activation",
    "aggregate",
  ])
  let s = state.with_history([#(h.origin(), player_id)])
  let cmd = commands.activate_system(game_id, player_id, h.adjacent())
  let assert Ok(_) = aggregate.handle_activate(s, cmd)
}
