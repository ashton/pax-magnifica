import core/models/hex/hex.{type Hex}
import core/models/state/tactical_action.{
  type TacticalActionState, TacticalActionState,
}

pub fn with_history(entries: List(#(Hex, String))) -> TacticalActionState {
  TacticalActionState(activation_history: entries, pending_rift_encounters: [])
}

pub fn with_pending_encounter(from: Hex, to: Hex) -> TacticalActionState {
  TacticalActionState(activation_history: [], pending_rift_encounters: [
    #(from, to),
  ])
}
