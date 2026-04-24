import core/models/action.{TacticalAction}
import engine/action_phase/event_handler
import engine/action_phase/events.{
  ActionPhaseEnded, ActionPhaseStarted, PlayerPassed, PlayerTookAction,
}
import gleam/list
import gleam/option.{None, Some}

const game_id = "game_1"

pub fn apply_phase_started_sets_player_order_test() {
  let event = ActionPhaseStarted(game_id, ["alice", "bob", "charlie"])
  let assert Some(state) = event_handler.apply(None, event)
  assert state.player_order == ["alice", "bob", "charlie"]
  assert state.passed_players == []
  assert state.last_player == None
}

pub fn apply_player_took_action_updates_last_player_test() {
  let assert Some(state) =
    event_handler.apply(None, ActionPhaseStarted(game_id, ["alice", "bob"]))
  let assert Some(state) =
    event_handler.apply(
      Some(state),
      PlayerTookAction(game_id, "alice", TacticalAction),
    )
  assert state.last_player == Some("alice")
}

pub fn apply_player_passed_adds_to_passed_list_test() {
  let assert Some(state) =
    event_handler.apply(None, ActionPhaseStarted(game_id, ["alice", "bob"]))
  let assert Some(state) =
    event_handler.apply(Some(state), PlayerPassed(game_id, "alice"))
  assert list.contains(state.passed_players, "alice")
  assert state.last_player == Some("alice")
}

pub fn apply_player_passed_updates_last_player_test() {
  let assert Some(state) =
    event_handler.apply(None, ActionPhaseStarted(game_id, ["alice", "bob"]))
  let assert Some(state) =
    event_handler.apply(Some(state), PlayerPassed(game_id, "alice"))
  assert state.last_player == Some("alice")
}

pub fn apply_action_phase_ended_does_not_change_state_test() {
  let assert Some(state) =
    event_handler.apply(None, ActionPhaseStarted(game_id, ["alice"]))
  let assert Some(ended_state) =
    event_handler.apply(Some(state), ActionPhaseEnded(game_id))
  assert ended_state == state
}

pub fn apply_on_none_returns_none_for_non_starting_events_test() {
  assert None == event_handler.apply(None, PlayerPassed(game_id, "alice"))
}
