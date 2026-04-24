import core/models/common.{type Strategy}

pub type StrategyPhaseCommand {
  StartStrategyPhase(game_id: String, player_order: List(String))
  PickStrategyCard(game_id: String, player_id: String, card: Strategy)
}
