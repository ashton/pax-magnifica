import core/models/planetary_system.{
  Alpha, AnomalySystem, AsteroidField, Beta, Blue, Delta, EmptySystem,
  GravityRift, Green, HomeSystem, MecatolRex, Nebula, PlanetarySystem, Red,
  Supernova, System,
}
import game/planets

pub const sol_home_system = System(
  planets: [planets.jord],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const mentak_home_system = System(
  planets: [planets.moll_primus],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const yin_home_system = System(
  planets: [planets.darien],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const muaat_home_system = System(
  planets: [planets.muaat],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const arborec_home_system = System(
  planets: [planets.nestphar],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const lizix_home_system = System(
  planets: [planets.triplezero],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const winnu_home_system = System(
  planets: [planets.winnu],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const nekro_home_system = System(
  planets: [planets.mordai_ii],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const naalu_home_system = System(
  planets: [planets.maaluuk, planets.druaa],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const letnev_home_system = System(
  planets: [planets.arc_prime, planets.wren_terra],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const saar_home_system = System(
  planets: [planets.lisis_ii, planets.ragh],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const jol_nar_home_system = System(
  planets: [planets.jol, planets.nar],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const sardakk_home_system = System(
  planets: [planets.trenlak, planets.quinarra],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const xxcha_home_system = System(
  planets: [planets.archon_ren, planets.archon_tau],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const yssaril_home_system = System(
  planets: [planets.retillion, planets.shalloq],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const hacan_home_system = System(
  planets: [planets.hercant, planets.arretze, planets.kamdorn],
  wormholes: [],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const creuss_wormhole_system = System(
  planets: [],
  wormholes: [Delta],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const creuss_home_system = System(
  planets: [planets.creuss],
  wormholes: [Delta],
  color: Green,
  units: [],
  trait: HomeSystem,
)

pub const mecatol_rex_system = System(
  planets: [planets.mecatol_rex],
  wormholes: [],
  color: Green,
  units: [],
  trait: MecatolRex,
)

pub const planetary_system_1 = System(
  color: Blue,
  planets: [planets.wellon],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_2 = System(
  color: Blue,
  planets: [planets.vefut_ii],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_3 = System(
  color: Blue,
  planets: [planets.thibah],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_4 = System(
  color: Blue,
  planets: [planets.tarmann],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_5 = System(
  color: Blue,
  planets: [planets.saudor],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_6 = System(
  color: Blue,
  planets: [planets.mehar_xull],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_7 = System(
  color: Blue,
  planets: [planets.quann],
  wormholes: [Beta],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_8 = System(
  color: Blue,
  planets: [planets.lodor],
  wormholes: [Alpha],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_9 = System(
  color: Blue,
  planets: [planets.new_albion, planets.starpoint],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_10 = System(
  color: Blue,
  planets: [planets.tequran, planets.torkan],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_11 = System(
  color: Blue,
  planets: [planets.qucenn, planets.rarron],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_12 = System(
  color: Blue,
  planets: [planets.mellon, planets.zohbat],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_13 = System(
  color: Blue,
  planets: [planets.lazar, planets.sakulag],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_14 = System(
  color: Blue,
  planets: [planets.dal_bootha, planets.xxehan],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_15 = System(
  color: Blue,
  planets: [planets.corneeq, planets.resculon],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_16 = System(
  color: Blue,
  planets: [planets.centauri, planets.gral],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_17 = System(
  color: Blue,
  planets: [planets.bereg, planets.lirta_iv],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_18 = System(
  color: Blue,
  planets: [planets.arnor, planets.lor],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_19 = System(
  color: Blue,
  planets: [planets.arinam, planets.meer],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const planetary_system_20 = System(
  color: Blue,
  planets: [planets.abyz, planets.fria],
  wormholes: [],
  units: [],
  trait: PlanetarySystem,
)

pub const wormhole_system_1 = System(
  color: Red,
  planets: [],
  wormholes: [Alpha],
  units: [],
  trait: PlanetarySystem,
)

pub const wormhole_system_2 = System(
  color: Red,
  planets: [],
  wormholes: [Beta],
  units: [],
  trait: PlanetarySystem,
)

pub const anomaly_system_1 = System(
  color: Red,
  wormholes: [],
  planets: [],
  units: [],
  trait: AnomalySystem(kind: GravityRift),
)

pub const anomaly_system_2 = System(
  color: Red,
  wormholes: [],
  planets: [],
  units: [],
  trait: AnomalySystem(kind: Nebula),
)

pub const anomaly_system_3 = System(
  color: Red,
  wormholes: [],
  planets: [],
  units: [],
  trait: AnomalySystem(kind: Supernova),
)

pub const anomaly_system_4 = System(
  color: Red,
  wormholes: [],
  planets: [],
  units: [],
  trait: AnomalySystem(kind: AsteroidField),
)

pub const anomaly_system_5 = System(
  color: Red,
  wormholes: [],
  planets: [],
  units: [],
  trait: AnomalySystem(kind: AsteroidField),
)

pub const empty_system_1 = System(
  color: Red,
  planets: [],
  wormholes: [],
  units: [],
  trait: EmptySystem,
)

pub const empty_system_2 = System(
  color: Red,
  planets: [],
  wormholes: [],
  units: [],
  trait: EmptySystem,
)

pub const empty_system_3 = System(
  color: Red,
  planets: [],
  wormholes: [],
  units: [],
  trait: EmptySystem,
)

pub const empty_system_4 = System(
  color: Red,
  planets: [],
  wormholes: [],
  units: [],
  trait: EmptySystem,
)

pub const empty_system_5 = System(
  color: Red,
  planets: [],
  wormholes: [],
  units: [],
  trait: EmptySystem,
)

pub const home_systems = [
  arborec_home_system,
  creuss_home_system,
  hacan_home_system,
  jol_nar_home_system,
  letnev_home_system,
  lizix_home_system,
  mentak_home_system,
  muaat_home_system,
  naalu_home_system,
  nekro_home_system,
  saar_home_system,
  sardakk_home_system,
  sol_home_system,
  winnu_home_system,
  xxcha_home_system,
  yin_home_system,
  yssaril_home_system,
]

pub const green_systems = home_systems

pub const planetary_systems = [
  planetary_system_1,
  planetary_system_2,
  planetary_system_3,
  planetary_system_4,
  planetary_system_5,
  planetary_system_6,
  planetary_system_7,
  planetary_system_8,
  planetary_system_9,
  planetary_system_10,
  planetary_system_11,
  planetary_system_12,
  planetary_system_13,
  planetary_system_14,
  planetary_system_15,
  planetary_system_16,
  planetary_system_17,
  planetary_system_18,
  planetary_system_19,
  planetary_system_20,
]

pub const blue_systems = planetary_systems

pub const wormhole_systems = [wormhole_system_1, wormhole_system_2]

pub const anomaly_systems = [
  anomaly_system_1,
  anomaly_system_2,
  anomaly_system_3,
  anomaly_system_4,
  anomaly_system_5,
]

pub const empty_systems = [
  empty_system_1,
  empty_system_2,
  empty_system_3,
  empty_system_4,
  empty_system_5,
]

pub const red_systems = [
  wormhole_system_1,
  wormhole_system_2,
  anomaly_system_1,
  anomaly_system_2,
  anomaly_system_3,
  anomaly_system_4,
  anomaly_system_5,
  empty_system_1,
  empty_system_2,
  empty_system_3,
  empty_system_4,
  empty_system_5,
]

pub const all_systems = [
  sol_home_system,
  mentak_home_system,
  yin_home_system,
  muaat_home_system,
  arborec_home_system,
  lizix_home_system,
  winnu_home_system,
  nekro_home_system,
  naalu_home_system,
  letnev_home_system,
  saar_home_system,
  jol_nar_home_system,
  sardakk_home_system,
  xxcha_home_system,
  yssaril_home_system,
  hacan_home_system,
  creuss_wormhole_system,
  creuss_home_system,
  mecatol_rex_system,
  planetary_system_1,
  planetary_system_2,
  planetary_system_3,
  planetary_system_4,
  planetary_system_5,
  planetary_system_6,
  planetary_system_7,
  planetary_system_8,
  planetary_system_9,
  planetary_system_10,
  planetary_system_11,
  planetary_system_12,
  planetary_system_13,
  planetary_system_14,
  planetary_system_15,
  planetary_system_16,
  planetary_system_17,
  planetary_system_18,
  planetary_system_19,
  planetary_system_20,
  wormhole_system_1,
  wormhole_system_2,
  anomaly_system_1,
  anomaly_system_2,
  anomaly_system_3,
  anomaly_system_4,
  anomaly_system_5,
  empty_system_1,
  empty_system_2,
  empty_system_3,
  empty_system_4,
  empty_system_5,
]
