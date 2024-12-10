import core/models/planetary_system.{type System}
import game/systems
import gleam/dict
import gleam/option.{type Option}

const tiles: List(#(Int, System)) = [
  #(1, systems.sol_home_system), #(2, systems.mentak_home_system),
  #(3, systems.yin_home_system), #(4, systems.muaat_home_system),
  #(5, systems.arborec_home_system), #(6, systems.lizix_home_system),
  #(7, systems.winnu_home_system), #(8, systems.nekro_home_system),
  #(9, systems.naalu_home_system), #(10, systems.letnev_home_system),
  #(11, systems.saar_home_system), #(12, systems.jol_nar_home_system),
  #(13, systems.sardakk_home_system), #(14, systems.xxcha_home_system),
  #(15, systems.yssaril_home_system), #(16, systems.hacan_home_system),
  #(17, systems.creuss_wormhole_system), #(18, systems.mecatol_rex_system),
  #(19, systems.planetary_system_1), #(20, systems.planetary_system_2),
  #(21, systems.planetary_system_3), #(22, systems.planetary_system_4),
  #(23, systems.planetary_system_5), #(24, systems.planetary_system_6),
  #(25, systems.planetary_system_7), #(26, systems.planetary_system_8),
  #(27, systems.planetary_system_9), #(28, systems.planetary_system_10),
  #(29, systems.planetary_system_11), #(30, systems.planetary_system_12),
  #(31, systems.planetary_system_13), #(32, systems.planetary_system_14),
  #(33, systems.planetary_system_15), #(34, systems.planetary_system_16),
  #(35, systems.planetary_system_17), #(36, systems.planetary_system_18),
  #(37, systems.planetary_system_19), #(38, systems.planetary_system_20),
  #(39, systems.wormhole_system_1), #(40, systems.wormhole_system_2),
  #(41, systems.anomaly_system_1), #(42, systems.anomaly_system_2),
  #(43, systems.anomaly_system_3), #(44, systems.anomaly_system_4),
  #(45, systems.anomaly_system_5), #(46, systems.empty_system_1),
  #(47, systems.empty_system_2), #(48, systems.empty_system_3),
  #(49, systems.empty_system_4), #(50, systems.empty_system_5),
  #(51, systems.creuss_home_system),
]

pub fn get_system_from_tile_number(tile_number: Int) -> Option(System) {
  tiles
  |> dict.from_list()
  |> dict.get(tile_number)
  |> option.from_result()
}
