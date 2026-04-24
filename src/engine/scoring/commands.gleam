import core/models/victory_point.{type VictoryPointSource}

pub type ScoringCommand {
  AwardVictoryPoints(
    game_id: String,
    player_id: String,
    source: VictoryPointSource,
    amount: Int,
  )
}

pub fn award_victory_points(
  game_id: String,
  player_id: String,
  source: VictoryPointSource,
  amount: Int,
) -> ScoringCommand {
  AwardVictoryPoints(game_id, player_id, source, amount)
}
