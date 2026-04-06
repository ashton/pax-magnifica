import core/models/hex/grid.{type HexGrid}
import core/models/hex/hex.{type Hex}
import core/models/hex/ring
import core/models/map.{type Map, type Tile, Tile}
import core/models/planetary_system.{type System}
import game/tiles
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils/result_utils

fn get_tile_numbers(tts_string: String) -> Result(List(Int), String) {
  tts_string
  |> string.split(on: " ")
  |> list.map(with: fn(number) {
    number
    |> int.parse()
    |> result.replace_error("Unable to parse: " <> number)
  })
  |> result.all()
}

fn get_rings_amount(
  tile_numbers: Result(List(Int), String),
) -> Result(Int, String) {
  case result.map(tile_numbers, list.length) {
    Ok(1) -> Ok(0)
    Ok(7) -> Ok(1)
    Ok(19) -> Ok(2)
    Ok(37) -> Ok(3)
    Ok(61) -> Ok(4)
    Error(_) -> Error("Invalid tile numbers")
    Ok(_) -> Error("Invalid amount of tiles")
  }
}

fn build_tiles(systems: List(System), grid: HexGrid) -> List(Tile) {
  grid
  |> grid.rings()
  |> list.map(ring.items)
  |> list.flatten()
  |> list.map2(systems, _, Tile)
}

pub fn map_from_tts_string(tts_string: String) -> Result(List(Tile), String) {
  let tile_numbers =
    "18 "
    |> string.append(tts_string)
    |> string.trim()
    |> get_tile_numbers()

  let grid =
    tile_numbers
    |> get_rings_amount()
    |> result.then(grid.new)
    |> echo

  let systems =
    tile_numbers
    |> result.then(fn(numbers) {
      numbers
      |> list.map(tiles.get_system_from_tile_number)
      |> result.all()
    })

  let map_builder = result_utils.lift2(build_tiles)
  map_builder(systems, grid)
}
