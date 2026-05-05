import core/models/hex/grid
import core/models/map
import engine/map/commands.{type MapCommand, CompleteMap, CreateMapGrid, SetTile}
import engine/map/events.{type MapEvent}
import gleam/int
import gleam/result
import utils/uuid

fn validate_player_count(player_count: Int) -> Result(Int, String) {
  case player_count >= 3, player_count <= 6 {
    True, True -> Ok(player_count)
    _, _ ->
      Error(
        "Invalid player count: "
        <> player_count |> int.to_string()
        <> ". A game should have 3 players minimum, and 6 players maximum.",
      )
  }
}

fn validate(command: MapCommand) -> Result(MapCommand, String) {
  case command {
    CreateMapGrid(player_count) ->
      validate_player_count(player_count)
      |> result.replace(command)

    SetTile(..) -> Ok(command)

    CompleteMap(..) -> Ok(command)
  }
}

pub fn handle(command: MapCommand) -> Result(List(MapEvent), String) {
  use _ <- result.try(validate(command))
  case command {
    CreateMapGrid(player_count) -> {
      let assert Ok(g) = grid.new(player_count)
      Ok([events.grid_defined(uuid.new(), g)])
    }

    SetTile(game, system, hex) ->
      Ok([events.tile_set(game, system, hex)])

    CompleteMap(game, tiles) ->
      Ok([map.new(tiles) |> events.map_created(game, _)])
  }
}
