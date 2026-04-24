import core/models/action.{type PlayerAction}
import core/models/strategy.{type Strategy}
import core/models/strategy_card.{type StrategyCard}

pub type ActionPhaseEvent {
  ActionPhaseStarted(
    game_id: String,
    player_cards: List(#(String, StrategyCard)),
  )
  PlayerTookAction(game_id: String, player_id: String, action: PlayerAction)
  StrategyCardExhausted(game_id: String, strategy: Strategy)
  PlayerPassed(game_id: String, player_id: String)
  ActionPhaseEnded(game_id: String)
}
