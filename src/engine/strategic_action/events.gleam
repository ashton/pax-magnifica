import core/models/strategy.{type Strategy}

pub type StrategicActionEvent {
  StrategicActionStarted(
    game_id: String,
    player_id: String,
    strategy: Strategy,
    secondary_order: List(String),
  )
  SecondaryAbilityResolved(game_id: String, player_id: String)
  SecondaryAbilitySkipped(game_id: String, player_id: String)
  StrategicActionEnded(game_id: String)
}
