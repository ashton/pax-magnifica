import core/models/common.{type Strategy}

pub type StrategyCard {
  StrategyCard(card: Strategy, initiative: Int, trade_goods: Int)
}
