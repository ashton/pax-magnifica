import core/models/state/strategic_action.{StrategicActionState}
import core/models/strategy.{Leadership}
import engine/strategic_action/command_handler
import engine/strategic_action/commands.{
  resolve_secondary, skip_secondary, start_strategic_action,
}
import engine/strategic_action/events.{
  SecondaryAbilityResolved, SecondaryAbilitySkipped, StrategicActionEnded,
  StrategicActionStarted,
}
import gleam/list
import unitest

const game_id = "game_1"

fn started_state(secondary_order, responded) {
  StrategicActionState(
    strategy: Leadership,
    initiating_player: "alice",
    secondary_order: secondary_order,
    responded_players: responded,
  )
}

pub fn start_emits_strategic_action_started_test() {
  use <- unitest.tags(["unit", "strategic_action", "command_handler"])
  let cmd = start_strategic_action(game_id, "alice", Leadership, ["bob"])
  let assert Ok(event) = command_handler.process_start(cmd) |> list.first()
  assert event == StrategicActionStarted(game_id, "alice", Leadership, ["bob"])
}

pub fn resolve_emits_secondary_ability_resolved_test() {
  use <- unitest.tags(["unit", "strategic_action", "command_handler"])
  let state = started_state(["bob", "charlie"], [])
  let cmd = resolve_secondary(game_id, "bob")
  let assert Ok(event) =
    command_handler.process_secondary(state, cmd) |> list.first()
  assert event == SecondaryAbilityResolved(game_id, "bob")
}

pub fn skip_emits_secondary_ability_skipped_test() {
  use <- unitest.tags(["unit", "strategic_action", "command_handler"])
  let state = started_state(["bob", "charlie"], [])
  let cmd = skip_secondary(game_id, "charlie")
  let assert Ok(event) =
    command_handler.process_secondary(state, cmd) |> list.first()
  assert event == SecondaryAbilitySkipped(game_id, "charlie")
}

pub fn last_response_emits_strategic_action_ended_test() {
  use <- unitest.tags(["unit", "strategic_action", "command_handler"])
  // bob is the last to respond
  let state = started_state(["bob", "charlie"], ["charlie"])
  let cmd = resolve_secondary(game_id, "bob")
  let events = command_handler.process_secondary(state, cmd)
  assert list.contains(events, StrategicActionEnded(game_id))
}

pub fn non_last_response_does_not_end_action_test() {
  use <- unitest.tags(["unit", "strategic_action", "command_handler"])
  let state = started_state(["bob", "charlie"], [])
  let cmd = resolve_secondary(game_id, "bob")
  let events = command_handler.process_secondary(state, cmd)
  assert !list.contains(events, StrategicActionEnded(game_id))
}
