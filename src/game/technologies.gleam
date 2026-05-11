import core/models/technology.{
  type Technology, Biotic, Cybernetic, PreReq, Propulsion, Technology,
  UnitUpgrade, Warfare,
}

import core/models/common.{Hit}
import core/models/unit
import gleam/list
import gleam/option.{None, Some}

pub const neural_motivator = Technology(
  name: "Neural Motivator",
  kind: Biotic,
  requirements: [],
)

pub const dacxive_animators = Technology(
  name: "Dacxive Animators",
  kind: Biotic,
  requirements: [PreReq(kind: Biotic, amount: 1)],
)

pub const hyper_metabolism = Technology(
  name: "Hyper Metabolism",
  kind: Biotic,
  requirements: [PreReq(kind: Biotic, amount: 2)],
)

pub const x89_bacterial_weapon = Technology(
  name: "X-89 Bacterial Weapon",
  kind: Biotic,
  requirements: [PreReq(kind: Biotic, amount: 3)],
)

pub const biotic = [
  neural_motivator, dacxive_animators, hyper_metabolism, x89_bacterial_weapon,
]

pub const plasma_scoring = Technology(
  name: "Plasma Scoring",
  kind: Warfare,
  requirements: [],
)

pub const magen_defense_grid = Technology(
  name: "Magen Defense Grid",
  kind: Warfare,
  requirements: [PreReq(kind: Warfare, amount: 1)],
)

pub const duranium_armor = Technology(
  name: "Duranium Armor",
  kind: Warfare,
  requirements: [PreReq(kind: Warfare, amount: 2)],
)

pub const assault_cannon = Technology(
  name: "Assault Cannon",
  kind: Warfare,
  requirements: [PreReq(kind: Warfare, amount: 3)],
)

pub const warfare = [
  plasma_scoring, magen_defense_grid, duranium_armor, assault_cannon,
]

pub const antimass_deflectors = Technology(
  name: "Antimass Deflectors",
  kind: Propulsion,
  requirements: [],
)

pub const gravity_drive = Technology(
  name: "Gravity Drive",
  kind: Propulsion,
  requirements: [PreReq(kind: Propulsion, amount: 1)],
)

pub const fleet_logistics = Technology(
  name: "Fleet Logistics",
  kind: Propulsion,
  requirements: [PreReq(kind: Propulsion, amount: 2)],
)

pub const light_wave_deflector = Technology(
  name: "Light Wave Deflector",
  kind: Propulsion,
  requirements: [PreReq(kind: Propulsion, amount: 3)],
)

pub const propulsion = [
  antimass_deflectors, gravity_drive, fleet_logistics, light_wave_deflector,
]

pub const sarween_tools = Technology(
  name: "Sarween Tools",
  kind: Cybernetic,
  requirements: [],
)

pub const graviton_laser_system = Technology(
  name: "Graviton Laser System",
  kind: Cybernetic,
  requirements: [PreReq(kind: Cybernetic, amount: 1)],
)

pub const transit_diodes = Technology(
  name: "Transit Diodes",
  kind: Cybernetic,
  requirements: [PreReq(kind: Cybernetic, amount: 2)],
)

pub const integrated_economy = Technology(
  name: "Integrated Economy",
  kind: Cybernetic,
  requirements: [PreReq(kind: Cybernetic, amount: 3)],
)

pub const cybernetic = [
  sarween_tools, graviton_laser_system, transit_diodes, integrated_economy,
]

pub const infantry_upgrade = UnitUpgrade(
  requirements: [PreReq(kind: Biotic, amount: 2)],
  unit: unit.GroundForce(
    unit.Infantry(
      name: "Infantry II",
      cost: 1,
      reference_amount: 2,
      abilities: [],
      combat: Hit(
        dice_amount: Some(1),
        hit_on: 7,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      ),
    ),
  ),
)

pub const destroyer_upgrade = UnitUpgrade(
  requirements: [PreReq(kind: Warfare, amount: 2)],
  unit: unit.ShipUnit(unit.Ship(
    name: "Destroyer II",
    class: unit.Major,
    cost: 1,
    movement: 2,
    abilities: [
      unit.AntiFighterBarrage(Hit(
        dice_amount: Some(3),
        hit_on: 6,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    ],
    combat: Hit(
      dice_amount: Some(1),
      hit_on: 8,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.Destroyer(capacity: 0),
  )),
)

pub const carrier_upgrade = UnitUpgrade(
  requirements: [PreReq(kind: Propulsion, amount: 2)],
  unit: unit.ShipUnit(unit.Ship(
    name: "Carrier II",
    class: unit.Major,
    cost: 3,
    movement: 2,
    abilities: [],
    combat: Hit(
      dice_amount: Some(1),
      hit_on: 9,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.Carrier(capacity: 6),
  )),
)

pub const space_dock_upgrade = UnitUpgrade(
  requirements: [PreReq(kind: Cybernetic, amount: 2)],
  unit: unit.Structure(
    unit.SpaceDock(
      name: "Space Dock II",
      abilities: [unit.Production(unit.BaseProduction(4))],
      capacity: 0,
      movement: 0,
    ),
  ),
)

pub const fighter_upgrade = UnitUpgrade(
  requirements: [
    PreReq(kind: Propulsion, amount: 1), PreReq(kind: Biotic, amount: 1),
  ],
  unit: unit.ShipUnit(unit.Ship(
    name: "Fighter II",
    class: unit.Minor,
    cost: 1,
    movement: 2,
    abilities: [],
    combat: Hit(
      dice_amount: Some(1),
      hit_on: 8,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.Fighter(capacity: 0, reference_amount: 2),
  )),
)

pub const pds_upgrade = UnitUpgrade(
  requirements: [
    PreReq(kind: Cybernetic, amount: 1), PreReq(kind: Warfare, amount: 1),
  ],
  unit: unit.Structure(
    unit.PDS(
      name: "PDS II",
      abilities: [
        unit.GivePlanetaryShield,
        unit.DeepSpaceCannon(Hit(
          dice_amount: Some(1),
          hit_on: 5,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ],
    ),
  ),
)

pub const cruiser_upgrade = UnitUpgrade(
  requirements: [
    PreReq(kind: Cybernetic, amount: 1), PreReq(kind: Warfare, amount: 1),
    PreReq(kind: Biotic, amount: 1),
  ],
  unit: unit.ShipUnit(unit.Ship(
    name: "Cruiser II",
    class: unit.Major,
    cost: 2,
    movement: 3,
    abilities: [],
    combat: Hit(
      dice_amount: Some(1),
      hit_on: 6,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.Cruiser(capacity: 1),
  )),
)

pub const dreadnought_upgrade = UnitUpgrade(
  requirements: [
    PreReq(kind: Cybernetic, amount: 1), PreReq(kind: Propulsion, amount: 2),
  ],
  unit: unit.ShipUnit(unit.Ship(
    name: "Dreadnought II",
    class: unit.Major,
    cost: 4,
    movement: 2,
    abilities: [
      unit.SustainDamage,
      unit.Bombardment(Hit(
        dice_amount: Some(1),
        hit_on: 5,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    ],
    combat: Hit(
      dice_amount: Some(1),
      hit_on: 5,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.Dreadnought(capacity: 1),
  )),
)

pub const war_sun_upgrade = UnitUpgrade(
  requirements: [
    PreReq(kind: Cybernetic, amount: 1), PreReq(kind: Warfare, amount: 3),
  ],
  unit: unit.ShipUnit(unit.Ship(
    name: "War Sun",
    class: unit.Major,
    cost: 12,
    movement: 2,
    abilities: [
      unit.SustainDamage,
      unit.Bombardment(Hit(
        dice_amount: Some(3),
        hit_on: 3,
        range: None,
        extra_dice: None,
        reroll_misses: False,
      )),
    ],
    combat: Hit(
      dice_amount: Some(3),
      hit_on: 3,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    ),
    kind: unit.WarSun(capacity: 6),
  )),
)

pub const unit_upgrades = [
  infantry_upgrade, fighter_upgrade, destroyer_upgrade, cruiser_upgrade,
  carrier_upgrade, dreadnought_upgrade, war_sun_upgrade, pds_upgrade,
  space_dock_upgrade,
]

pub fn get_all() -> List(Technology) {
  biotic
  |> list.append(cybernetic)
  |> list.append(propulsion)
  |> list.append(warfare)
  |> list.append(unit_upgrades)
}
