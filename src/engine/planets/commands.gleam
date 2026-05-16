import core/models/state/planets.{type OwnedPlanet}

pub type PlanetsCommand {
  AssignPlanets(game_id: String, planets: List(OwnedPlanet))
  ReadyPlanets(game_id: String, player_id: String, planet_names: List(String))
}
