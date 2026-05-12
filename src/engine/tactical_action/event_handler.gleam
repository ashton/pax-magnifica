import core/models/state/tactical_action.{type TacticalActionState, TacticalActionState}
import core/models/hex/hex.{type Hex}
import engine/tactical_action/events.{
  type TacticalActionEvent, CombatInitiated, GravityRiftEncountered,
  GravityRiftResolved, SystemActivated, TacticTokenSpent, UnitsMoved,
}
pub fn apply(
  state: TacticalActionState,
  event: TacticalActionEvent,
) -> TacticalActionState {
  case event {
    SystemActivated(_, player_id, hex) ->
      TacticalActionState(
        ..state,
        activation_history: [#(hex, player_id), ..state.activation_history],
      )

    TacticTokenSpent(_, _) -> state

    UnitsMoved(_, _, _, _, _) -> state

    CombatInitiated(_, _, _, _) -> state

    GravityRiftEncountered(_, _, from, to, _, _) ->
      TacticalActionState(
        ..state,
        pending_rift_encounters: [#(from, to), ..state.pending_rift_encounters],
      )

    GravityRiftResolved(_, _, from, to, _) ->
      TacticalActionState(
        ..state,
        pending_rift_encounters: drop_first(state.pending_rift_encounters, #(from, to)),
      )
  }
}

fn drop_first(lst: List(#(Hex, Hex)), target: #(Hex, Hex)) -> List(#(Hex, Hex)) {
  case lst {
    [] -> []
    [head, ..tail] if head == target -> tail
    [head, ..tail] -> [head, ..drop_first(tail, target)]
  }
}
