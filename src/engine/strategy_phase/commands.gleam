import core/models/strategy.{type Strategy}

pub type StrategyPhaseCommand {
  StartStrategyPhase(game_id: String, player_order: List(String))
  PickStrategyCard(game_id: String, player_id: String, card: Strategy)
}

pub fn start_strategy_phase(
  game_id: String,
  player_order: List(String),
) -> StrategyPhaseCommand {
  StartStrategyPhase(game_id, player_order)
}

pub fn pick_strategy_card(
  game_id: String,
  player_id: String,
  card: Strategy,
) -> StrategyPhaseCommand {
  PickStrategyCard(game_id, player_id, card)
}
