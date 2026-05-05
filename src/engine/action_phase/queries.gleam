import core/models/state/action_phase.{type ActionPhaseState}
import gleam/list

pub fn has_passed(state: ActionPhaseState, player_id: String) -> Bool {
  list.contains(state.passed_players, player_id)
}
