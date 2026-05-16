import core/models/planetary_system.{Cultural, Hazardous, Industrial}
import core/models/state/planets.{
  type OwnedPlanet, Exhausted, OwnedPlanet, PlanetsState, Ready,
}
import engine/action_cards/events as action_cards_events
import engine/effects/action_cards/economic_initiative
import engine/effects/types.{DispatchCommand, NoEffect}
import engine/game/commands.{PlanetsCommand}
import engine/game/entity.{GameEntity}
import engine/planets/commands as planets_commands
import game/action_cards.{EconomicInitiative}
import gleam/dict
import gleam/list
import gleam/option.{None, Some}
import unitest

pub fn readies_exhausted_cultural_planets_test() {
  use <- unitest.tags(["unit", "effects", "economic_initiative"])
  let entity =
    entity_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
      OwnedPlanet("Lirma IV", "alice", Exhausted, Some(Cultural), 2, 3),
    ])
  let event =
    action_cards_events.CardPlayed("game_1", "alice", EconomicInitiative)
  let assert DispatchCommand(PlanetsCommand(planets_commands.ReadyPlanets(
    "game_1",
    "alice",
    planet_names,
  ))) = economic_initiative.execute(entity, event)
  let assert True = list.contains(planet_names, "Bereg")
  let assert True = list.contains(planet_names, "Lirma IV")
  let assert 2 = list.length(planet_names)
}

pub fn no_effect_when_no_cultural_planets_test() {
  use <- unitest.tags(["unit", "effects", "economic_initiative"])
  let entity =
    entity_with_planets([
      OwnedPlanet("Lodor", "alice", Exhausted, Some(Industrial), 3, 1),
    ])
  let event =
    action_cards_events.CardPlayed("game_1", "alice", EconomicInitiative)
  let assert NoEffect = economic_initiative.execute(entity, event)
}

pub fn skips_ready_cultural_planets_test() {
  use <- unitest.tags(["unit", "effects", "economic_initiative"])
  let entity =
    entity_with_planets([
      OwnedPlanet("Bereg", "alice", Ready, Some(Cultural), 3, 1),
    ])
  let event =
    action_cards_events.CardPlayed("game_1", "alice", EconomicInitiative)
  let assert NoEffect = economic_initiative.execute(entity, event)
}

pub fn skips_other_players_planets_test() {
  use <- unitest.tags(["unit", "effects", "economic_initiative"])
  let entity =
    entity_with_planets([
      OwnedPlanet("Bereg", "bob", Exhausted, Some(Cultural), 3, 1),
    ])
  let event =
    action_cards_events.CardPlayed("game_1", "alice", EconomicInitiative)
  let assert NoEffect = economic_initiative.execute(entity, event)
}

pub fn filters_mixed_planets_correctly_test() {
  use <- unitest.tags(["unit", "effects", "economic_initiative"])
  let entity =
    entity_with_planets([
      OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
      OwnedPlanet("Lodor", "alice", Exhausted, Some(Industrial), 3, 1),
      OwnedPlanet("Primor", "alice", Exhausted, Some(Hazardous), 2, 1),
      OwnedPlanet("Lirma IV", "alice", Ready, Some(Cultural), 2, 3),
      OwnedPlanet("Arinam", "bob", Exhausted, Some(Cultural), 1, 2),
      OwnedPlanet("Meer", "alice", Exhausted, None, 0, 4),
    ])
  let event =
    action_cards_events.CardPlayed("game_1", "alice", EconomicInitiative)
  let assert DispatchCommand(PlanetsCommand(planets_commands.ReadyPlanets(
    "game_1",
    "alice",
    planet_names,
  ))) = economic_initiative.execute(entity, event)
  let assert [_] = planet_names
  let assert True = list.contains(planet_names, "Bereg")
}

fn entity_with_planets(owned: List(OwnedPlanet)) -> entity.GameEntity {
  let planets =
    owned
    |> list.map(fn(p) { #(p.name, p) })
    |> dict.from_list()
  GameEntity(..entity.initial(), planets: PlanetsState(planets:))
}
