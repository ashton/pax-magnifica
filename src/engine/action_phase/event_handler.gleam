import core/models/state/action_phase.{type ActionPhaseState, ActionPhaseState}
import engine/action_phase/events.{
  type ActionPhaseEvent, ActionPhaseEnded, ActionPhaseStarted, PlayerPassed,
  PlayerTookAction,
}
import gleam/list
import gleam/option.{type Option, Some}

pub fn apply(
  state: Option(ActionPhaseState),
  event: ActionPhaseEvent,
) -> Option(ActionPhaseState) {
  case event {
    ActionPhaseStarted(_, player_order) ->
      Some(ActionPhaseState(
        player_order: player_order,
        passed_players: [],
        last_player: option.None,
      ))

    PlayerTookAction(_, player_id, _) ->
      option.map(state, fn(s) {
        ActionPhaseState(..s, last_player: Some(player_id))
      })

    PlayerPassed(_, player_id) ->
      option.map(state, fn(s) {
        ActionPhaseState(
          ..s,
          passed_players: list.append(s.passed_players, [player_id]),
          last_player: Some(player_id),
        )
      })

    ActionPhaseEnded(_) -> state
  }
}
