import game/planets
import models/planetary_system.{
  Alpha, AnomalySystem, AsteroidField, Beta, Delta, EmptySystem, GravityRift,
  HomeSystem, Nebula, PlanetarySystem, Supernova,
}

pub const sol_home_system = HomeSystem(planets: [planets.jord], wormholes: [])

pub const mentak_home_system = HomeSystem(
  planets: [planets.moll_primus],
  wormholes: [],
)

pub const yin_home_system = HomeSystem(planets: [planets.darien], wormholes: [])

pub const muaat_home_system = HomeSystem(
  planets: [planets.muaat],
  wormholes: [],
)

pub const arborec_home_system = HomeSystem(
  planets: [planets.nestphar],
  wormholes: [],
)

pub const lizix_home_system = HomeSystem(
  planets: [planets.triplezero],
  wormholes: [],
)

pub const winnu_home_system = HomeSystem(
  planets: [planets.winnu],
  wormholes: [],
)

pub const nekro_home_system = HomeSystem(
  planets: [planets.mordai_ii],
  wormholes: [],
)

pub const naalu_home_system = HomeSystem(
  planets: [planets.maaluuk, planets.druaa],
  wormholes: [],
)

pub const letnev_home_system = HomeSystem(
  planets: [planets.arc_prime, planets.wren_terra],
  wormholes: [],
)

pub const saar_home_system = HomeSystem(
  planets: [planets.lisis_ii, planets.ragh],
  wormholes: [],
)

pub const jol_nar_home_system = HomeSystem(
  planets: [planets.jol, planets.nar],
  wormholes: [],
)

pub const sardakk_home_system = HomeSystem(
  planets: [planets.trenlak, planets.quinarra],
  wormholes: [],
)

pub const xxcha_home_system = HomeSystem(
  planets: [planets.archon_ren, planets.archon_tau],
  wormholes: [],
)

pub const yssaril_home_system = HomeSystem(
  planets: [planets.retillion, planets.shalloq],
  wormholes: [],
)

pub const hacan_home_system = HomeSystem(
  planets: [planets.hercant, planets.arretze, planets.kamdorn],
  wormholes: [],
)

pub const creuss_wormhole_system = HomeSystem(planets: [], wormholes: [Delta])

pub const creuss_home_system = HomeSystem(
  planets: [planets.creuss],
  wormholes: [Delta],
)

pub const mecatol_rex_system = PlanetarySystem(
  planets: [planets.mecatol_rex],
  wormholes: [],
)

pub const planetary_system_1 = PlanetarySystem(
  planets: [planets.wellon],
  wormholes: [],
)

pub const planetary_system_2 = PlanetarySystem(
  planets: [planets.vefut_ii],
  wormholes: [],
)

pub const planetary_system_3 = PlanetarySystem(
  planets: [planets.thibah],
  wormholes: [],
)

pub const planetary_system_4 = PlanetarySystem(
  planets: [planets.tarmann],
  wormholes: [],
)

pub const planetary_system_5 = PlanetarySystem(
  planets: [planets.saudor],
  wormholes: [],
)

pub const planetary_system_6 = PlanetarySystem(
  planets: [planets.mehar_xull],
  wormholes: [],
)

pub const planetary_system_7 = PlanetarySystem(
  planets: [planets.quann],
  wormholes: [Beta],
)

pub const planetary_system_8 = PlanetarySystem(
  planets: [planets.lodor],
  wormholes: [Alpha],
)

pub const planetary_system_9 = PlanetarySystem(
  planets: [planets.new_albion, planets.starpoint],
  wormholes: [],
)

pub const planetary_system_10 = PlanetarySystem(
  planets: [planets.tequran, planets.torkan],
  wormholes: [],
)

pub const planetary_system_11 = PlanetarySystem(
  planets: [planets.qucenn, planets.rarron],
  wormholes: [],
)

pub const planetary_system_12 = PlanetarySystem(
  planets: [planets.mellon, planets.zohbat],
  wormholes: [],
)

pub const planetary_system_13 = PlanetarySystem(
  planets: [planets.lazar, planets.sakulag],
  wormholes: [],
)

pub const planetary_system_14 = PlanetarySystem(
  planets: [planets.dal_bootha, planets.xxehan],
  wormholes: [],
)

pub const planetary_system_15 = PlanetarySystem(
  planets: [planets.corneeq, planets.resculon],
  wormholes: [],
)

pub const planetary_system_16 = PlanetarySystem(
  planets: [planets.centauri, planets.gral],
  wormholes: [],
)

pub const planetary_system_17 = PlanetarySystem(
  planets: [planets.bereg, planets.lirta_iv],
  wormholes: [],
)

pub const planetary_system_18 = PlanetarySystem(
  planets: [planets.arnor, planets.lor],
  wormholes: [],
)

pub const planetary_system_19 = PlanetarySystem(
  planets: [planets.arinam, planets.meer],
  wormholes: [],
)

pub const planetary_system_20 = PlanetarySystem(
  planets: [planets.arinam, planets.meer],
  wormholes: [],
)

pub const planetary_system_21 = PlanetarySystem(
  planets: [planets.abyz, planets.fria],
  wormholes: [],
)

pub const wormhole_system_1 = PlanetarySystem(planets: [], wormholes: [Alpha])

pub const wormhole_system_2 = PlanetarySystem(planets: [], wormholes: [Beta])

pub const anomaly_system_1 = AnomalySystem(kind: GravityRift, wormholes: [])

pub const anomaly_system_2 = AnomalySystem(kind: Nebula, wormholes: [])

pub const anomaly_system_3 = AnomalySystem(kind: Supernova, wormholes: [])

pub const anomaly_system_4 = AnomalySystem(kind: AsteroidField, wormholes: [])

pub const anomaly_system_5 = AnomalySystem(kind: AsteroidField, wormholes: [])

pub const empty_system_1 = EmptySystem

pub const empty_system_2 = EmptySystem

pub const empty_system_3 = EmptySystem

pub const empty_system_4 = EmptySystem

pub const empty_system_5 = EmptySystem

pub const all_systems = [
  sol_home_system, mentak_home_system, yin_home_system, muaat_home_system,
  arborec_home_system, lizix_home_system, winnu_home_system, nekro_home_system,
  naalu_home_system, letnev_home_system, saar_home_system, jol_nar_home_system,
  sardakk_home_system, xxcha_home_system, yssaril_home_system, hacan_home_system,
  creuss_wormhole_system, creuss_home_system, mecatol_rex_system,
  planetary_system_1, planetary_system_2, planetary_system_3, planetary_system_4,
  planetary_system_5, planetary_system_6, planetary_system_7, planetary_system_8,
  planetary_system_9, planetary_system_10, planetary_system_11,
  planetary_system_12, planetary_system_13, planetary_system_14,
  planetary_system_15, planetary_system_16, planetary_system_17,
  planetary_system_18, planetary_system_19, planetary_system_20,
  planetary_system_21, wormhole_system_1, wormhole_system_2, anomaly_system_1,
  anomaly_system_2, anomaly_system_3, anomaly_system_4, anomaly_system_5,
  empty_system_1, empty_system_2, empty_system_3, empty_system_4, empty_system_5,
]
