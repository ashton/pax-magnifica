import gleam/option.{None, Some}
import models/planetary_system.{
  Cultural, Hazardous, Industrial, Planet, TechSpecialty,
}
import models/technology.{Biotic, Cybernetic, Propulsion, Warfare}

pub const triplezero = Planet(
  name: "[0.0.0]",
  home: True,
  resources: 5,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const abyz = Planet(
  name: "Abyz",
  home: False,
  resources: 3,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
)

pub const arc_prime = Planet(
  name: "Arc Prime",
  home: True,
  resources: 4,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const archon_ren = Planet(
  name: "Archon Ren",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
)

pub const archon_tau = Planet(
  name: "Archon Tau",
  home: True,
  resources: 1,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const arinam = Planet(
  name: "Arinam",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
)

pub const arnor = Planet(
  name: "Arnor",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Industrial),
  specialties: [],
)

pub const arretze = Planet(
  name: "Arretze",
  home: True,
  resources: 2,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const bereg = Planet(
  name: "Bereg",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
)

pub const centauri = Planet(
  name: "Centauri",
  home: False,
  resources: 1,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
)

pub const corneeq = Planet(
  name: "Corneeq",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
)

pub const creuss = Planet(
  name: "Creuss",
  home: True,
  resources: 4,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const dal_bootha = Planet(
  name: "Dal Bootha",
  home: False,
  resources: 0,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
)

pub const darien = Planet(
  name: "Darien",
  home: True,
  resources: 4,
  influence: 4,
  trait: None,
  specialties: [],
)

pub const druaa = Planet(
  name: "Druaa",
  home: True,
  resources: 3,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const fria = Planet(
  name: "Fria",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
)

pub const gral = Planet(
  name: "Gral",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Propulsion)],
)

pub const hercant = Planet(
  name: "Hercant",
  home: True,
  resources: 1,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const jol = Planet(
  name: "Jol",
  home: True,
  resources: 1,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const jord = Planet(
  name: "Jord",
  home: True,
  resources: 4,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const kamdorn = Planet(
  name: "Kamdorn",
  home: True,
  resources: 0,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const lazar = Planet(
  name: "Lazar",
  home: False,
  resources: 1,
  influence: 0,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Cybernetic)],
)

pub const lirta_iv = Planet(
  name: "Lirta IV",
  home: False,
  resources: 2,
  influence: 3,
  trait: Some(Hazardous),
  specialties: [],
)

pub const lisis_ii = Planet(
  name: "Lisis II",
  home: True,
  resources: 1,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const lodor = Planet(
  name: "Lodor",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
)

pub const lor = Planet(
  name: "Lor",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
)

pub const maaluuk = Planet(
  name: "Maaluuk",
  home: True,
  resources: 0,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const mecatol_rex = Planet(
  name: "Mecatol Rex",
  home: False,
  resources: 1,
  influence: 6,
  trait: None,
  specialties: [],
)

pub const meer = Planet(
  name: "Meer",
  home: False,
  resources: 0,
  influence: 4,
  trait: Some(Hazardous),
  specialties: [TechSpecialty(Warfare)],
)

pub const mehar_xull = Planet(
  name: "Mehar Xull",
  home: False,
  resources: 0,
  influence: 4,
  trait: Some(Hazardous),
  specialties: [TechSpecialty(Warfare)],
)

pub const mellon = Planet(
  name: "Mellon",
  home: False,
  resources: 0,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
)

pub const moll_primus = Planet(
  name: "Moll Primus",
  home: True,
  resources: 4,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const mordai_ii = Planet(
  name: "Mordai II",
  home: True,
  resources: 4,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const muaat = Planet(
  name: "Muaat",
  home: True,
  resources: 4,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const nar = Planet(
  name: "Nar",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
)

pub const nestphar = Planet(
  name: "Nestphar",
  home: True,
  resources: 3,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const new_albion = Planet(
  name: "New Albion",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
)

pub const quann = Planet(
  name: "Quann",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
)

pub const qucenn = Planet(
  name: "Qucen'n",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
)

pub const quinarra = Planet(
  name: "Quinarra",
  home: True,
  resources: 3,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const ragh = Planet(
  name: "Ragh",
  home: True,
  resources: 2,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const rarron = Planet(
  name: "Rarron",
  home: False,
  resources: 0,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
)

pub const resculon = Planet(
  name: "Resculon",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Cultural),
  specialties: [],
)

pub const retillion = Planet(
  name: "Retillion",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
)

pub const sakulag = Planet(
  name: "Sakulag",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
)

pub const saudor = Planet(
  name: "Saudor",
  home: False,
  resources: 2,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
)

pub const shalloq = Planet(
  name: "Shalloq",
  home: True,
  resources: 1,
  influence: 2,
  trait: None,
  specialties: [],
)

pub const starpoint = Planet(
  name: "Starpoint",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
)

pub const tarmann = Planet(
  name: "Tar'Mann",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
)

pub const tequran = Planet(
  name: "Tequ'ran",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
)

pub const thibah = Planet(
  name: "Thibah",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Propulsion)],
)

pub const torkan = Planet(
  name: "Torkan",
  home: False,
  resources: 0,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
)

pub const trenlak = Planet(
  name: "Tren'lak",
  home: True,
  resources: 1,
  influence: 0,
  trait: None,
  specialties: [],
)

pub const vefut_ii = Planet(
  name: "Vefut II",
  home: False,
  resources: 2,
  influence: 2,
  trait: Some(Hazardous),
  specialties: [],
)

pub const wellon = Planet(
  name: "Wellon",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Cybernetic)],
)

pub const winnu = Planet(
  name: "Winnu",
  home: True,
  resources: 3,
  influence: 4,
  trait: None,
  specialties: [],
)

pub const wren_terra = Planet(
  name: "Wren Terra",
  home: True,
  resources: 2,
  influence: 1,
  trait: None,
  specialties: [],
)

pub const xxehan = Planet(
  name: "Xxehan",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
)

pub const zohbat = Planet(
  name: "Zohbat",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
)

pub const all = [
  triplezero, abyz, arc_prime, archon_ren, archon_tau, arinam, arnor, arretze,
  bereg, centauri, corneeq, creuss, dal_bootha, darien, druaa, fria, gral,
  hercant, jol, jord, kamdorn, lazar, lirta_iv, lisis_ii, lodor, lor, maaluuk,
  mecatol_rex, meer, mehar_xull, mellon, moll_primus, mordai_ii, muaat, nar,
  nestphar, new_albion, quann, qucenn, quinarra, ragh, rarron, resculon,
  retillion, sakulag, saudor, shalloq, starpoint, tarmann, tequran, thibah,
  torkan, trenlak, vefut_ii, wellon, winnu, wren_terra, xxehan, zohbat,
]
