import core/models/strategy_card.{type StrategyCard}
import gleam/option.{type Option}

pub type ActionPhaseState {
  ActionPhaseState(
    player_order: List(String),
    passed_players: List(String),
    last_player: Option(String),
    player_cards: List(#(String, StrategyCard)),
  )
}
