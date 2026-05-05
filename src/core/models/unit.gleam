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

pub type ShipKind {
  FlagShip(capacity: Int)
  WarSun(capacity: Int)
  Cruiser(capacity: Int)
  Dreadnought(capacity: Int)
  Destroyer
  Carrier(capacity: Int)
  Fighter(reference_amount: Int)
}

pub type Ship {
  Ship(
    name: String,
    class: UnitClass,
    cost: Int,
    combat: Hit,
    movement: Int,
    abilities: List(Ability),
    kind: ShipKind,
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

pub type Structure {
  SpaceDock(
    name: String,
    movement: Int,
    capacity: Int,
    abilities: List(Ability),
  )
  PDS(name: String, abilities: List(Ability))
}

pub type Unit {
  ShipUnit(Ship)
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
