import core/models/hex/hex.{type Hex}

pub type TacticalActionState {
  TacticalActionState(
    activation_history: List(#(Hex, String)),
    pending_rift_encounters: List(#(Hex, Hex)),
  )
}

pub fn initial() -> TacticalActionState {
  TacticalActionState(activation_history: [], pending_rift_encounters: [])
}
