import core/models/planetary_system.{Cultural}
import core/models/state/planets.{
  type OwnedPlanet, type PlanetsState, Exhausted, OwnedPlanet, PlanetsState,
  Ready,
}
import engine/planets/aggregate
import engine/planets/commands
import engine/planets/events
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import unitest

pub fn ready_planets_readies_exhausted_cultural_planets_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
      OwnedPlanet("Lirma IV", "alice", Exhausted, Some(Cultural), 2, 3),
    ])
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Bereg", "Lirma IV"])
  let assert Ok([
    events.PlanetReadied("game_1", "Bereg"),
    events.PlanetReadied("game_1", "Lirma IV"),
  ]) = aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_single_planet_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
    ])
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Bereg"])
  let assert Ok([events.PlanetReadied("game_1", "Bereg")]) =
    aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_fails_when_planet_not_found_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state = planets.initial()
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Nonexistent"])
  let assert Error(_) = aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_fails_when_not_owned_by_player_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "bob", Exhausted, Some(Cultural), 3, 1),
    ])
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Bereg"])
  let assert Error(_) = aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_fails_when_already_ready_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Ready, Some(Cultural), 3, 1),
    ])
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Bereg"])
  let assert Error(_) = aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_works_for_non_cultural_planets_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state =
    state_with_planets([
      OwnedPlanet("Mecatol Rex", "alice", Exhausted, None, 1, 6),
    ])
  let cmd = commands.ReadyPlanets("game_1", "alice", ["Mecatol Rex"])
  let assert Ok([events.PlanetReadied("game_1", "Mecatol Rex")]) =
    aggregate.handle_ready(state, cmd)
}

pub fn ready_planets_fails_on_empty_list_test() {
  use <- unitest.tags(["unit", "planets", "aggregate"])
  let state = planets.initial()
  let cmd = commands.ReadyPlanets("game_1", "alice", [])
  let assert Error(_) = aggregate.handle_ready(state, cmd)
}

fn state_with_planets(owned: List(OwnedPlanet)) -> PlanetsState {
  let planets =
    owned
    |> list.map(fn(p) { #(p.name, p) })
    |> dict.from_list()
  PlanetsState(planets:)
}
