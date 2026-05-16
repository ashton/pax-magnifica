import core/models/planetary_system.{Cultural, Industrial}
import core/models/state/planets.{Exhausted, OwnedPlanet, Ready}
import engine/action_cards/commands as action_cards_commands
import engine/action_cards/events as action_cards_events
import engine/game/commands.{ActionCardsCommand, PlanetsCommand}
import engine/game/events.{ActionCardsEvent}
import engine/planets/commands as planets_commands
import engine/setup
import eventsourcing
import game/action_cards.{EconomicInitiative} as _cards
import gleam/dict
import gleam/erlang/process
import gleam/list
import gleam/option.{Some}
import unitest

pub fn full_economic_initiative_flow_test() {
  use <- unitest.tags(["integration", "economic_initiative"])
  let es = setup.start()
  let game_id = "game_1"
  let player_id = "alice"

  let bereg = OwnedPlanet("Bereg", player_id, Exhausted, Some(Cultural), 3, 1)
  let lirma =
    OwnedPlanet("Lirma IV", player_id, Exhausted, Some(Cultural), 2, 3)
  let lodor = OwnedPlanet("Lodor", player_id, Exhausted, Some(Industrial), 3, 1)

  // 1. Assign planets
  let r1 =
    eventsourcing.execute_with_response(
      es,
      game_id,
      PlanetsCommand(
        planets_commands.AssignPlanets(game_id, [bereg, lirma, lodor]),
      ),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r1, 1000)

  // 2. Give player the EconomicInitiative card
  let r2 =
    eventsourcing.execute_with_response(
      es,
      game_id,
      ActionCardsCommand(action_cards_commands.draw_card(
        game_id,
        player_id,
        EconomicInitiative,
      )),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r2, 1000)

  // 3. Play the card
  let r3 =
    eventsourcing.execute_with_response(
      es,
      game_id,
      ActionCardsCommand(action_cards_commands.play_card(
        game_id,
        player_id,
        EconomicInitiative,
      )),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r3, 1000)

  // 4. Wait for the reactor to process all effects
  process.sleep(200)

  // 5. Load aggregate and verify cultural planets are Ready
  let subject = eventsourcing.load_aggregate(es, game_id)
  let assert Ok(Ok(agg)) = process.receive(subject, 1000)
  let planets = agg.entity.planets.planets

  let assert Ok(bereg_state) = dict.get(planets, "Bereg")
  let assert Ready = bereg_state.status

  let assert Ok(lirma_state) = dict.get(planets, "Lirma IV")
  let assert Ready = lirma_state.status

  // Industrial planet should still be exhausted
  let assert Ok(lodor_state) = dict.get(planets, "Lodor")
  let assert Exhausted = lodor_state.status

  // 6. Verify pending effects are cleared (CardEffectsResolved was processed)
  let assert [] = agg.entity.action_cards.pending_effects

  // 7. Verify CardEffectsResolved event is in the event store
  let events_subject = eventsourcing.load_events(es, game_id)
  let assert Ok(Ok(all_events)) = process.receive(events_subject, 1000)
  let has_resolved =
    list.any(all_events, fn(envelope) {
      case envelope.payload {
        ActionCardsEvent(action_cards_events.CardEffectsResolved(
          _,
          "alice",
          EconomicInitiative,
        )) -> True
        _ -> False
      }
    })
  let assert True = has_resolved
}
