import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{Nebula, Supernova}
import engine/tactical_action/movement/context.{
  type MovementContext, MovementContext,
}

pub fn nebula_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Nebula)])
}

pub fn supernova_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Supernova)])
}
