import core/models/hex/hex.{type Hex}
import core/models/unit

pub type TacticalActionEvent {
  SystemActivated(game_id: String, player_id: String, hex: Hex)
  TacticTokenSpent(game_id: String, player_id: String)
  UnitsMoved(
    game_id: String,
    player_id: String,
    from: Hex,
    to: Hex,
    units: List(unit.Unit),
  )
  CombatInitiated(
    game_id: String,
    hex: Hex,
    attacker_id: String,
    defender_id: String,
  )
  GravityRiftEncountered(
    game_id: String,
    player_id: String,
    from: Hex,
    to: Hex,
    rift_transits: Int,
    dice_count: Int,
  )
  GravityRiftResolved(
    game_id: String,
    player_id: String,
    from: Hex,
    to: Hex,
    units_removed: List(unit.Unit),
  )
}
