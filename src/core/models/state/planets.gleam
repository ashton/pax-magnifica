import core/models/planetary_system.{type Trait}
import gleam/dict.{type Dict}
import gleam/option.{type Option}

pub type PlanetStatus {
  Ready
  Exhausted
}

pub type OwnedPlanet {
  OwnedPlanet(
    name: String,
    owner: String,
    status: PlanetStatus,
    trait: Option(Trait),
    resources: Int,
    influence: Int,
  )
}

pub type PlanetsState {
  PlanetsState(planets: Dict(String, OwnedPlanet))
}

pub fn initial() -> PlanetsState {
  PlanetsState(planets: dict.new())
}
