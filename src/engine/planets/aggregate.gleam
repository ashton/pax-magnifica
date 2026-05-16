import core/models/state/planets.{
  type OwnedPlanet, type PlanetsState, Exhausted, OwnedPlanet, PlanetsState,
  Ready,
}
import engine/planets/commands.{type PlanetsCommand, AssignPlanets, ReadyPlanets}
import engine/planets/events.{type PlanetsEvent, PlanetReadied, PlanetsAssigned}
import gleam/dict
import gleam/list
import gleam/option
import gleam/result

pub fn handle_assign(
  command: PlanetsCommand,
) -> Result(List(PlanetsEvent), String) {
  let assert AssignPlanets(game_id, planets) = command
  case planets {
    [] -> Error("No planets to assign")
    _ -> Ok([PlanetsAssigned(game_id, planets)])
  }
}

pub fn handle_ready(
  state: PlanetsState,
  command: PlanetsCommand,
) -> Result(List(PlanetsEvent), String) {
  let assert ReadyPlanets(game_id, player_id, planet_names) = command
  case planet_names {
    [] -> Error("No planets specified")
    _ -> {
      use validated <- result.try(
        list.try_map(planet_names, validate_planet(state, player_id, _)),
      )
      Ok(list.map(validated, fn(name) { PlanetReadied(game_id, name) }))
    }
  }
}

fn validate_planet(
  state: PlanetsState,
  player_id: String,
  planet_name: String,
) -> Result(String, String) {
  use planet <- result.try(
    dict.get(state.planets, planet_name)
    |> result.replace_error("Planet not found: " <> planet_name),
  )
  use _ <- result.try(validate_owner(planet, player_id))
  use _ <- result.try(validate_exhausted(planet))
  Ok(planet_name)
}

fn validate_owner(planet: OwnedPlanet, player_id: String) -> Result(Nil, String) {
  case planet.owner == player_id {
    True -> Ok(Nil)
    False -> Error("Planet " <> planet.name <> " is not owned by player")
  }
}

fn validate_exhausted(planet: OwnedPlanet) -> Result(Nil, String) {
  case planet.status {
    Exhausted -> Ok(Nil)
    Ready -> Error("Planet " <> planet.name <> " is already ready")
  }
}

pub fn apply(state: PlanetsState, event: PlanetsEvent) -> PlanetsState {
  case event {
    PlanetsAssigned(_, planets) -> {
      let new_planets =
        list.fold(planets, state.planets, fn(acc, planet) {
          dict.insert(acc, planet.name, planet)
        })
      PlanetsState(planets: new_planets)
    }
    PlanetReadied(_, planet_name) -> {
      let planets =
        dict.upsert(state.planets, planet_name, fn(existing) {
          case existing {
            option.Some(planet) -> OwnedPlanet(..planet, status: Ready)
            option.None -> panic as "PlanetReadied for unknown planet"
          }
        })
      PlanetsState(planets:)
    }
  }
}
