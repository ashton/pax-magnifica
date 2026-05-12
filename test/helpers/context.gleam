import core/models/hex/hex.{type Hex}
import engine/tactical_action/movement/context.{
  type MovementContext, MovementContext,
}
import gleam/list

pub const enemy_id = "bob"

pub fn empty() -> MovementContext {
  MovementContext(enemy_fleets: [], anomalies: [], player_technologies: [])
}

pub fn with_enemy_at(h: Hex) -> MovementContext {
  MovementContext(enemy_fleets: [#(h, enemy_id)], anomalies: [], player_technologies: [])
}

pub fn with_enemies_at(hexes: List(Hex)) -> MovementContext {
  MovementContext(
    enemy_fleets: list.map(hexes, fn(h) { #(h, enemy_id) }),
    anomalies: [],
    player_technologies: [],
  )
}
