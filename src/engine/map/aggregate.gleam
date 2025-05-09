import core/models/hex/grid.{type HexGrid}
import engine/map/commands.{type MapCommand, CompleteMap, CreateMapGrid, SetTile}
import gleam/int
import gleam/result

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

fn grid_for_player_count(player_count: Int) -> Result(HexGrid, String) {
  case player_count {
    3 -> Ok(2)
    4 | 5 | 6 -> Ok(3)
    _ ->
      Error(
        "Invalid player count: "
        <> player_count |> int.to_string()
        <> ". A game should have 3 players minimum, and 6 players maximum.",
      )
  }
  |> result.then(grid.new)
}

pub fn validate_command(command: MapCommand) -> Result(MapCommand, String) {
  case command {
    CreateMapGrid(player_count) -> {
      player_count
      |> validate_player_count()
      |> result.then(grid_for_player_count)
      |> result.replace(command)
    }

    SetTile(..) -> Ok(command)

    CompleteMap(..) -> Ok(command)
  }
}
