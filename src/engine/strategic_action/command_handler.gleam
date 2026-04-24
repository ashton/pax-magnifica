import core/models/state/strategic_action.{type StrategicActionState}
import engine/strategic_action/commands.{
  type StrategicActionCommand, ResolveSecondaryAbility, SkipSecondaryAbility,
  StartStrategicAction,
}
import engine/strategic_action/events.{type StrategicActionEvent}
import gleam/list

pub fn process_start(
  command: StrategicActionCommand,
) -> List(StrategicActionEvent) {
  let assert StartStrategicAction(game_id, player_id, strategy, secondary_order) =
    command
  [events.StrategicActionStarted(game_id, player_id, strategy, secondary_order)]
}

pub fn process_secondary(
  state: StrategicActionState,
  command: StrategicActionCommand,
) -> List(StrategicActionEvent) {
  let #(game_id, player_id, response_event) = case command {
    ResolveSecondaryAbility(game_id, player_id) -> #(
      game_id,
      player_id,
      events.SecondaryAbilityResolved(game_id, player_id),
    )
    SkipSecondaryAbility(game_id, player_id) -> #(
      game_id,
      player_id,
      events.SecondaryAbilitySkipped(game_id, player_id),
    )
    StartStrategicAction(_, _, _, _) ->
      panic as "process_secondary called with StartStrategicAction"
  }
  let remaining =
    list.filter(state.secondary_order, fn(p) {
      p != player_id && !list.contains(state.responded_players, p)
    })
  let end_events = case remaining {
    [] -> [events.StrategicActionEnded(game_id)]
    _ -> []
  }
  list.flatten([[response_event], end_events])
}
