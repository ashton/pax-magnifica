import core/models/victory_point.{type VictoryPointSource}

pub type ScoringCommand {
  AwardVictoryPoints(
    game_id: String,
    player_id: String,
    source: VictoryPointSource,
    amount: Int,
  )
}
