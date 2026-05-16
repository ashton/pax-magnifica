import core/models/planetary_system.{Cultural}
import core/models/state/planets.{Exhausted, OwnedPlanet, PlanetsState}
import engine/action_cards/events as action_cards_events
import engine/effects/reactor
import engine/effects/types.{DispatchCommand, NoEffect}
import engine/game/commands.{PlanetsCommand}
import engine/game/entity
import engine/game/events.{ActionCardsEvent}
import engine/planets/commands as planets_commands
import game/action_cards.{EconomicInitiative, Sabotage}
import gleam/dict
import gleam/list
import gleam/option.{Some}
import unitest

pub fn dispatches_economic_initiative_effect_test() {
  use <- unitest.tags(["unit", "effects", "reactor"])
  let entity =
    entity.GameEntity(
      ..entity.initial(),
      planets: PlanetsState(
        planets: dict.from_list([
          #(
            "Bereg",
            OwnedPlanet("Bereg", "alice", Exhausted, Some(Cultural), 3, 1),
          ),
        ]),
      ),
    )
  let event =
    ActionCardsEvent(action_cards_events.CardPlayed(
      "game_1",
      "alice",
      EconomicInitiative,
    ))
  let assert DispatchCommand(PlanetsCommand(planets_commands.ReadyPlanets(
    "game_1",
    "alice",
    planet_names,
  ))) = reactor.dispatch_effect(entity, event)
  let assert True = list.contains(planet_names, "Bereg")
}

pub fn returns_no_effect_for_unknown_card_test() {
  use <- unitest.tags(["unit", "effects", "reactor"])
  let entity = entity.initial()
  let event =
    ActionCardsEvent(action_cards_events.CardPlayed("game_1", "alice", Sabotage))
  let assert NoEffect = reactor.dispatch_effect(entity, event)
}

pub fn returns_no_effect_for_non_card_events_test() {
  use <- unitest.tags(["unit", "effects", "reactor"])
  let entity = entity.initial()
  let event =
    ActionCardsEvent(action_cards_events.CardDrawn(
      "game_1",
      "alice",
      EconomicInitiative,
    ))
  let assert NoEffect = reactor.dispatch_effect(entity, event)
}
