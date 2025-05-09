import core/models/hex/grid
import core/models/map
import engine/map/aggregate
import engine/map/commands.{type MapCommand, CompleteMap, CreateMapGrid, SetTile}
import engine/map/events.{type MapEvent}
import gleam/list
import gleam/result
import utils/uuid

pub fn validate(command: MapCommand) -> Result(MapCommand, String) {
  aggregate.validate_command(command)
}

pub fn process(command: MapCommand) -> List(MapEvent) {
  case command {
    CreateMapGrid(player_count) -> {
      let assert Ok(event) = {
        use grid <- result.map(grid.new(player_count))
        events.grid_defined(uuid.new(), grid)
      }

      event |> list.wrap()
    }

    SetTile(game, system, coordinates) -> {
      events.tile_set(game, system, coordinates) |> list.wrap()
    }

    CompleteMap(game, grid, tiles) -> {
      map.new(tiles, grid)
      |> events.map_created(game, _)
      |> list.wrap()
    }
  }
}
