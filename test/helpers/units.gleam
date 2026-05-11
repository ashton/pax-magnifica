import core/models/common.{Hit}
import core/models/unit
import gleam/option.{None, Some}

pub fn carrier(movement m: Int, capacity c: Int) -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Carrier",
    class: unit.Major,
    cost: 3,
    combat: Hit(dice_amount: Some(1), hit_on: 9, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Carrier(capacity: c),
  ))
}

pub fn cruiser(movement m: Int) -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Cruiser",
    class: unit.Major,
    cost: 2,
    combat: Hit(dice_amount: Some(1), hit_on: 7, range: None, extra_dice: None, reroll_misses: False),
    movement: m,
    abilities: [],
    kind: unit.Cruiser(capacity: 0),
  ))
}

pub fn fighter() -> unit.Unit {
  unit.ShipUnit(unit.Ship(
    name: "Fighter",
    class: unit.Minor,
    cost: 1,
    combat: Hit(dice_amount: Some(1), hit_on: 9, range: None, extra_dice: None, reroll_misses: False),
    movement: 0,
    abilities: [],
    kind: unit.Fighter(capacity: 0, reference_amount: 2),
  ))
}

pub fn infantry() -> unit.Unit {
  unit.GroundForce(unit.Infantry(
    name: "Infantry",
    cost: 1,
    reference_amount: 2,
    combat: Hit(dice_amount: Some(1), hit_on: 8, range: None, extra_dice: None, reroll_misses: False),
    abilities: [],
  ))
}

pub fn pds() -> unit.Unit {
  unit.Structure(unit.PDS(name: "PDS", abilities: []))
}
