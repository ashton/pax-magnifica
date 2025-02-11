import core/models/technology.{type TechnologyType}
import core/models/unit.{type Unit}
import gleam/option.{type Option}

pub type SystemColorCode {
  Red
  Blue
  Green
}

pub type Trait {
  Cultural
  Hazardous
  Industrial
}

pub type WormHole {
  Alpha
  Beta
  Gama
  Delta
}

pub type Anomaly {
  AsteroidField
  Nebula
  Supernova
  GravityRift
}

pub type Specialty {
  TechSpecialty(TechnologyType)
}

pub type Planet {
  Planet(
    name: String,
    home: Bool,
    resources: Int,
    influence: Int,
    trait: Option(Trait),
    specialties: List(Specialty),
    ground_units: List(Unit),
  )
}

pub type SystemTrait {
  MecatolRex
  HomeSystem
  PlanetarySystem
  AnomalySystem(kind: Anomaly)
  EmptySystem
}

pub type System {
  System(
    units: List(Unit),
    planets: List(Planet),
    wormholes: List(WormHole),
    color: SystemColorCode,
    trait: SystemTrait,
  )
}
