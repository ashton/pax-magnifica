import core/models/state/tactical_action.{TacticalActionState}
import engine/tactical_action/aggregate
import engine/tactical_action/events.{
  GravityRiftEncountered, GravityRiftResolved, SystemActivated, TacticTokenSpent,
}
import helpers/hex as h
import unitest

const game_id = "game_1"

const player_id = "alice"

pub fn apply_system_activated_appends_to_history_test() {
  use <- unitest.tags(["unit", "tactical_action", "state_fold"])
  let s = TacticalActionState(activation_history: [], pending_rift_encounters: [])
  let s = aggregate.apply(s, SystemActivated(game_id, player_id, h.origin()))
  assert s.activation_history == [#(h.origin(), player_id)]
}

pub fn apply_tactic_token_spent_does_not_change_state_test() {
  use <- unitest.tags(["unit", "tactical_action", "state_fold"])
  let s = TacticalActionState(activation_history: [], pending_rift_encounters: [])
  let s = aggregate.apply(s, TacticTokenSpent(game_id, player_id))
  assert s.activation_history == []
  assert s.pending_rift_encounters == []
}

pub fn apply_gravity_rift_encountered_records_pending_test() {
  use <- unitest.tags(["unit", "tactical_action", "state_fold"])
  let s = TacticalActionState(activation_history: [], pending_rift_encounters: [])
  let s =
    aggregate.apply(
      s,
      GravityRiftEncountered(game_id, player_id, h.origin(), h.adjacent(), 1, 2),
    )
  assert s.pending_rift_encounters == [#(h.origin(), h.adjacent())]
}

pub fn apply_gravity_rift_resolved_clears_pending_test() {
  use <- unitest.tags(["unit", "tactical_action", "state_fold"])
  let s =
    TacticalActionState(
      activation_history: [],
      pending_rift_encounters: [#(h.origin(), h.adjacent())],
    )
  let s =
    aggregate.apply(
      s,
      GravityRiftResolved(game_id, player_id, h.origin(), h.adjacent(), []),
    )
  assert s.pending_rift_encounters == []
}
