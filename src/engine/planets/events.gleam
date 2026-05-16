import core/models/state/planets.{type OwnedPlanet}

pub type PlanetsEvent {
  PlanetsAssigned(game_id: String, planets: List(OwnedPlanet))
  PlanetReadied(game_id: String, planet_name: String)
}
