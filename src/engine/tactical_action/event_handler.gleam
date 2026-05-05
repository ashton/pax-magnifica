import core/models/state/tactical_action.{type TacticalActionState, TacticalActionState}
import engine/tactical_action/events.{
  type TacticalActionEvent, ShipsMoved, SystemActivated, TacticTokenSpent,
}

pub fn apply(
  state: TacticalActionState,
  event: TacticalActionEvent,
) -> TacticalActionState {
  case event {
    SystemActivated(_, player_id, hex) ->
      TacticalActionState(
        activation_history: [#(hex, player_id), ..state.activation_history],
      )

    TacticTokenSpent(_, _) -> state

    ShipsMoved(_, _, _, _, _) -> state
  }
}
