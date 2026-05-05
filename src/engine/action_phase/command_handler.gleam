import core/models/action.{StrategicAction}
import core/models/state/action_phase.{type ActionPhaseState}
import engine/action_phase/commands.{
  type ActionPhaseCommand, Pass, StartActionPhase, TakeAction,
}
import engine/action_phase/events.{type ActionPhaseEvent}
import gleam/list

pub fn process_start(command: ActionPhaseCommand) -> List(ActionPhaseEvent) {
  let assert StartActionPhase(game_id, initiative_order) = command
  [events.ActionPhaseStarted(game_id, initiative_order)]
}

pub fn process_action(
  _state: ActionPhaseState,
  command: ActionPhaseCommand,
) -> List(ActionPhaseEvent) {
  let assert TakeAction(game_id, player_id, action) = command
  let extra = case action {
    StrategicAction(strategy: strat) -> [
      events.StrategyCardExhausted(game_id, strat),
    ]
    _ -> []
  }
  [events.PlayerTookAction(game_id, player_id, action), ..extra]
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
  [events.PlayerPassed(game_id, player_id), ..end_events]
}
