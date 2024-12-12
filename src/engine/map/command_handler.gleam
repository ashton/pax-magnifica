import core/models/hex/grid
import engine/map/commands.{type MapCommand, CreateMapGrid}
import engine/map/events.{type MapEvent}
import gleam/result
import utils/uuid

pub fn process(command: MapCommand) -> Result(List(MapEvent), String) {
  case command {
    CreateMapGrid(ring_amount) -> {
      let event = {
        use grid <- result.map(grid.new(ring_amount))
        events.map_created(uuid.new(), grid)
      }

      [event] |> result.all()
    }
    _ -> Ok([])
  }
}
