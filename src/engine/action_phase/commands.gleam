import core/models/action.{type PlayerAction}
import core/models/common.{type Strategy}

pub type ActionPhaseCommand {
  StartActionPhase(
    game_id: String,
    initiative_order: List(#(String, Strategy)),
  )
  TakeAction(game_id: String, player_id: String, action: PlayerAction)
  Pass(game_id: String, player_id: String)
}
