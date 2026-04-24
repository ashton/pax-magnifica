import core/models/common.{
  Construction, Diplomacy, Imperial, Leadership, Politics, Technology, Trade,
  Warfare,
}
import core/models/strategy_card.{StrategyCard}

pub const all = [
  StrategyCard(Leadership, 1, 0),
  StrategyCard(Diplomacy, 2, 0),
  StrategyCard(Politics, 3, 0),
  StrategyCard(Construction, 4, 0),
  StrategyCard(Trade, 5, 0),
  StrategyCard(Warfare, 6, 0),
  StrategyCard(Technology, 7, 0),
  StrategyCard(Imperial, 8, 0),
]
