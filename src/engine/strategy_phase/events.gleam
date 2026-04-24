import core/models/strategy.{type Strategy}

pub type StrategyPhaseEvent {
  StrategyPhaseStarted(game_id: String, player_order: List(String))
  StrategyCardPicked(game_id: String, player_id: String, card: Strategy)
  StrategyCardTradeGoodsCleared(game_id: String, card: Strategy)
  TradeGoodAddedToStrategyCard(game_id: String, card: Strategy)
  StrategyPhaseEnded(game_id: String)
}
