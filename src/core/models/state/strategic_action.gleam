import core/models/strategy.{type Strategy}

pub type StrategicActionState {
  StrategicActionState(
    strategy: Strategy,
    initiating_player: String,
    secondary_order: List(String),
    responded_players: List(String),
  )
}
