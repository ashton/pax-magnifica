import core/models/common.{type Hit, Hit}
import core/models/unit
import gleam/option.{type Option, None, Some}
import utils/option_utils.{or}

pub fn make_fighter(
  name name: Option(String),
  cost cost: Option(Int),
  amount_produced amount_produced: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("Fighter I"),
    class: unit.Minor,
    cost: cost |> or(1),
    movement: movement |> or(0),
    abilities: [],
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 9,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    kind: unit.Fighter(capacity: 0, reference_amount: amount_produced |> or(2)),
  )
}

pub fn make_dreadnought(
  name name: Option(String),
  cost cost: Option(Int),
  capacity capacity: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
  abilities abilities: Option(List(unit.Ability)),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("Dreadnought I"),
    class: unit.Major,
    cost: cost |> or(4),
    movement: movement |> or(1),
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 5,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    abilities: abilities
      |> or([
        unit.SustainDamage,
        unit.Bombardment(Hit(
          dice_amount: Some(1),
          hit_on: 5,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ]),
    kind: unit.Dreadnought(capacity: capacity |> or(1)),
  )
}

pub fn make_destroyer(
  name name: Option(String),
  cost cost: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("Destroyer I"),
    class: unit.Major,
    cost: cost |> or(1),
    movement: movement |> or(2),
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 9,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    abilities: [
      unit.AntiFighterBarrage(Hit(
        dice_amount: Some(2),
        hit_on: 9,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    ],
    kind: unit.Destroyer(capacity: 0),
  )
}

pub fn make_cruiser(
  name name: Option(String),
  cost cost: Option(Int),
  capacity capacity: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("Cruiser I"),
    class: unit.Major,
    cost: cost |> or(2),
    movement: movement |> or(2),
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 7,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    abilities: [],
    kind: unit.Cruiser(capacity: capacity |> or(0)),
  )
}

pub fn make_carrier(
  name name: Option(String),
  cost cost: Option(Int),
  capacity capacity: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
  abilities abilities: List(unit.Ability),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("Carrier I"),
    class: unit.Major,
    cost: cost |> or(3),
    movement: movement |> or(1),
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 9,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    abilities: abilities,
    kind: unit.Carrier(capacity: capacity |> or(4)),
  )
}

pub fn make_war_sun(
  name name: Option(String),
  cost cost: Option(Int),
  capacity capacity: Option(Int),
  movement movement: Option(Int),
  combat combat: Option(Hit),
  abilities abilities: Option(List(unit.Ability)),
) -> unit.Ship {
  unit.Ship(
    name: name |> or("War Sun"),
    class: unit.Major,
    cost: cost |> or(12),
    movement: movement |> or(2),
    combat: combat
      |> or(Hit(
        dice_amount: Some(3),
        hit_on: 3,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
    abilities: abilities
      |> or([
        unit.DisablePlanetaryShield,
        unit.SustainDamage,
        unit.Bombardment(Hit(
          dice_amount: Some(3),
          hit_on: 3,
          extra_dice: None,
          range: None,
          reroll_misses: False,
        )),
      ]),
    kind: unit.WarSun(capacity: capacity |> or(6)),
  )
}

pub fn make_infantry(
  name name: Option(String),
  cost cost: Option(Int),
  amount_produced amount_produced: Option(Int),
  abilities abilities: List(unit.Ability),
  combat combat: Option(Hit),
) -> unit.GroundForce {
  unit.Infantry(
    name: name |> or("Infantry I"),
    cost: cost |> or(1),
    reference_amount: amount_produced |> or(2),
    abilities: abilities,
    combat: combat
      |> or(Hit(
        dice_amount: Some(1),
        hit_on: 8,
        extra_dice: None,
        range: None,
        reroll_misses: False,
      )),
  )
}

pub fn make_space_dock(
  name name: Option(String),
  movement movement: Option(Int),
  capacity capacity: Option(Int),
  production base_production: Option(unit.ProductionUnit),
) -> unit.Structure {
  unit.SpaceDock(
    name: name |> or("Space Dock"),
    capacity: capacity |> or(0),
    movement: movement |> or(0),
    abilities: [unit.Production(base_production |> or(unit.BaseProduction(2)))],
  )
}

pub fn make_pds(name name: Option(String)) -> unit.Structure {
  unit.PDS(name: name |> or("PDS"), abilities: [
    unit.GivePlanetaryShield,
    unit.SpaceCannon(Hit(
      dice_amount: Some(1),
      hit_on: 6,
      extra_dice: None,
      range: None,
      reroll_misses: False,
    )),
  ])
}
