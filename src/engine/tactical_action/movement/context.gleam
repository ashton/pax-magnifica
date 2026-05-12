import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{type Anomaly, type System, AnomalySystem}
import core/models/technology.{type Technology}
import gleam/dict.{type Dict}
import gleam/list

pub type MovementContext {
  MovementContext(
    enemy_fleets: List(#(Hex, String)),
    anomalies: List(#(Hex, Anomaly)),
    player_technologies: List(Technology),
  )
}

// Builds a MovementContext from read-side map state. Called by the actor/
// application service before dispatching a MoveUnits command.
pub fn from_map_state(
  player_id: String,
  fleet_positions: Dict(Hex, String),
  map_tiles: Dict(Hex, System),
  player_technologies: List(Technology),
) -> MovementContext {
  let enemy_fleets =
    fleet_positions
    |> dict.to_list()
    |> list.filter(fn(f) { f.1 != player_id })
  let anomalies =
    map_tiles
    |> dict.to_list()
    |> list.filter_map(fn(entry) {
      let #(h, system) = entry
      case system.trait {
        AnomalySystem(kind) -> Ok(#(h, kind))
        _ -> Error(Nil)
      }
    })
  MovementContext(enemy_fleets:, anomalies:, player_technologies:)
}
