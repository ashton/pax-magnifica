import core/models/hex/grid.{type HexGrid}
import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{type System}
import game/tiles
import gleam/dict.{type Dict}
import gleam/int
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
    Ok(1) -> Ok(1)
    Ok(7) -> Ok(2)
    Ok(19) -> Ok(3)
    Ok(37) -> Ok(4)
    Ok(61) -> Ok(5)
    Error(_) -> Error("Invalid tile numbers")
    Ok(_) -> Error("Invalid amount of tiles")
  }
}

fn build_tiles(systems: List(System), grid: HexGrid) -> Dict(Hex, System) {
  grid
  |> grid.hexes_by_ring()
  |> list.map2(systems, _, fn(system, hex) { #(hex, system) })
  |> dict.from_list()
}

pub fn map_from_tts_string(
  tts_string: String,
) -> Result(Dict(Hex, System), String) {
  let tile_numbers =
    // Mecatol rex is always in the map
    "18 "
    |> string.append(tts_string)
    |> string.trim()
    |> get_tile_numbers()

  let grid =
    tile_numbers
    |> get_rings_amount()
    |> result.try(grid.new)

  let systems =
    tile_numbers
    |> result.try(fn(numbers) {
      numbers
      |> list.map(tiles.get_system_from_tile_number)
      |> result.all()
    })

  let map_builder = result_utils.lift2(build_tiles)
  map_builder(systems, grid)
}
