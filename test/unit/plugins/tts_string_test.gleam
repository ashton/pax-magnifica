import core/models/hex/grid
import core/models/hex/hex
import core/models/map
import game/systems
import glacier/should

import plugins/tts_string.{map_from_tts_string}

pub fn import_map_with_0_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      hex: hex.from_pair(#(0, 0)) |> should.be_ok(),
    ),
  ]

  let hexgrid =
    grid.new(0)
    |> should.be_ok()

  let map = map.new(tiles, hexgrid)

  map_from_tts_string("")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_1_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      hex: hex.from_pair(#(0, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      hex: hex.from_pair(#(0, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      hex: hex.from_pair(#(1, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      hex: hex.from_pair(#(1, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      hex: hex.from_pair(#(0, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      hex: hex.from_pair(#(-1, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      hex: hex.from_pair(#(-1, 0)) |> should.be_ok(),
    ),
  ]

  let hexgrid =
    grid.new(1)
    |> should.be_ok()

  let map = map.new(tiles, hexgrid)

  map_from_tts_string("33 30 43 40 36 26")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_2_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      hex: hex.from_pair(#(0, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      hex: hex.from_pair(#(0, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      hex: hex.from_pair(#(1, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      hex: hex.from_pair(#(1, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      hex: hex.from_pair(#(0, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      hex: hex.from_pair(#(-1, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      hex: hex.from_pair(#(-1, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_17,
      hex: hex.from_pair(#(0, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_5,
      hex: hex.from_pair(#(1, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_9,
      hex: hex.from_pair(#(2, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_1,
      hex: hex.from_pair(#(2, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_13,
      hex: hex.from_pair(#(2, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_2,
      hex: hex.from_pair(#(1, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_19,
      hex: hex.from_pair(#(0, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_3,
      hex: hex.from_pair(#(-1, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_16,
      hex: hex.from_pair(#(-2, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_4,
      hex: hex.from_pair(#(-2, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_20,
      hex: hex.from_pair(#(-2, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_11,
      hex: hex.from_pair(#(-1, -1)) |> should.be_ok(),
    ),
  ]

  let hexgrid =
    grid.new(2)
    |> should.be_ok()

  let map = map.new(tiles, hexgrid)

  map_from_tts_string("33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29")
  |> should.be_ok()
  |> should.equal(map)
}

pub fn import_map_with_3_ringfrom_tts_string_test() {
  let tiles = [
    map.Tile(
      system: systems.mecatol_rex_system,
      hex: hex.from_pair(#(0, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_15,
      hex: hex.from_pair(#(0, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_12,
      hex: hex.from_pair(#(1, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_3,
      hex: hex.from_pair(#(1, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.wormhole_system_2,
      hex: hex.from_pair(#(0, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_18,
      hex: hex.from_pair(#(-1, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_8,
      hex: hex.from_pair(#(-1, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_17,
      hex: hex.from_pair(#(0, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_5,
      hex: hex.from_pair(#(1, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_9,
      hex: hex.from_pair(#(2, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_1,
      hex: hex.from_pair(#(2, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_13,
      hex: hex.from_pair(#(2, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_2,
      hex: hex.from_pair(#(1, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_19,
      hex: hex.from_pair(#(0, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_3,
      hex: hex.from_pair(#(-1, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_16,
      hex: hex.from_pair(#(-2, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_4,
      hex: hex.from_pair(#(-2, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_20,
      hex: hex.from_pair(#(-2, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_11,
      hex: hex.from_pair(#(-1, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.sardakk_home_system,
      hex: hex.from_pair(#(0, -3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_6,
      hex: hex.from_pair(#(1, -3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_7,
      hex: hex.from_pair(#(2, -3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.creuss_wormhole_system,
      hex: hex.from_pair(#(3, -3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_3,
      hex: hex.from_pair(#(3, -2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_1,
      hex: hex.from_pair(#(3, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.saar_home_system,
      hex: hex.from_pair(#(3, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_5,
      hex: hex.from_pair(#(2, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_4,
      hex: hex.from_pair(#(1, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.arborec_home_system,
      hex: hex.from_pair(#(0, 3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.wormhole_system_1,
      hex: hex.from_pair(#(-1, 3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_2,
      hex: hex.from_pair(#(-2, 3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.yssaril_home_system,
      hex: hex.from_pair(#(-3, 3)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.empty_system_4,
      hex: hex.from_pair(#(-3, 2)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.anomaly_system_1,
      hex: hex.from_pair(#(-3, 1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.sol_home_system,
      hex: hex.from_pair(#(-3, 0)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_14,
      hex: hex.from_pair(#(-2, -1)) |> should.be_ok(),
    ),
    map.Tile(
      system: systems.planetary_system_2,
      hex: hex.from_pair(#(-1, -2)) |> should.be_ok(),
    ),
  ]

  let hexgrid =
    grid.new(3)
    |> should.be_ok()

  let map = map.new(tiles, hexgrid)
  map_from_tts_string(
    "33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29 13 24 25 17 48 19 11 50 44 5 39 42 15 49 41 1 32 20",
  )
  |> should.be_ok()
  |> should.equal(map)
}
