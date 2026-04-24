import core/models/state/action_phase.{type ActionPhaseState}
import engine/action_phase/commands.{
  type ActionPhaseCommand, Pass, StartActionPhase, TakeAction,
}
import engine/action_phase/events.{type ActionPhaseEvent}
import gleam/list

pub fn process_start(command: ActionPhaseCommand) -> List(ActionPhaseEvent) {
  let assert StartActionPhase(game_id, initiative_order) = command
  let player_order = list.map(initiative_order, fn(p) { p.0 })
  [events.ActionPhaseStarted(game_id, player_order)]
}

pub fn process_action(
  _state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> List(ActionPhaseEvent) {
  let assert TakeAction(game_id, player_id, action) = command
  [events.PlayerTookAction(game_id, player_id, action)]
}

pub fn process_pass(
  state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> List(ActionPhaseEvent) {
  let assert Pass(game_id, player_id) = command
  let active_after_pass =
    list.filter(state.player_order, fn(p) {
      p != player_id && !list.contains(state.passed_players, p)
    })
  let end_events = case active_after_pass {
    [] -> [events.ActionPhaseEnded(game_id)]
    _ -> []
  }
  list.flatten([[events.PlayerPassed(game_id, player_id)], end_events])
}
