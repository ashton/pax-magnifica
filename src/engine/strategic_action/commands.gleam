import core/models/strategy.{type Strategy}

pub type StrategicActionCommand {
  StartStrategicAction(
    game_id: String,
    player_id: String,
    strategy: Strategy,
    secondary_order: List(String),
  )
  ResolveSecondaryAbility(game_id: String, player_id: String)
  SkipSecondaryAbility(game_id: String, player_id: String)
}
