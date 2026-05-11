import core/models/strategy.{Leadership}
import engine/strategic_action/event_handler
import engine/strategic_action/events.{
  SecondaryAbilityResolved, SecondaryAbilitySkipped, StrategicActionEnded,
  StrategicActionStarted,
}
import gleam/list
import gleam/option.{None, Some}
import unitest

const game_id = "game_1"

pub fn apply_started_sets_state_test() {
  use <- unitest.tags(["unit", "strategic_action", "event_handler"])
  let event =
    StrategicActionStarted(game_id, "alice", Leadership, ["bob", "charlie"])
  let assert Some(state) = event_handler.apply(None, event)
  assert state.strategy == Leadership
  assert state.initiating_player == "alice"
  assert state.secondary_order == ["bob", "charlie"]
  assert state.responded_players == []
}

pub fn apply_secondary_resolved_adds_to_responded_test() {
  use <- unitest.tags(["unit", "strategic_action", "event_handler"])
  let assert Some(state) =
    event_handler.apply(
      None,
      StrategicActionStarted(game_id, "alice", Leadership, ["bob"]),
    )
  let assert Some(state) =
    event_handler.apply(Some(state), SecondaryAbilityResolved(game_id, "bob"))
  assert list.contains(state.responded_players, "bob")
}

pub fn apply_secondary_skipped_adds_to_responded_test() {
  use <- unitest.tags(["unit", "strategic_action", "event_handler"])
  let assert Some(state) =
    event_handler.apply(
      None,
      StrategicActionStarted(game_id, "alice", Leadership, ["bob"]),
    )
  let assert Some(state) =
    event_handler.apply(Some(state), SecondaryAbilitySkipped(game_id, "bob"))
  assert list.contains(state.responded_players, "bob")
}

pub fn apply_ended_does_not_change_state_test() {
  use <- unitest.tags(["unit", "strategic_action", "event_handler"])
  let assert Some(state) =
    event_handler.apply(
      None,
      StrategicActionStarted(game_id, "alice", Leadership, ["bob"]),
    )
  let assert Some(ended_state) =
    event_handler.apply(Some(state), StrategicActionEnded(game_id))
  assert ended_state == state
}

pub fn apply_on_none_returns_none_for_non_starting_events_test() {
  use <- unitest.tags(["unit", "strategic_action", "event_handler"])
  assert None
    == event_handler.apply(None, SecondaryAbilityResolved(game_id, "bob"))
}
