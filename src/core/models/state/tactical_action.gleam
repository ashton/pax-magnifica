import core/models/hex/hex.{type Hex}

pub type TacticalActionState {
  TacticalActionState(activation_history: List(#(Hex, String)))
}

pub fn initial() -> TacticalActionState {
  TacticalActionState(activation_history: [])
}
