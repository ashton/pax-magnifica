import core/models/hex/coordinate
import core/models/map
import game/systems
import glacier/should

import plugins/tts_string.{map_from_tts_string}

pub fn import_map_with_0_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      coordinates: coordinate.new(0, 0),
    ),
  ]

  let map = map.new(tiles)

  map_from_tts_string("")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_1_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      coordinates: coordinate.new(0, 0),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      coordinates: coordinate.new(0, -1),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      coordinates: coordinate.new(1, -1),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      coordinates: coordinate.new(1, 0),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      coordinates: coordinate.new(0, 1),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      coordinates: coordinate.new(-1, 1),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      coordinates: coordinate.new(-1, 0),
    ),
  ]

  let map = map.new(tiles)

  map_from_tts_string("33 30 43 40 36 26")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_2_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      coordinates: coordinate.new(0, 0),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      coordinates: coordinate.new(0, -1),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      coordinates: coordinate.new(1, -1),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      coordinates: coordinate.new(1, 0),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      coordinates: coordinate.new(0, 1),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      coordinates: coordinate.new(-1, 1),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      coordinates: coordinate.new(-1, 0),
    ),
    map.Tile(
      system: systems.planetary_system_17,
      coordinates: coordinate.new(0, -2),
    ),
    map.Tile(
      system: systems.anomaly_system_5,
      coordinates: coordinate.new(1, -2),
    ),
    map.Tile(
      system: systems.planetary_system_9,
      coordinates: coordinate.new(2, -2),
    ),
    map.Tile(system: systems.empty_system_1, coordinates: coordinate.new(2, -1)),
    map.Tile(
      system: systems.planetary_system_13,
      coordinates: coordinate.new(2, 0),
    ),
    map.Tile(system: systems.empty_system_2, coordinates: coordinate.new(1, 1)),
    map.Tile(
      system: systems.planetary_system_19,
      coordinates: coordinate.new(0, 2),
    ),
    map.Tile(
      system: systems.planetary_system_3,
      coordinates: coordinate.new(-1, 2),
    ),
    map.Tile(
      system: systems.planetary_system_16,
      coordinates: coordinate.new(-2, 2),
    ),
    map.Tile(
      system: systems.planetary_system_4,
      coordinates: coordinate.new(-2, 1),
    ),
    map.Tile(
      system: systems.planetary_system_20,
      coordinates: coordinate.new(-2, 0),
    ),
    map.Tile(
      system: systems.planetary_system_11,
      coordinates: coordinate.new(-1, -1),
    ),
  ]

  let map = map.new(tiles)
  map_from_tts_string("33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_3_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      coordinates: coordinate.new(0, 0),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      coordinates: coordinate.new(0, -1),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      coordinates: coordinate.new(1, -1),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      coordinates: coordinate.new(1, 0),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      coordinates: coordinate.new(0, 1),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      coordinates: coordinate.new(-1, 1),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      coordinates: coordinate.new(-1, 0),
    ),
    map.Tile(
      system: systems.planetary_system_17,
      coordinates: coordinate.new(0, -2),
    ),
    map.Tile(
      system: systems.anomaly_system_5,
      coordinates: coordinate.new(1, -2),
    ),
    map.Tile(
      system: systems.planetary_system_9,
      coordinates: coordinate.new(2, -2),
    ),
    map.Tile(system: systems.empty_system_1, coordinates: coordinate.new(2, -1)),
    map.Tile(
      system: systems.planetary_system_13,
      coordinates: coordinate.new(2, 0),
    ),
    map.Tile(system: systems.empty_system_2, coordinates: coordinate.new(1, 1)),
    map.Tile(
      system: systems.planetary_system_19,
      coordinates: coordinate.new(0, 2),
    ),
    map.Tile(
      system: systems.planetary_system_3,
      coordinates: coordinate.new(-1, 2),
    ),
    map.Tile(
      system: systems.planetary_system_16,
      coordinates: coordinate.new(-2, 2),
    ),
    map.Tile(
      system: systems.planetary_system_4,
      coordinates: coordinate.new(-2, 1),
    ),
    map.Tile(
      system: systems.planetary_system_20,
      coordinates: coordinate.new(-2, 0),
    ),
    map.Tile(
      system: systems.planetary_system_11,
      coordinates: coordinate.new(-1, -1),
    ),
    map.Tile(
      system: systems.sardakk_home_system,
      coordinates: coordinate.new(0, -3),
    ),
    map.Tile(
      system: systems.planetary_system_6,
      coordinates: coordinate.new(1, -3),
    ),
    map.Tile(
      system: systems.planetary_system_7,
      coordinates: coordinate.new(2, -3),
    ),
    map.Tile(
      system: systems.creuss_wormhole_system,
      coordinates: coordinate.new(3, -3),
    ),
    map.Tile(system: systems.empty_system_3, coordinates: coordinate.new(3, -2)),
    map.Tile(
      system: systems.planetary_system_1,
      coordinates: coordinate.new(3, -1),
    ),
    map.Tile(
      system: systems.saar_home_system,
      coordinates: coordinate.new(3, 0),
    ),
    map.Tile(system: systems.empty_system_5, coordinates: coordinate.new(2, 1)),
    map.Tile(
      system: systems.anomaly_system_4,
      coordinates: coordinate.new(1, 2),
    ),
    map.Tile(
      system: systems.arborec_home_system,
      coordinates: coordinate.new(0, 3),
    ),
    map.Tile(
      system: systems.wormhole_system_1,
      coordinates: coordinate.new(-1, 3),
    ),
    map.Tile(
      system: systems.anomaly_system_2,
      coordinates: coordinate.new(-2, 3),
    ),
    map.Tile(
      system: systems.yssaril_home_system,
      coordinates: coordinate.new(-3, 3),
    ),
    map.Tile(system: systems.empty_system_4, coordinates: coordinate.new(-3, 2)),
    map.Tile(
      system: systems.anomaly_system_1,
      coordinates: coordinate.new(-3, 1),
    ),
    map.Tile(
      system: systems.sol_home_system,
      coordinates: coordinate.new(-3, 0),
    ),
    map.Tile(
      system: systems.planetary_system_14,
      coordinates: coordinate.new(-2, -1),
    ),
    map.Tile(
      system: systems.planetary_system_2,
      coordinates: coordinate.new(-1, -2),
    ),
  ]

  let map = map.new(tiles)
  map_from_tts_string(
    "33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29 13 24 25 17 48 19 11 50 44 5 39 42 15 49 41 1 32 20",
  )
  |> should.be_ok()
  |> should.equal(map)
}
