import core/models/game
import core/models/hex/grid.{type HexGrid}
import core/models/hex/hex
import core/models/map
import core/models/planetary_system.{type System}
import core/models/state.{type State}
import engine/map/events.{type MapEvent, GridDefined, MapCreated, TileSet}
import gleam/option.{None, Some}
import gleam/result

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    GridDefined(_, grid) -> set_grid_in_state(state, grid)
    TileSet(..) -> todo
    MapCreated(..) -> todo
  }
}

fn set_grid_in_state(current_state: State, grid: HexGrid) {
  use game_state <- state.map_game(current_state)
  use _current_map <- game.map_game_map(game_state)
  map.setup(None, Some(grid))
}

fn set_tile_in_state(
  current_state: State,
  system: System,
  coordinates: #(Int, Int),
) {
  use game_state <- state.map_game(current_state)
  use current_map <- game.map_game_map(game_state)
  use tile_hex <- result.map(hex.from_pair(coordinates))
  map.add_tile(current_map, map.Tile(system:, hex: tile_hex))
}
