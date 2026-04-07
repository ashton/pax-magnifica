import core/models/hex/hex.{type Hex}
import core/models/planetary_system.{type System}
import gleam/dict.{type Dict}
import gleam/option.{type Option, None}

pub type Map {
  Drafting(tiles: Dict(Hex, System))
  Map(tiles: Dict(Hex, System), active_system: Option(Hex))
}

pub fn default() -> Map {
  Drafting(dict.new())
}

pub fn new(tiles: Dict(Hex, System)) -> Map {
  Map(tiles:, active_system: None)
}

pub fn add_tile(map: Result(Map, String), hex: Hex, system: System) -> Result(Map, String) {
  case map {
    Ok(Drafting(tiles)) -> Ok(Drafting(tiles: dict.insert(tiles, hex, system)))
    Ok(_) -> Error("Only drafting maps can have tiles added")
    Error(_) -> map
  }
}

pub fn complete(map: Map) -> Result(Map, String) {
  case map {
    Drafting(tiles) -> Map(tiles:, active_system: None) |> Ok
    _ -> Error("Map is already completed")
  }
}
