import core/models/common.{type Hit}

pub type ProductionUnit {
  BaseProduction(Int)
  TotalProduction(Int)
}

pub type Ability {
  Bombardment(Hit)
  AntiFighterBarrage(Hit)
  SpaceCannon(Hit)
  DeepSpaceCannon(Hit)
  SustainDamage
  GivePlanetaryShield
  DisablePlanetaryShield
  Production(ProductionUnit)
}

pub type UnitClass {
  Major
  Minor
}

pub type UnitKind {
  FighterKind
  InfantryKind
  CarrierKind
  DestroyerKind
  CruiserKind
  DreadnoughtKind
  WarSunKind
  FlagshipKind
  PDSKind
  SpaceDockKind
}

pub type Structure {
  SpaceDock(
    name: String,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  PDS(name: String, abilities: List(Ability))
}

pub type Ship {
  FlagShip(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  WarSun(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  Cruiser(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  Dreadnought(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  Destroyer(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    abilities: List(Ability),
  )
  Carrier(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  Fighter(
    name: String,
    class: UnitClass,
    cost: Int,
    movement: Int,
    reference_amount: Int,
    combat: Hit,
  )
}

pub type GroundForce {
  Infantry(
    name: String,
    cost: Int,
    reference_amount: Int,
    combat: Hit,
    abilities: List(Ability),
  )
}

pub type Unit {
  Ship(Ship)
  GroundForce(GroundForce)
  Structure(Structure)
}

pub type UnitAmount {
  FlagshipAmount(Int)
  WarSunAmount(Int)
  CruiserAmount(Int)
  DreadnoughtAmount(Int)
  DestroyerAmount(Int)
  CarrierAmount(Int)
  FighterAmount(Int)
  InfantryAmount(Int)
  PDSAmount(Int)
  SpaceDockAmount(Int)
}
