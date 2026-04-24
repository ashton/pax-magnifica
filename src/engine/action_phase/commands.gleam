import core/models/action.{type PlayerAction}
import core/models/strategy_card.{type StrategyCard}

pub type ActionPhaseCommand {
  StartActionPhase(
    game_id: String,
    initiative_order: List(#(String, StrategyCard)),
  )
  TakeAction(game_id: String, player_id: String, action: PlayerAction)
  Pass(game_id: String, player_id: String)
}
