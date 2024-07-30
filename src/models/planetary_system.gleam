import gleam/option.{type Option}
import models/technology.{type TechnologyType}

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
  )
}

pub type System {
  HomeSystem(planets: List(Planet), wormholes: List(WormHole))
  PlanetarySystem(planets: List(Planet), wormholes: List(WormHole))
  AnomalySystem(kind: Anomaly, wormholes: List(WormHole))
  EmptySystem
}
