import core/models/hex/hex
import game/systems
import gleam/dict
import gleam/result
import plugins/tts_string.{map_from_tts_string}
import unitest

pub fn import_map_with_0_ringfrom_tts_string_test() {
  use <- unitest.tags(["unit", "plugins", "tts_string"])
  let expectation = {
    use h <- result.try(hex.from_pair(#(0, 0)))
    dict.from_list([#(h, systems.mecatol_rex_system)])
    |> Ok()
  }

  assert expectation == map_from_tts_string("")
}

pub fn import_map_with_1_ringfrom_tts_string_test() {
  use <- unitest.tags(["unit", "plugins", "tts_string"])
  let expectation = {
    use h0 <- result.try(hex.from_pair(#(0, 0)))
    use h1 <- result.try(hex.from_pair(#(0, -1)))
    use h2 <- result.try(hex.from_pair(#(1, -1)))
    use h3 <- result.try(hex.from_pair(#(1, 0)))
    use h4 <- result.try(hex.from_pair(#(0, 1)))
    use h5 <- result.try(hex.from_pair(#(-1, 1)))
    use h6 <- result.try(hex.from_pair(#(-1, 0)))

    dict.from_list([
      #(h0, systems.mecatol_rex_system),
      #(h1, systems.planetary_system_15),
      #(h2, systems.planetary_system_12),
      #(h3, systems.anomaly_system_3),
      #(h4, systems.wormhole_system_2),
      #(h5, systems.planetary_system_18),
      #(h6, systems.planetary_system_8),
    ])
    |> Ok()
  }

  assert expectation == map_from_tts_string("33 30 43 40 36 26")
}

// Ring 2+ hexes are produced clockwise from direction 0, matching ring 1's convention.
pub fn import_map_with_2_ringfrom_tts_string_test() {
  use <- unitest.tags(["unit", "plugins", "tts_string"])
  let expectation = {
    use h0 <- result.try(hex.from_pair(#(0, 0)))
    use h1 <- result.try(hex.from_pair(#(0, -1)))
    use h2 <- result.try(hex.from_pair(#(1, -1)))
    use h3 <- result.try(hex.from_pair(#(1, 0)))
    use h4 <- result.try(hex.from_pair(#(0, 1)))
    use h5 <- result.try(hex.from_pair(#(-1, 1)))
    use h6 <- result.try(hex.from_pair(#(-1, 0)))
    use h7 <- result.try(hex.from_pair(#(0, -2)))
    use h8 <- result.try(hex.from_pair(#(1, -2)))
    use h9 <- result.try(hex.from_pair(#(2, -2)))
    use h10 <- result.try(hex.from_pair(#(2, -1)))
    use h11 <- result.try(hex.from_pair(#(2, 0)))
    use h12 <- result.try(hex.from_pair(#(1, 1)))
    use h13 <- result.try(hex.from_pair(#(0, 2)))
    use h14 <- result.try(hex.from_pair(#(-1, 2)))
    use h15 <- result.try(hex.from_pair(#(-2, 2)))
    use h16 <- result.try(hex.from_pair(#(-2, 1)))
    use h17 <- result.try(hex.from_pair(#(-2, 0)))
    use h18 <- result.try(hex.from_pair(#(-1, -1)))

    dict.from_list([
      #(h0, systems.mecatol_rex_system),
      #(h1, systems.planetary_system_15),
      #(h2, systems.planetary_system_12),
      #(h3, systems.anomaly_system_3),
      #(h4, systems.wormhole_system_2),
      #(h5, systems.planetary_system_18),
      #(h6, systems.planetary_system_8),
      #(h7, systems.planetary_system_17),
      #(h8, systems.anomaly_system_5),
      #(h9, systems.planetary_system_9),
      #(h10, systems.empty_system_1),
      #(h11, systems.planetary_system_13),
      #(h12, systems.empty_system_2),
      #(h13, systems.planetary_system_19),
      #(h14, systems.planetary_system_3),
      #(h15, systems.planetary_system_16),
      #(h16, systems.planetary_system_4),
      #(h17, systems.planetary_system_20),
      #(h18, systems.planetary_system_11),
    ])
    |> Ok()
  }

  assert expectation
    == map_from_tts_string("33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29")
}

pub fn import_map_with_3_ringfrom_tts_string_test() {
  use <- unitest.tags(["unit", "plugins", "tts_string"])
  let expectation = {
    use h0 <- result.try(hex.from_pair(#(0, 0)))
    use h1 <- result.try(hex.from_pair(#(0, -1)))
    use h2 <- result.try(hex.from_pair(#(1, -1)))
    use h3 <- result.try(hex.from_pair(#(1, 0)))
    use h4 <- result.try(hex.from_pair(#(0, 1)))
    use h5 <- result.try(hex.from_pair(#(-1, 1)))
    use h6 <- result.try(hex.from_pair(#(-1, 0)))
    use h7 <- result.try(hex.from_pair(#(0, -2)))
    use h8 <- result.try(hex.from_pair(#(1, -2)))
    use h9 <- result.try(hex.from_pair(#(2, -2)))
    use h10 <- result.try(hex.from_pair(#(2, -1)))
    use h11 <- result.try(hex.from_pair(#(2, 0)))
    use h12 <- result.try(hex.from_pair(#(1, 1)))
    use h13 <- result.try(hex.from_pair(#(0, 2)))
    use h14 <- result.try(hex.from_pair(#(-1, 2)))
    use h15 <- result.try(hex.from_pair(#(-2, 2)))
    use h16 <- result.try(hex.from_pair(#(-2, 1)))
    use h17 <- result.try(hex.from_pair(#(-2, 0)))
    use h18 <- result.try(hex.from_pair(#(-1, -1)))
    use h19 <- result.try(hex.from_pair(#(0, -3)))
    use h20 <- result.try(hex.from_pair(#(1, -3)))
    use h21 <- result.try(hex.from_pair(#(2, -3)))
    use h22 <- result.try(hex.from_pair(#(3, -3)))
    use h23 <- result.try(hex.from_pair(#(3, -2)))
    use h24 <- result.try(hex.from_pair(#(3, -1)))
    use h25 <- result.try(hex.from_pair(#(3, 0)))
    use h26 <- result.try(hex.from_pair(#(2, 1)))
    use h27 <- result.try(hex.from_pair(#(1, 2)))
    use h28 <- result.try(hex.from_pair(#(0, 3)))
    use h29 <- result.try(hex.from_pair(#(-1, 3)))
    use h30 <- result.try(hex.from_pair(#(-2, 3)))
    use h31 <- result.try(hex.from_pair(#(-3, 3)))
    use h32 <- result.try(hex.from_pair(#(-3, 2)))
    use h33 <- result.try(hex.from_pair(#(-3, 1)))
    use h34 <- result.try(hex.from_pair(#(-3, 0)))
    use h35 <- result.try(hex.from_pair(#(-2, -1)))
    use h36 <- result.try(hex.from_pair(#(-1, -2)))

    dict.from_list([
      #(h0, systems.mecatol_rex_system),
      #(h1, systems.planetary_system_15),
      #(h2, systems.planetary_system_12),
      #(h3, systems.anomaly_system_3),
      #(h4, systems.wormhole_system_2),
      #(h5, systems.planetary_system_18),
      #(h6, systems.planetary_system_8),
      #(h7, systems.planetary_system_17),
      #(h8, systems.anomaly_system_5),
      #(h9, systems.planetary_system_9),
      #(h10, systems.empty_system_1),
      #(h11, systems.planetary_system_13),
      #(h12, systems.empty_system_2),
      #(h13, systems.planetary_system_19),
      #(h14, systems.planetary_system_3),
      #(h15, systems.planetary_system_16),
      #(h16, systems.planetary_system_4),
      #(h17, systems.planetary_system_20),
      #(h18, systems.planetary_system_11),
      #(h19, systems.sardakk_home_system),
      #(h20, systems.planetary_system_6),
      #(h21, systems.planetary_system_7),
      #(h22, systems.creuss_wormhole_system),
      #(h23, systems.empty_system_3),
      #(h24, systems.planetary_system_1),
      #(h25, systems.saar_home_system),
      #(h26, systems.empty_system_5),
      #(h27, systems.anomaly_system_4),
      #(h28, systems.arborec_home_system),
      #(h29, systems.wormhole_system_1),
      #(h30, systems.anomaly_system_2),
      #(h31, systems.yssaril_home_system),
      #(h32, systems.empty_system_4),
      #(h33, systems.anomaly_system_1),
      #(h34, systems.sol_home_system),
      #(h35, systems.planetary_system_14),
      #(h36, systems.planetary_system_2),
    ])
    |> Ok()
  }

  assert expectation
    == map_from_tts_string(
      "33 30 43 40 36 26 35 45 27 46 31 47 37 21 34 22 38 29 13 24 25 17 48 19 11 50 44 5 39 42 15 49 41 1 32 20",
    )
}
