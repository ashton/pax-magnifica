import core/models/strategy.{type Strategy}

pub type StrategyCard {
  StrategyCard(card: Strategy, trade_goods: Int, exhausted: Bool)
}
