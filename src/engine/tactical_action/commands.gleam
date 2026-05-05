import core/models/hex/hex.{type Hex}
import core/models/unit.{type Ship}

pub type TacticalActionCommand {
  ActivateSystem(game_id: String, player_id: String, hex: Hex)
  MoveShips(game_id: String, player_id: String, from: Hex, ships: List(Ship))
}

pub fn activate_system(
  game_id: String,
  player_id: String,
  hex: Hex,
) -> TacticalActionCommand {
  ActivateSystem(game_id, player_id, hex)
}

pub fn move_ships(
  game_id: String,
  player_id: String,
  from: Hex,
  ships: List(Ship),
) -> TacticalActionCommand {
  MoveShips(game_id, player_id, from, ships)
}
