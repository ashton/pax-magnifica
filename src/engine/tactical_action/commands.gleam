import core/models/hex/hex.{type Hex}
import core/models/unit.{type Unit}

pub type TacticalActionCommand {
  ActivateSystem(game_id: String, player_id: String, hex: Hex)
  MoveUnits(game_id: String, player_id: String, moves: List(#(Hex, List(Unit))))
  ResolveGravityRift(
    game_id: String,
    player_id: String,
    from: Hex,
    to: Hex,
    units_removed: List(Unit),
  )
}

pub fn activate_system(
  game_id: String,
  player_id: String,
  hex: Hex,
) -> TacticalActionCommand {
  ActivateSystem(game_id, player_id, hex)
}

pub fn move_units(
  game_id: String,
  player_id: String,
  moves: List(#(Hex, List(Unit))),
) -> TacticalActionCommand {
  MoveUnits(game_id, player_id, moves)
}

pub fn resolve_gravity_rift(
  game_id: String,
  player_id: String,
  from: Hex,
  to: Hex,
  units_removed: List(Unit),
) -> TacticalActionCommand {
  ResolveGravityRift(game_id, player_id, from, to, units_removed)
}
