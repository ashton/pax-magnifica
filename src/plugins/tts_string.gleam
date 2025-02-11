import core/models/hex/grid.{type HexGrid}
import core/models/hex/hex.{type Hex}
import core/models/hex/ring
import core/models/map.{type Map, type Tile}
import core/models/planetary_system.{type System}
import game/tiles
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/result_utils

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

fn build_tiles(
  systems: List(System),
  grid: HexGrid,
) -> Result(List(Tile), String) {
  todo
  // grid
  // |> grid.rings()
  // |> list.map(fn(current_ring) {
  //   
  // })
}

pub fn map_from_tts_string(tts_string: String) -> Result(Map, String) {
  todo
  // let tile_numbers =
  //   "18 "
  //   |> string.append(tts_string)
  //   |> string.trim()
  //   |> get_tile_numbers()
  //
  // let grid =
  //   tile_numbers
  //   |> get_rings_amount()
  //   |> result.then(grid.new)
  //
  // let systems =
  //   tile_numbers
  //   |> list.map(result.then(_, apply: tiles.get_system_from_tile_number))
  //   |> result.all()
  //
  // let map_builder = result_utils.lift2(create_map)
  //
  // map_builder(systems, grid)
  // |> result.flatten()
}
