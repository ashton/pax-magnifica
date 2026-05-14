import core/models/hex/grid
import core/models/map as game_map
import core/models/state.{type State, MapSetup}
import core/models/state/map.{MapState}
import engine/map/commands.{type MapCommand, CompleteMap, CreateMapGrid, SetTile}
import engine/map/events.{type MapEvent, GridDefined, MapCreated, TileSet}
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

pub fn validate_command(command: MapCommand) -> Result(MapCommand, String) {
  case command {
    CreateMapGrid(player_count) ->
      validate_player_count(player_count)
      |> result.replace(command)

    SetTile(..) -> Ok(command)

    CompleteMap(..) -> Ok(command)
  }
}

pub fn handle(command: MapCommand) -> Result(List(MapEvent), String) {
  use _ <- result.try(validate_command(command))
  case command {
    CreateMapGrid(player_count) -> {
      let assert Ok(g) = grid.new(player_count)
      Ok([events.grid_defined(uuid.new(), g)])
    }

    SetTile(game, system, hex) ->
      Ok([events.tile_set(game, system, hex)])

    CompleteMap(game, tiles) ->
      Ok([game_map.new(tiles) |> events.map_created(game, _)])
  }
}

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    GridDefined(game, _grid) ->
      MapSetup(state: MapState(id: game, map: game_map.default()))

    TileSet(_, system, hex) ->
      state.update_map(state, fn(ms) {
        let assert Ok(updated_map) = game_map.add_tile(Ok(ms.map), hex, system)
        MapState(..ms, map: updated_map)
      })

    MapCreated(_, completed_map) ->
      state.update_map(state, fn(ms) { MapState(..ms, map: completed_map) })
  }
}
