import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{GravityRift, Nebula, Supernova}
import engine/tactical_action/movement/context.{
  type MovementContext, MovementContext,
}
import gleam/list

pub fn nebula_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Nebula)])
}

pub fn supernova_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [#(h, Supernova)])
}

pub fn gravity_rift_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [#(h, GravityRift)])
}

pub fn gravity_rifts_at(hexes: List(Hex)) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: list.map(hexes, fn(h) { #(h, GravityRift) }),
  )
}
