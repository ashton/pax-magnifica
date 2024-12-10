import core/models/unit.{type Unit}

pub type TechnologyType {
  Biotic
  Propulsion
  Cybernetic
  Warfare
}

pub type PreReq {
  PreReq(kind: TechnologyType, amount: Int)
}

pub type Technology {
  Technology(name: String, kind: TechnologyType, requirements: List(PreReq))
  UnitUpgrade(requirements: List(PreReq), unit: Unit)
}
