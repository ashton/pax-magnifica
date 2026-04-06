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
    //GridDefined(_, grid) -> set_grid_in_state(state, grid)
    _ -> todo
    TileSet(..) -> todo
    MapCreated(..) -> todo
  }
}
