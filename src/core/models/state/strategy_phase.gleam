import core/models/strategy.{type Strategy}
import gleam/dict.{type Dict}

pub type StrategyPhaseState {
  StrategyPhaseState(
    card_trade_goods: Dict(Strategy, Int),
    current_picks: List(#(String, Strategy)),
    player_order: List(String),
  )
}
