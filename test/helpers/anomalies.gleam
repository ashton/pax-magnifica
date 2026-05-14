import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{
  AsteroidField, GravityRift, Nebula, Supernova,
}
import engine/tactical_action/movement/context.{
  type MovementContext, MovementContext,
}
import game/technologies
import gleam/list

pub fn nebula_at(h: Hex) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: [#(h, Nebula)],
    player_technologies: [],
  )
}

pub fn supernova_at(h: Hex) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: [#(h, Supernova)],
    player_technologies: [],
  )
}

pub fn gravity_rift_at(h: Hex) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: [#(h, GravityRift)],
    player_technologies: [],
  )
}

pub fn gravity_rifts_at(hexes: List(Hex)) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: list.map(hexes, fn(h) { #(h, GravityRift) }),
    player_technologies: [],
  )
}

pub fn asteroid_field_at(h: Hex) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: [#(h, AsteroidField)],
    player_technologies: [],
  )
}

pub fn asteroid_field_with_deflectors_at(h: Hex) -> MovementContext {
  MovementContext(
    enemy_fleets: [],
    anomalies: [#(h, AsteroidField)],
    player_technologies: [technologies.antimass_deflectors],
  )
}
