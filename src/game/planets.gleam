import core/models/planetary_system.{
  Cultural, Hazardous, Industrial, Planet, TechSpecialty,
}
import core/models/technology.{Biotic, Cybernetic, Propulsion, Warfare}
import gleam/option.{None, Some}

pub const triplezero = Planet(
  name: "[0.0.0]",
  home: True,
  resources: 5,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const abyz = Planet(
  name: "Abyz",
  home: False,
  resources: 3,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const arc_prime = Planet(
  name: "Arc Prime",
  home: True,
  resources: 4,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const archon_ren = Planet(
  name: "Archon Ren",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const archon_tau = Planet(
  name: "Archon Tau",
  home: True,
  resources: 1,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const arinam = Planet(
  name: "Arinam",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
  ground_units: [],
)

pub const arnor = Planet(
  name: "Arnor",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Industrial),
  specialties: [],
  ground_units: [],
)

pub const arretze = Planet(
  name: "Arretze",
  home: True,
  resources: 2,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const bereg = Planet(
  name: "Bereg",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const centauri = Planet(
  name: "Centauri",
  home: False,
  resources: 1,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const corneeq = Planet(
  name: "Corneeq",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const creuss = Planet(
  name: "Creuss",
  home: True,
  resources: 4,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const dal_bootha = Planet(
  name: "Dal Bootha",
  home: False,
  resources: 0,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const darien = Planet(
  name: "Darien",
  home: True,
  resources: 4,
  influence: 4,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const druaa = Planet(
  name: "Druaa",
  home: True,
  resources: 3,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const fria = Planet(
  name: "Fria",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const gral = Planet(
  name: "Gral",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Propulsion)],
  ground_units: [],
)

pub const hercant = Planet(
  name: "Hercant",
  home: True,
  resources: 1,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const jol = Planet(
  name: "Jol",
  home: True,
  resources: 1,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const jord = Planet(
  name: "Jord",
  home: True,
  resources: 4,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const kamdorn = Planet(
  name: "Kamdorn",
  home: True,
  resources: 0,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const lazar = Planet(
  name: "Lazar",
  home: False,
  resources: 1,
  influence: 0,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Cybernetic)],
  ground_units: [],
)

pub const lirta_iv = Planet(
  name: "Lirta IV",
  home: False,
  resources: 2,
  influence: 3,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const lisis_ii = Planet(
  name: "Lisis II",
  home: True,
  resources: 1,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const lodor = Planet(
  name: "Lodor",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const lor = Planet(
  name: "Lor",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
  ground_units: [],
)

pub const maaluuk = Planet(
  name: "Maaluuk",
  home: True,
  resources: 0,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const mecatol_rex = Planet(
  name: "Mecatol Rex",
  home: False,
  resources: 1,
  influence: 6,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const meer = Planet(
  name: "Meer",
  home: False,
  resources: 0,
  influence: 4,
  trait: Some(Hazardous),
  specialties: [TechSpecialty(Warfare)],
  ground_units: [],
)

pub const mehar_xull = Planet(
  name: "Mehar Xull",
  home: False,
  resources: 0,
  influence: 4,
  trait: Some(Hazardous),
  specialties: [TechSpecialty(Warfare)],
  ground_units: [],
)

pub const mellon = Planet(
  name: "Mellon",
  home: False,
  resources: 0,
  influence: 2,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const moll_primus = Planet(
  name: "Moll Primus",
  home: True,
  resources: 4,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const mordai_ii = Planet(
  name: "Mordai II",
  home: True,
  resources: 4,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const muaat = Planet(
  name: "Muaat",
  home: True,
  resources: 4,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const nar = Planet(
  name: "Nar",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const nestphar = Planet(
  name: "Nestphar",
  home: True,
  resources: 3,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const new_albion = Planet(
  name: "New Albion",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
  ground_units: [],
)

pub const quann = Planet(
  name: "Quann",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const qucenn = Planet(
  name: "Qucen'n",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
  ground_units: [],
)

pub const quinarra = Planet(
  name: "Quinarra",
  home: True,
  resources: 3,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const ragh = Planet(
  name: "Ragh",
  home: True,
  resources: 2,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const rarron = Planet(
  name: "Rarron",
  home: False,
  resources: 0,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const resculon = Planet(
  name: "Resculon",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const retillion = Planet(
  name: "Retillion",
  home: True,
  resources: 2,
  influence: 3,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const sakulag = Planet(
  name: "Sakulag",
  home: False,
  resources: 2,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const saudor = Planet(
  name: "Saudor",
  home: False,
  resources: 2,
  influence: 2,
  trait: Some(Industrial),
  specialties: [],
  ground_units: [],
)

pub const shalloq = Planet(
  name: "Shalloq",
  home: True,
  resources: 1,
  influence: 2,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const starpoint = Planet(
  name: "Starpoint",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const tarmann = Planet(
  name: "Tar'Mann",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Biotic)],
  ground_units: [],
)

pub const tequran = Planet(
  name: "Tequ'ran",
  home: False,
  resources: 2,
  influence: 0,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const thibah = Planet(
  name: "Thibah",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Propulsion)],
  ground_units: [],
)

pub const torkan = Planet(
  name: "Torkan",
  home: False,
  resources: 0,
  influence: 3,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const trenlak = Planet(
  name: "Tren'lak",
  home: True,
  resources: 1,
  influence: 0,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const vefut_ii = Planet(
  name: "Vefut II",
  home: False,
  resources: 2,
  influence: 2,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const wellon = Planet(
  name: "Wellon",
  home: False,
  resources: 1,
  influence: 2,
  trait: Some(Industrial),
  specialties: [TechSpecialty(Cybernetic)],
  ground_units: [],
)

pub const winnu = Planet(
  name: "Winnu",
  home: True,
  resources: 3,
  influence: 4,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const wren_terra = Planet(
  name: "Wren Terra",
  home: True,
  resources: 2,
  influence: 1,
  trait: None,
  specialties: [],
  ground_units: [],
)

pub const xxehan = Planet(
  name: "Xxehan",
  home: False,
  resources: 1,
  influence: 1,
  trait: Some(Cultural),
  specialties: [],
  ground_units: [],
)

pub const zohbat = Planet(
  name: "Zohbat",
  home: False,
  resources: 3,
  influence: 1,
  trait: Some(Hazardous),
  specialties: [],
  ground_units: [],
)

pub const all = [
  triplezero,
  abyz,
  arc_prime,
  archon_ren,
  archon_tau,
  arinam,
  arnor,
  arretze,
  bereg,
  centauri,
  corneeq,
  creuss,
  dal_bootha,
  darien,
  druaa,
  fria,
  gral,
  hercant,
  jol,
  jord,
  kamdorn,
  lazar,
  lirta_iv,
  lisis_ii,
  lodor,
  lor,
  maaluuk,
  mecatol_rex,
  meer,
  mehar_xull,
  mellon,
  moll_primus,
  mordai_ii,
  muaat,
  nar,
  nestphar,
  new_albion,
  quann,
  qucenn,
  quinarra,
  ragh,
  rarron,
  resculon,
  retillion,
  sakulag,
  saudor,
  shalloq,
  starpoint,
  tarmann,
  tequran,
  thibah,
  torkan,
  trenlak,
  vefut_ii,
  wellon,
  winnu,
  wren_terra,
  xxehan,
  zohbat,
]
