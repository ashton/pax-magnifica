import core/models/hex/grid.{type HexGrid}
import core/models/hex/ring
import core/models/map.{type Map}
import core/models/planetary_system.{type System}
import game/tiles
import gleam/int
import gleam/list
import gleam/result
import gleam/string

fn get_tile_numbers(tts_string: String) -> List(Result(Int, String)) {
  tts_string
  |> string.split(on: " ")
  |> list.map(with: fn(number) {
    number
    |> int.parse()
    |> result.replace_error("Unable to parse: " <> number)
  })
}

fn get_rings_amount(
  tile_numbers: List(Result(Int, String)),
) -> Result(Int, String) {
  case tile_numbers |> list.length() {
    1 -> Ok(0)
    7 -> Ok(1)
    19 -> Ok(2)
    37 -> Ok(3)
    61 -> Ok(4)
    _ -> Error("Invalid amount of tiles")
  }
}

fn build_map(systems: List(System), coordinates: List(#(Int, Int))) -> Map {
  list.map2(systems, coordinates, with: fn(system, coordinates) {
    map.Tile(system:, coordinates:)
  })
  |> map.new()
}

fn validate_map_data(
  systems: List(System),
  coordinates: List(#(Int, Int)),
) -> Result(Map, String) {
  case list.length(systems) == list.length(coordinates) {
    True -> build_map(systems, coordinates) |> Ok
    False -> Error("Something went wrong parsing TTS string.")
  }
}

pub fn map_from_tts_string(tts_string: String) -> Result(Map, String) {
  let tile_numbers =
    "18 "
    |> string.append(tts_string)
    |> string.trim()
    |> get_tile_numbers()

  let coordinates =
    tile_numbers
    |> get_rings_amount()
    |> result.then(grid.new)
    |> result.map(grid.rings)
    |> result.map(list.map(_, ring.coordinates))
    |> result.map(list.flatten)

  let systems =
    tile_numbers
    |> list.map(fn(current_result) {
      current_result
      |> result.then(apply: tiles.get_system_from_tile_number)
    })
    |> result.all()

  case systems, coordinates {
    Ok(systems), Ok(coordinates) -> validate_map_data(systems, coordinates)
    Error(err), Ok(_) -> Error(err)
    Ok(_), Error(err) -> Error(err)
    Error(system_error), Error(coord_error) ->
      Error(
        "Multiple errors happened: "
        <> string.join([system_error, coord_error], with: ", "),
      )
  }
}
