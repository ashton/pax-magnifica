import core/models/planetary_system.{Cultural}
import core/models/state/planets.{
  type OwnedPlanet, type PlanetsState, Exhausted, OwnedPlanet, PlanetsState,
  Ready,
}
import engine/planets/aggregate
import engine/planets/events
import gleam/dict
import gleam/list
import gleam/option.{Some}
import unitest

pub fn apply_planet_readied_sets_status_to_ready_test() {
  use <- unitest.tags(["unit", "planets", "state_fold"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
    ])
  let event = events.PlanetReadied("game_1", "Bereg")
  let updated = aggregate.apply(state, event)
  let assert Ok(planet) = dict.get(updated.planets, "Bereg")
  let assert Ready = planet.status
}

pub fn apply_planet_readied_preserves_other_fields_test() {
  use <- unitest.tags(["unit", "planets", "state_fold"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
    ])
  let event = events.PlanetReadied("game_1", "Bereg")
  let updated = aggregate.apply(state, event)
  let assert Ok(planet) = dict.get(updated.planets, "Bereg")
  let assert "alice" = planet.owner
  let assert Some(Cultural) = planet.trait
  let assert 3 = planet.resources
  let assert 1 = planet.influence
}

pub fn apply_planet_readied_does_not_affect_other_planets_test() {
  use <- unitest.tags(["unit", "planets", "state_fold"])
  let state =
    state_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
      OwnedPlanet("Lirma IV", "alice", Exhausted, Some(Cultural), 2, 3),
    ])
  let event = events.PlanetReadied("game_1", "Bereg")
  let updated = aggregate.apply(state, event)
  let assert Ok(lirma) = dict.get(updated.planets, "Lirma IV")
  let assert Exhausted = lirma.status
}

fn state_with_planets(owned: List(OwnedPlanet)) -> PlanetsState {
  let planets =
    owned
    |> list.map(fn(p) { #(p.name, p) })
    |> dict.from_list()
  PlanetsState(planets:)
}
