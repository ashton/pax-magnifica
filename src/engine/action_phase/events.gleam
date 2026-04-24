import core/models/action.{type PlayerAction}

pub type ActionPhaseEvent {
  ActionPhaseStarted(game_id: String, player_order: List(String))
  PlayerTookAction(game_id: String, player_id: String, action: PlayerAction)
  PlayerPassed(game_id: String, player_id: String)
  ActionPhaseEnded(game_id: String)
}
