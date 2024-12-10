import core/models/common.{
  type Color, Black, Blue, Green, Hit, Orange, Purple, Red, Yellow,
}
import core/models/faction
import core/models/planetary_system.{type Planet, type System}
import core/models/technology.{
  type Technology, Biotic, Cybernetic, PreReq, Propulsion, Technology,
  UnitUpgrade, Warfare,
}
import core/models/unit.{
  type UnitAmount, CarrierAmount, CruiserAmount, DestroyerAmount,
  DreadnoughtAmount, FighterAmount, InfantryAmount, PDSAmount, SpaceDockAmount,
  WarSunAmount,
}
import game/planets
import game/systems
import game/technologies
import game/units
import gleam/list
import gleam/option.{None, Some}

fn make_faction_data(
  name name: String,
  commodities commodities: Int,
  starting_units starting_units: List(UnitAmount),
  starting_technologies techs: List(Technology),
  starting_planets planets: List(Planet),
  suggested_colors colors: List(Color),
  faction_technologies custom_techs: List(Technology),
) -> faction.FactionData {
  let fighter =
    units.make_fighter(
      name: None,
      combat: None,
      cost: None,
      movement: None,
      amount_produced: None,
    )
  let carrier =
    units.make_carrier(
      name: None,
      combat: None,
      cost: None,
      movement: None,
      capacity: None,
      abilities: [],
    )

  let cruiser =
    units.make_cruiser(
      name: None,
      combat: None,
      cost: None,
      movement: None,
      capacity: None,
    )
  let destroyer =
    units.make_destroyer(name: None, combat: None, cost: None, movement: None)

  let dreadnough =
    units.make_dreadnought(
      name: None,
      combat: None,
      cost: None,
      movement: None,
      capacity: None,
      abilities: None,
    )

  faction.FactionData(
    name: name,
    suggested_colors: colors,
    commodities: commodities,
    ships: [fighter, carrier, cruiser, destroyer, dreadnough],
    ground_forces: [
      units.make_infantry(
        name: None,
        cost: None,
        amount_produced: None,
        combat: None,
        abilities: [],
      ),
    ],
    starting_technologies: techs,
    starting_units: starting_units,
    starting_planets: planets,
    structures: [
      units.make_space_dock(
        name: None,
        production: None,
        capacity: None,
        movement: None,
      ),
      units.make_pds(name: None),
    ],
    faction_technologies: custom_techs,
  )
}

pub fn make_arborec() -> faction.Faction {
  let custom_infantry =
    units.make_infantry(
      name: Some("Letani Warrior I"),
      abilities: [unit.Production(unit.TotalProduction(1))],
      cost: None,
      amount_produced: None,
      combat: None,
    )

  let upgraded_infantry =
    units.make_infantry(
      name: Some("Letani Warrior II"),
      abilities: [unit.Production(unit.TotalProduction(2))],
      cost: None,
      amount_produced: None,
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 7,
        range: None,
        extra_dice: None,
        reroll_misses: False,
      )),
    )

  let data =
    make_faction_data(
      name: "The Arborec",
      commodities: 3,
      suggested_colors: [Green],
      starting_technologies: [technologies.magen_defense_grid],
      starting_planets: [planets.nestphar],
      faction_technologies: [
        Technology(name: "Bioplasmosis", kind: Biotic, requirements: [
          PreReq(kind: Biotic, amount: 2),
        ]),
        UnitUpgrade(
          requirements: [PreReq(kind: Biotic, amount: 2)],
          unit: upgraded_infantry |> unit.GroundForce,
        ),
      ],
      starting_units: [
        CarrierAmount(1),
        CruiserAmount(1),
        FighterAmount(2),
        InfantryAmount(4),
        SpaceDockAmount(1),
        PDSAmount(1),
      ],
    )

  faction.FactionData(..data, ground_forces: [custom_infantry])
  |> faction.ArborecFaction
}

pub fn make_letnev() -> faction.Faction {
  make_faction_data(
    name: "The Barony of Letnev",
    commodities: 2,
    suggested_colors: [Red, Black],
    starting_technologies: [
      technologies.antimass_deflectors,
      technologies.plasma_scoring,
    ],
    starting_planets: [planets.arc_prime, planets.wren_terra],
    faction_technologies: [
      Technology(name: "L4 Disruptors", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 1),
      ]),
      Technology(name: "Non-Euclidean Shielding", kind: Warfare, requirements: [
        PreReq(kind: Warfare, amount: 2),
      ]),
    ],
    starting_units: [
      DreadnoughtAmount(1),
      CarrierAmount(1),
      DestroyerAmount(1),
      FighterAmount(1),
      InfantryAmount(3),
      SpaceDockAmount(1),
    ],
  )
  |> faction.LetnevFaction
}

pub fn make_saar() -> faction.Faction {
  let custom_space_dock =
    units.make_space_dock(
      name: Some("Floating Factory I"),
      capacity: Some(4),
      movement: Some(1),
      production: Some(unit.TotalProduction(5)),
    )

  let custom_upgraded_space_dock =
    units.make_space_dock(
      name: Some("Floating Factory II"),
      capacity: Some(5),
      movement: Some(2),
      production: Some(unit.TotalProduction(7)),
    )

  let pds = units.make_pds(name: None)

  let data =
    make_faction_data(
      name: "The Clan of Saar",
      commodities: 3,
      suggested_colors: [Orange, Green, Yellow],
      starting_technologies: [technologies.antimass_deflectors],
      starting_planets: [planets.lisis_ii, planets.ragh],
      faction_technologies: [
        Technology(name: "Chaos Mapping", kind: Propulsion, requirements: [
          PreReq(kind: Propulsion, amount: 1),
        ]),
        UnitUpgrade(
          requirements: [PreReq(amount: 2, kind: Cybernetic)],
          unit: custom_upgraded_space_dock |> unit.Structure,
        ),
      ],
      starting_units: [
        DreadnoughtAmount(1),
        CarrierAmount(1),
        DestroyerAmount(1),
        FighterAmount(1),
        InfantryAmount(3),
        SpaceDockAmount(1),
      ],
    )

  faction.FactionData(..data, structures: [custom_space_dock, pds])
  |> faction.SaarFaction
}

pub fn make_muaat() -> faction.Faction {
  let custom_war_sun =
    units.make_war_sun(
      name: Some("Prototype War Sun I"),
      movement: Some(1),
      capacity: None,
      combat: None,
      cost: None,
      abilities: None,
    )

  let custom_upgraded_war_sun =
    units.make_war_sun(
      name: Some("Prototype War Sun II"),
      movement: Some(3),
      capacity: None,
      combat: None,
      cost: Some(10),
      abilities: None,
    )
  let data =
    make_faction_data(
      name: "The Embers of Muaat",
      commodities: 4,
      suggested_colors: [Red, Orange],
      starting_technologies: [technologies.plasma_scoring],
      starting_planets: [planets.muaat],
      faction_technologies: [
        Technology(name: "Magmus Reactor", kind: Warfare, requirements: [
          PreReq(kind: Warfare, amount: 2),
        ]),
        UnitUpgrade(
          requirements: [
            PreReq(kind: Warfare, amount: 3),
            PreReq(kind: Cybernetic, amount: 1),
          ],
          unit: custom_upgraded_war_sun |> unit.Ship,
        ),
      ],
      starting_units: [
        WarSunAmount(1),
        FighterAmount(2),
        InfantryAmount(4),
        SpaceDockAmount(1),
      ],
    )
  faction.FactionData(
    ..data,
    ships: data.ships |> list.append([custom_war_sun]),
  )
  |> faction.MuaatFaction
}

pub fn make_hacan() -> faction.Faction {
  make_faction_data(
    name: "The Emirates of Hacan",
    commodities: 6,
    suggested_colors: [Orange, Yellow],
    starting_technologies: [
      technologies.antimass_deflectors,
      technologies.sarween_tools,
    ],
    starting_planets: [planets.arretze, planets.hercant, planets.kamdorn],
    faction_technologies: [
      Technology(name: "Production Biomes", kind: Biotic, requirements: [
        PreReq(kind: Biotic, amount: 2),
      ]),
      Technology(name: "Quantum Datahub Node", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 3),
      ]),
    ],
    starting_units: [
      CarrierAmount(2),
      CruiserAmount(1),
      FighterAmount(2),
      InfantryAmount(4),
      SpaceDockAmount(1),
    ],
  )
  |> faction.HacanFaction
}

pub fn make_sol() -> faction.Faction {
  let custom_infantry =
    units.make_infantry(
      name: Some("Spec Ops I"),
      amount_produced: None,
      cost: None,
      abilities: [],
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 7,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    )

  let custom_upgraded_infantry =
    units.make_infantry(
      name: Some("Spec Ops II"),
      amount_produced: None,
      cost: None,
      abilities: [],
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 6,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    )

  let custom_carrier =
    units.make_carrier(
      name: Some("Advanced Carrier I"),
      capacity: Some(6),
      movement: None,
      combat: None,
      cost: None,
      abilities: [],
    )

  let custom_upgraded_carrier =
    units.make_carrier(
      name: Some("Advanced Carrier II"),
      capacity: Some(8),
      movement: Some(2),
      combat: None,
      cost: None,
      abilities: [unit.SustainDamage],
    )

  let data =
    make_faction_data(
      name: "The Federation of Sol",
      commodities: 4,
      suggested_colors: [Blue, Yellow],
      starting_technologies: [
        technologies.antimass_deflectors,
        technologies.neural_motivator,
      ],
      starting_planets: [planets.jord],
      faction_technologies: [
        UnitUpgrade(
          requirements: [PreReq(kind: Biotic, amount: 2)],
          unit: custom_upgraded_infantry |> unit.GroundForce,
        ),
        UnitUpgrade(
          requirements: [PreReq(kind: Propulsion, amount: 2)],
          unit: custom_upgraded_carrier |> unit.Ship,
        ),
      ],
      starting_units: [
        CarrierAmount(2),
        DestroyerAmount(1),
        FighterAmount(3),
        InfantryAmount(5),
        SpaceDockAmount(1),
      ],
    )

  let ships =
    data.ships
    |> list.map(fn(item) {
      case item {
        unit.Carrier(..) -> custom_carrier
        _ -> item
      }
    })

  faction.FactionData(..data, ground_forces: [custom_infantry], ships: ships)
  |> faction.SolFaction
}

pub fn make_creuss() -> faction.Faction {
  make_faction_data(
    name: "The Ghosts of Creuss",
    commodities: 4,
    suggested_colors: [Blue],
    starting_technologies: [technologies.gravity_drive],
    starting_planets: [planets.creuss],
    faction_technologies: [
      Technology(name: "Wormhole Generator", kind: Biotic, requirements: [
        PreReq(kind: Propulsion, amount: 2),
      ]),
      Technology(name: "Dimensional Splicer", kind: Warfare, requirements: [
        PreReq(kind: Warfare, amount: 1),
      ]),
    ],
    starting_units: [
      CarrierAmount(1),
      DestroyerAmount(2),
      FighterAmount(2),
      InfantryAmount(4),
      SpaceDockAmount(1),
    ],
  )
  |> faction.CreussFaction
}

pub fn make_lizix() -> faction.Faction {
  let custom_dreadnought =
    units.make_dreadnought(
      name: Some("Super-Dreadnought I"),
      cost: None,
      combat: None,
      movement: None,
      capacity: Some(2),
      abilities: None,
    )

  let custom_upgraded_dreadnought =
    units.make_dreadnought(
      name: Some("Super-Dreadnought II"),
      cost: None,
      movement: Some(2),
      capacity: Some(2),
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 4,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
      abilities: Some([
        unit.SustainDamage,
        unit.Bombardment(Hit(
          dice_amount: Some(1),
          hit_on: 4,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ]),
    )

  let data =
    make_faction_data(
      name: "The L1Z1X Mindnet",
      commodities: 2,
      suggested_colors: [Black, Blue, Red],
      starting_technologies: [
        technologies.neural_motivator,
        technologies.plasma_scoring,
      ],
      starting_planets: [planets.triplezero],
      faction_technologies: [
        Technology(name: "Inheritance Systems", kind: Cybernetic, requirements: [
          PreReq(kind: Cybernetic, amount: 2),
        ]),
        UnitUpgrade(
          requirements: [
            PreReq(kind: Propulsion, amount: 2),
            PreReq(kind: Cybernetic, amount: 1),
          ],
          unit: custom_upgraded_dreadnought |> unit.Ship,
        ),
      ],
      starting_units: [
        DreadnoughtAmount(1),
        CarrierAmount(1),
        FighterAmount(3),
        InfantryAmount(5),
        SpaceDockAmount(1),
        PDSAmount(1),
      ],
    )

  let ships =
    data.ships
    |> list.map(fn(item) {
      case item {
        unit.Dreadnought(..) -> custom_dreadnought
        _ -> item
      }
    })

  faction.FactionData(..data, ships: ships)
  |> faction.LizixFaction
}

pub fn make_mentak() -> faction.Faction {
  make_faction_data(
    name: "The Mentak Coalition",
    commodities: 2,
    suggested_colors: [Orange, Black, Yellow],
    starting_technologies: [
      technologies.sarween_tools,
      technologies.plasma_scoring,
    ],
    starting_planets: [planets.moll_primus],
    faction_technologies: [
      Technology(name: "Salvage Operations", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 2),
      ]),
      Technology(name: "Mirror Computing", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 3),
      ]),
    ],
    starting_units: [
      CarrierAmount(1),
      CruiserAmount(2),
      FighterAmount(3),
      InfantryAmount(4),
      SpaceDockAmount(1),
      PDSAmount(1),
    ],
  )
  |> faction.MentakFaction
}

pub fn make_naalu() -> faction.Faction {
  let custom_fighter =
    units.make_fighter(
      name: Some("Hybrid Crystal Fighter I"),
      cost: None,
      amount_produced: None,
      movement: None,
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 8,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    )

  let custom_upgraded_fighter =
    units.make_fighter(
      name: Some("Hybrid Crystal Fighter II"),
      cost: None,
      amount_produced: None,
      movement: Some(2),
      combat: Some(Hit(
        dice_amount: Some(1),
        hit_on: 7,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    )

  let data =
    make_faction_data(
      name: "The Naalu Collective",
      commodities: 3,
      suggested_colors: [Green, Yellow, Orange],
      starting_technologies: [
        technologies.sarween_tools,
        technologies.neural_motivator,
      ],
      starting_planets: [planets.maaluuk, planets.druaa],
      faction_technologies: [
        Technology(name: "Neuroglaive", kind: Biotic, requirements: [
          PreReq(kind: Biotic, amount: 2),
        ]),
        UnitUpgrade(
          requirements: [
            PreReq(kind: Biotic, amount: 1),
            PreReq(kind: Propulsion, amount: 1),
          ],
          unit: custom_upgraded_fighter |> unit.Ship,
        ),
      ],
      starting_units: [
        CarrierAmount(1),
        CruiserAmount(1),
        DestroyerAmount(1),
        FighterAmount(3),
        InfantryAmount(4),
        SpaceDockAmount(1),
        PDSAmount(1),
      ],
    )

  let ships =
    data.ships
    |> list.map(fn(item) {
      case item {
        unit.Fighter(..) -> custom_fighter
        _ -> item
      }
    })

  faction.FactionData(..data, ships: ships)
  |> faction.NaaluFaction
}

pub fn make_nekro() -> faction.Faction {
  make_faction_data(
    name: "The Nekro Virus",
    commodities: 3,
    suggested_colors: [Red],
    starting_technologies: [technologies.dacxive_animators],
    starting_planets: [planets.mordai_ii],
    faction_technologies: [],
    starting_units: [
      DreadnoughtAmount(1),
      CarrierAmount(1),
      CruiserAmount(1),
      FighterAmount(2),
      InfantryAmount(2),
      SpaceDockAmount(1),
    ],
  )
  |> faction.NekroFaction
}

pub fn make_sardakk() -> faction.Faction {
  let custom_dreadnought =
    units.make_dreadnought(
      name: Some("Exotrireme I"),
      movement: None,
      cost: None,
      capacity: None,
      combat: None,
      abilities: Some([
        unit.SustainDamage,
        unit.Bombardment(Hit(
          dice_amount: Some(2),
          hit_on: 4,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ]),
    )

  let custom_upgraded_dreadnought =
    units.make_dreadnought(
      name: Some("Exotrireme II"),
      movement: Some(2),
      cost: None,
      capacity: None,
      combat: None,
      abilities: Some([
        unit.SustainDamage,
        unit.Bombardment(Hit(
          dice_amount: Some(2),
          hit_on: 4,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ]),
    )

  let data =
    make_faction_data(
      name: "Sardakk N'orr",
      commodities: 3,
      suggested_colors: [Red, Black],
      starting_technologies: [],
      starting_planets: [planets.trenlak, planets.quinarra],
      faction_technologies: [
        Technology(
          name: "Valkyrie Particle Weave",
          kind: Warfare,
          requirements: [PreReq(kind: Warfare, amount: 2)],
        ),
        UnitUpgrade(
          requirements: [
            PreReq(kind: Propulsion, amount: 2),
            PreReq(kind: Cybernetic, amount: 1),
          ],
          unit: custom_upgraded_dreadnought |> unit.Ship,
        ),
      ],
      starting_units: [
        CarrierAmount(2),
        CruiserAmount(1),
        InfantryAmount(5),
        SpaceDockAmount(1),
        PDSAmount(1),
      ],
    )

  let ships =
    data.ships
    |> list.map(fn(item) {
      case item {
        unit.Dreadnought(..) -> custom_dreadnought
        _ -> item
      }
    })

  faction.FactionData(..data, ships: ships)
  |> faction.SardakkFaction
}

pub fn make_jol_nar() -> faction.Faction {
  make_faction_data(
    name: "The Universities of Jol-Nar",
    commodities: 6,
    suggested_colors: [Blue, Purple],
    starting_technologies: [
      technologies.neural_motivator,
      technologies.antimass_deflectors,
      technologies.sarween_tools,
      technologies.plasma_scoring,
    ],
    starting_planets: [planets.jol, planets.nar],
    faction_technologies: [
      Technology(name: "E-Res Siphons", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 2),
      ]),
      Technology(
        name: "Spatial Conduit Cylinder",
        kind: Propulsion,
        requirements: [PreReq(kind: Propulsion, amount: 2)],
      ),
    ],
    starting_units: [
      DreadnoughtAmount(1),
      CarrierAmount(2),
      FighterAmount(1),
      InfantryAmount(2),
      SpaceDockAmount(1),
      PDSAmount(1),
    ],
  )
  |> faction.JolNarFaction
}

pub fn make_winnu() -> faction.Faction {
  make_faction_data(
    name: "The Winnu",
    commodities: 3,
    suggested_colors: [Orange, Yellow, Purple],
    starting_technologies: [],
    //choose 1 with no pre-req
    starting_planets: [planets.winnu],
    faction_technologies: [
      Technology(name: "Lazax Gate Folding", kind: Propulsion, requirements: [
        PreReq(kind: Propulsion, amount: 2),
      ]),
      Technology(
        name: "Hegemonic Trade Policy",
        kind: Cybernetic,
        requirements: [PreReq(kind: Cybernetic, amount: 3)],
      ),
    ],
    starting_units: [
      CarrierAmount(1),
      CruiserAmount(1),
      FighterAmount(2),
      InfantryAmount(2),
      SpaceDockAmount(1),
      PDSAmount(1),
    ],
  )
  |> faction.WinnuFaction
}

pub fn make_xxcha() -> faction.Faction {
  make_faction_data(
    name: "The Xxcha Kingdom",
    commodities: 4,
    suggested_colors: [Green, Blue],
    starting_technologies: [technologies.graviton_laser_system],
    starting_planets: [planets.archon_ren, planets.archon_tau],
    faction_technologies: [
      Technology(name: "Nullification Field", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 2),
      ]),
      Technology(name: "Instinct Training", kind: Biotic, requirements: [
        PreReq(kind: Biotic, amount: 1),
      ]),
    ],
    starting_units: [
      CarrierAmount(1),
      CruiserAmount(2),
      FighterAmount(3),
      InfantryAmount(4),
      SpaceDockAmount(1),
      PDSAmount(1),
    ],
  )
  |> faction.XxchaFaction
}

pub fn make_yin() -> faction.Faction {
  make_faction_data(
    name: "The Yin Brotherhood",
    commodities: 2,
    suggested_colors: [Purple, Black, Yellow],
    starting_technologies: [technologies.sarween_tools],
    starting_planets: [planets.darien],
    faction_technologies: [
      Technology(name: "Impulse Core", kind: Cybernetic, requirements: [
        PreReq(kind: Cybernetic, amount: 2),
      ]),
      Technology(name: "Yin Spinner", kind: Biotic, requirements: [
        PreReq(kind: Biotic, amount: 2),
      ]),
    ],
    starting_units: [
      CarrierAmount(2),
      DestroyerAmount(1),
      FighterAmount(4),
      InfantryAmount(4),
      SpaceDockAmount(1),
    ],
  )
  |> faction.YinFaction
}

pub fn make_yssaril() -> faction.Faction {
  make_faction_data(
    name: "The Yssaril Tribes",
    commodities: 3,
    suggested_colors: [Green, Yellow],
    starting_technologies: [technologies.neural_motivator],
    starting_planets: [planets.retillion, planets.shalloq],
    faction_technologies: [
      Technology(name: "Transparasteel Plating", kind: Biotic, requirements: [
        PreReq(kind: Biotic, amount: 1),
      ]),
      Technology(name: "Mageon Implants", kind: Biotic, requirements: [
        PreReq(kind: Biotic, amount: 2),
      ]),
    ],
    starting_units: [
      CarrierAmount(2),
      DestroyerAmount(1),
      FighterAmount(4),
      InfantryAmount(4),
      SpaceDockAmount(1),
    ],
  )
  |> faction.YssarilFaction
}

pub const all: List(faction.FactionIdentifier) = [
  faction.Arborec, faction.Creuss, faction.Hacan, faction.JolNar, faction.Letnev,
  faction.Lizix, faction.Mentak, faction.Muaat, faction.Naalu, faction.Nekro,
  faction.Saar, faction.Sardakk, faction.Sol, faction.Winnu, faction.Xxcha,
  faction.Yin, faction.Yssaril,
]

pub fn make(identifier: faction.FactionIdentifier) -> faction.Faction {
  case identifier {
    faction.Arborec -> make_arborec()
    faction.Creuss -> make_creuss()
    faction.Hacan -> make_hacan()
    faction.JolNar -> make_jol_nar()
    faction.Letnev -> make_letnev()
    faction.Lizix -> make_lizix()
    faction.Mentak -> make_mentak()
    faction.Muaat -> make_muaat()
    faction.Naalu -> make_naalu()
    faction.Nekro -> make_nekro()
    faction.Saar -> make_saar()
    faction.Sardakk -> make_sardakk()
    faction.Sol -> make_sol()
    faction.Winnu -> make_winnu()
    faction.Xxcha -> make_xxcha()
    faction.Yin -> make_yin()
    faction.Yssaril -> make_yssaril()
  }
}

pub fn home_system(identifier: faction.FactionIdentifier) -> System {
  case identifier {
    faction.Arborec -> systems.arborec_home_system
    faction.Creuss -> systems.creuss_home_system
    faction.Hacan -> systems.hacan_home_system
    faction.JolNar -> systems.jol_nar_home_system
    faction.Letnev -> systems.letnev_home_system
    faction.Lizix -> systems.lizix_home_system
    faction.Mentak -> systems.mentak_home_system
    faction.Muaat -> systems.muaat_home_system
    faction.Naalu -> systems.naalu_home_system
    faction.Nekro -> systems.nekro_home_system
    faction.Saar -> systems.saar_home_system
    faction.Sardakk -> systems.sardakk_home_system
    faction.Sol -> systems.sol_home_system
    faction.Winnu -> systems.winnu_home_system
    faction.Xxcha -> systems.xxcha_home_system
    faction.Yin -> systems.yin_home_system
    faction.Yssaril -> systems.yssaril_home_system
  }
}
