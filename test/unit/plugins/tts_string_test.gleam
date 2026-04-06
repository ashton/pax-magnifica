import core/models/hex/hex
import core/models/map
import game/systems
import gleam/result

import plugins/tts_string.{map_from_tts_string}

pub fn import_map_with_0_ringfrom_tts_string_test() {
  let assert Ok(hex_tile) = hex.from_pair(#(0, 0))

  let expectation = [
    map.Tile(system: systems.mecatol_rex_system, hex: hex_tile),
  ]

  let assert Ok(subject) = map_from_tts_string("")

  assert expectation == subject
}

pub fn import_map_with_1_ringfrom_tts_string_test() {
  let expectation = {
    use hex1 <- result.try(hex.from_pair(#(0, 0)))
    use hex2 <- result.try(hex.from_pair(#(0, -1)))
    use hex3 <- result.try(hex.from_pair(#(1, -1)))
    use hex4 <- result.try(hex.from_pair(#(1, 0)))
    use hex5 <- result.try(hex.from_pair(#(0, 1)))
    use hex6 <- result.try(hex.from_pair(#(-1, 1)))
    use hex7 <- result.try(hex.from_pair(#(-1, 0)))

    [
      map.Tile(system: systems.mecatol_rex_system, hex: hex1),
      map.Tile(system: systems.planetary_system_15, hex: hex2),
      map.Tile(system: systems.planetary_system_12, hex: hex3),
      map.Tile(system: systems.anomaly_system_3, hex: hex4),
      map.Tile(system: systems.wormhole_system_2, hex: hex5),
      map.Tile(system: systems.planetary_system_18, hex: hex6),
      map.Tile(system: systems.planetary_system_8, hex: hex7),
    ]
    |> Ok()
  }

  let subject = map_from_tts_string("33 30 43 40 36 26")

  assert expectation == subject
}

pub fn import_map_with_2_ringfrom_tts_string_test() {
  let expectation = {
    use hex1 <- result.try(hex.from_pair(#(0, 0)))
    use hex2 <- result.try(hex.from_pair(#(0, -1)))
    use hex3 <- result.try(hex.from_pair(#(1, -1)))
    use hex4 <- result.try(hex.from_pair(#(1, 0)))
    use hex5 <- result.try(hex.from_pair(#(0, 1)))
    use hex6 <- result.try(hex.from_pair(#(-1, 1)))
    use hex7 <- result.try(hex.from_pair(#(-1, 0)))
    use hex8 <- result.try(hex.from_pair(#(0, -2)))
    use hex9 <- result.try(hex.from_pair(#(1, -2)))
    use hex10 <- result.try(hex.from_pair(#(2, -2)))
    use hex11 <- result.try(hex.from_pair(#(2, -1)))
    use hex12 <- result.try(hex.from_pair(#(2, 0)))
    use hex13 <- result.try(hex.from_pair(#(1, 1)))
    use hex14 <- result.try(hex.from_pair(#(0, 2)))
    use hex15 <- result.try(hex.from_pair(#(-1, 2)))
    use hex16 <- result.try(hex.from_pair(#(-2, 2)))
    use hex17 <- result.try(hex.from_pair(#(-2, 1)))
    use hex18 <- result.try(hex.from_pair(#(-2, 0)))
    use hex19 <- result.try(hex.from_pair(#(-1, -1)))

    [
      map.Tile(system: systems.mecatol_rex_system, hex: hex1),
      map.Tile(system: systems.planetary_system_15, hex: hex2),
      map.Tile(system: systems.planetary_system_12, hex: hex3),
      map.Tile(system: systems.anomaly_system_3, hex: hex4),
      map.Tile(system: systems.wormhole_system_2, hex: hex5),
      map.Tile(system: systems.planetary_system_18, hex: hex6),
      map.Tile(system: systems.planetary_system_8, hex: hex7),
      map.Tile(system: systems.planetary_system_17, hex: hex8),
      map.Tile(system: systems.anomaly_system_5, hex: hex9),
      map.Tile(system: systems.planetary_system_9, hex: hex10),
      map.Tile(system: systems.empty_system_1, hex: hex11),
      map.Tile(system: systems.planetary_system_13, hex: hex12),
      map.Tile(system: systems.empty_system_2, hex: hex13),
      map.Tile(system: systems.planetary_system_19, hex: hex14),
      map.Tile(system: systems.planetary_system_3, hex: hex15),
      map.Tile(system: systems.planetary_system_16, hex: hex16),
      map.Tile(system: systems.planetary_system_4, hex: hex17),
      map.Tile(system: systems.planetary_system_20, hex: hex18),
      map.Tile(system: systems.planetary_system_11, hex: hex19),
    ]
    |> Ok()
  }

  let subject =
    map_from_tts_string("33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29")

  assert expectation == subject
}

pub fn import_map_with_3_ringfrom_tts_string_test() {
  let expectation = {
    use hex1 <- result.try(hex.from_pair(#(0, 0)))
    use hex2 <- result.try(hex.from_pair(#(0, -1)))
    use hex3 <- result.try(hex.from_pair(#(1, -1)))
    use hex4 <- result.try(hex.from_pair(#(1, 0)))
    use hex5 <- result.try(hex.from_pair(#(0, 1)))
    use hex6 <- result.try(hex.from_pair(#(-1, 1)))
    use hex7 <- result.try(hex.from_pair(#(-1, 0)))
    use hex8 <- result.try(hex.from_pair(#(0, -2)))
    use hex9 <- result.try(hex.from_pair(#(1, -2)))
    use hex10 <- result.try(hex.from_pair(#(2, -2)))
    use hex11 <- result.try(hex.from_pair(#(2, -1)))
    use hex12 <- result.try(hex.from_pair(#(2, 0)))
    use hex13 <- result.try(hex.from_pair(#(1, 1)))
    use hex14 <- result.try(hex.from_pair(#(0, 2)))
    use hex15 <- result.try(hex.from_pair(#(-1, 2)))
    use hex16 <- result.try(hex.from_pair(#(-2, 2)))
    use hex17 <- result.try(hex.from_pair(#(-2, 1)))
    use hex18 <- result.try(hex.from_pair(#(-2, 0)))
    use hex19 <- result.try(hex.from_pair(#(-1, -1)))
    use hex20 <- result.try(hex.from_pair(#(0, -3)))
    use hex21 <- result.try(hex.from_pair(#(1, -3)))
    use hex22 <- result.try(hex.from_pair(#(2, -3)))
    use hex23 <- result.try(hex.from_pair(#(3, -3)))
    use hex24 <- result.try(hex.from_pair(#(3, -2)))
    use hex25 <- result.try(hex.from_pair(#(3, -1)))
    use hex26 <- result.try(hex.from_pair(#(3, 0)))
    use hex27 <- result.try(hex.from_pair(#(2, 1)))
    use hex28 <- result.try(hex.from_pair(#(1, 2)))
    use hex29 <- result.try(hex.from_pair(#(0, 3)))
    use hex30 <- result.try(hex.from_pair(#(-1, 3)))
    use hex31 <- result.try(hex.from_pair(#(-2, 3)))
    use hex32 <- result.try(hex.from_pair(#(-3, 3)))
    use hex33 <- result.try(hex.from_pair(#(-3, 2)))
    use hex34 <- result.try(hex.from_pair(#(-3, 1)))
    use hex35 <- result.try(hex.from_pair(#(-3, 0)))
    use hex36 <- result.try(hex.from_pair(#(-2, -1)))
    use hex37 <- result.try(hex.from_pair(#(-1, -2)))

    let tiles =
      [
        map.Tile(system: systems.mecatol_rex_system, hex: hex1),
        map.Tile(system: systems.planetary_system_15, hex: hex2),
        map.Tile(system: systems.planetary_system_12, hex: hex3),
        map.Tile(system: systems.anomaly_system_3, hex: hex4),
        map.Tile(system: systems.wormhole_system_2, hex: hex5),
        map.Tile(system: systems.planetary_system_18, hex: hex6),
        map.Tile(system: systems.planetary_system_8, hex: hex7),
        map.Tile(system: systems.planetary_system_17, hex: hex8),
        map.Tile(system: systems.anomaly_system_5, hex: hex9),
        map.Tile(system: systems.planetary_system_9, hex: hex10),
        map.Tile(system: systems.empty_system_1, hex: hex11),
        map.Tile(system: systems.planetary_system_13, hex: hex12),
        map.Tile(system: systems.empty_system_2, hex: hex13),
        map.Tile(system: systems.planetary_system_19, hex: hex14),
        map.Tile(system: systems.planetary_system_3, hex: hex15),
        map.Tile(system: systems.planetary_system_16, hex: hex16),
        map.Tile(system: systems.planetary_system_4, hex: hex17),
        map.Tile(system: systems.planetary_system_20, hex: hex18),
        map.Tile(system: systems.planetary_system_11, hex: hex19),
        map.Tile(system: systems.sardakk_home_system, hex: hex20),
        map.Tile(system: systems.planetary_system_6, hex: hex21),
        map.Tile(system: systems.planetary_system_7, hex: hex22),
        map.Tile(system: systems.creuss_wormhole_system, hex: hex23),
        map.Tile(system: systems.empty_system_3, hex: hex24),
        map.Tile(system: systems.planetary_system_1, hex: hex25),
        map.Tile(system: systems.saar_home_system, hex: hex26),
        map.Tile(system: systems.empty_system_5, hex: hex27),
        map.Tile(system: systems.anomaly_system_4, hex: hex28),
        map.Tile(system: systems.arborec_home_system, hex: hex29),
        map.Tile(system: systems.wormhole_system_1, hex: hex30),
        map.Tile(system: systems.anomaly_system_2, hex: hex31),
        map.Tile(system: systems.yssaril_home_system, hex: hex32),
        map.Tile(system: systems.empty_system_4, hex: hex33),
        map.Tile(system: systems.anomaly_system_1, hex: hex34),
        map.Tile(system: systems.sol_home_system, hex: hex35),
        map.Tile(system: systems.planetary_system_14, hex: hex36),
        map.Tile(system: systems.planetary_system_2, hex: hex37),
      ]
      |> Ok()
  }

  let subject =
    map_from_tts_string(
      "33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29 13 24 25 17 48 19 11 50 44 5 39 42 15 49 41 1 32 20",
    )

  assert expectation == subject
}
