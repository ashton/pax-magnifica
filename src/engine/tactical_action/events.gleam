import core/models/hex/hex.{type Hex}
import core/models/unit.{type Ship}

pub type TacticalActionEvent {
  SystemActivated(game_id: String, player_id: String, hex: Hex)
  TacticTokenSpent(game_id: String, player_id: String)
  ShipsMoved(
    game_id: String,
    player_id: String,
    from: Hex,
    to: Hex,
    ships: List(Ship),
  )
}
