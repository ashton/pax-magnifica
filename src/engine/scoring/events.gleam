import core/models/victory_point.{type VictoryPointSource}

pub type ScoringEvent {
  PlayerScoredVictoryPoints(
    game_id: String,
    player_id: String,
    source: VictoryPointSource,
    amount: Int,
  )
}
