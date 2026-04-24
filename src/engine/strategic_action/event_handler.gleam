import core/models/state/strategic_action.{
  type StrategicActionState, StrategicActionState,
}
import engine/strategic_action/events.{
  type StrategicActionEvent, SecondaryAbilityResolved, SecondaryAbilitySkipped,
  StrategicActionEnded, StrategicActionStarted,
}
import gleam/list
import gleam/option.{type Option, Some}

pub fn apply(
  state: Option(StrategicActionState),
  event: StrategicActionEvent,
) -> Option(StrategicActionState) {
  case event {
    StrategicActionStarted(_, player_id, strategy, secondary_order) ->
      Some(StrategicActionState(
        strategy: strategy,
        initiating_player: player_id,
        secondary_order: secondary_order,
        responded_players: [],
      ))

    SecondaryAbilityResolved(_, player_id) | SecondaryAbilitySkipped(_, player_id) ->
      option.map(state, fn(s) {
        StrategicActionState(
          ..s,
          responded_players: list.append(s.responded_players, [player_id]),
        )
      })

    StrategicActionEnded(_) -> state
  }
}
