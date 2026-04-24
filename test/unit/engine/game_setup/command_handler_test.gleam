import core/models/command_token.{FleetPool, StrategyPool, TacticPool}
import core/models/common.{Green, Red}
import core/models/faction.{Arborec, Sol}
import core/models/game_setup.{Milty, Standard}
import core/models/objective.{SecretObjective}
import engine/game_setup/aggregate
import engine/game_setup/command_handler
import engine/game_setup/events.{
  GameCreated, PlayerAddedSecretObjective, PlayerGainedCommandTokens,
  PlayerJoined, PlayerStartingPlanetsSetup, PlayerStartingTechnologiesSetup,
  PlayerStartingUnitsSetup, SecretObjectivesDealt, SpeakerAppointed,
}
import game/technologies
import gleam/list

pub fn process_create_game_emits_game_created_test() {
  let cmd = aggregate.create_game(6, Standard)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  let assert GameCreated(_, 6, 10, Standard) = event
}

pub fn process_create_game_default_victory_points_test() {
  let cmd = aggregate.create_game(3, Milty)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  let assert GameCreated(_, _, victory_points, _) = event
  assert victory_points == 10
}

pub fn process_join_game_emits_player_joined_test() {
  let cmd = aggregate.join_game("game_1", "player_1", Green, Arborec)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert PlayerJoined("game_1", "player_1", Green, Arborec) == event
}

pub fn process_join_game_preserves_color_and_faction_test() {
  let cmd = aggregate.join_game("game_1", "player_2", Red, Sol)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert PlayerJoined("game_1", "player_2", Red, Sol) == event
}

pub fn process_add_secret_objective_to_player_emits_event_test() {
  let objective = SecretObjective("obj_42")
  let cmd =
    aggregate.add_secret_objective_to_player("game_1", "player_1", objective)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert PlayerAddedSecretObjective("game_1", "player_1", objective) == event
}

pub fn process_deal_secret_objectives_emits_dealt_event_test() {
  let objectives = [SecretObjective("obj_1"), SecretObjective("obj_2")]
  let assert Ok(cmd) =
    aggregate.deal_secret_objectives("game_1", "player_1", objectives)
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert SecretObjectivesDealt("game_1", "player_1", objectives) == event
}

pub fn process_appoint_speaker_emits_speaker_appointed_test() {
  let assert Ok(cmd) =
    aggregate.appoint_speaker("game_1", ["alice", "bob", "charlie"])
  let assert Ok(event) = command_handler.process(cmd) |> list.first()
  assert SpeakerAppointed("game_1", "alice") == event
}

pub fn process_setup_player_initial_components_emits_four_events_test() {
  let cmd =
    aggregate.setup_player_initial_components("game_1", "player_1", Arborec)
  let events = command_handler.process(cmd)
  assert list.length(events) == 4
}

pub fn process_setup_player_emits_command_tokens_event_test() {
  let cmd =
    aggregate.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(PlayerGainedCommandTokens("game_1", "player_1", tokens)) =
    command_handler.process(cmd)
    |> list.find(fn(e) {
      case e {
        PlayerGainedCommandTokens(..) -> True
        _ -> False
      }
    })
  assert list.contains(tokens, TacticPool(3))
  assert list.contains(tokens, FleetPool(3))
  assert list.contains(tokens, StrategyPool(2))
}

pub fn process_setup_player_emits_technologies_event_test() {
  let cmd =
    aggregate.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(PlayerStartingTechnologiesSetup("game_1", "player_1", techs)) =
    command_handler.process(cmd)
    |> list.find(fn(e) {
      case e {
        PlayerStartingTechnologiesSetup(..) -> True
        _ -> False
      }
    })
  assert list.contains(techs, technologies.magen_defense_grid)
}

pub fn process_setup_player_emits_units_event_test() {
  let cmd =
    aggregate.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(PlayerStartingUnitsSetup("game_1", "player_1", units)) =
    command_handler.process(cmd)
    |> list.find(fn(e) {
      case e {
        PlayerStartingUnitsSetup(..) -> True
        _ -> False
      }
    })
  assert units != []
}

pub fn process_setup_player_emits_planets_event_test() {
  let cmd =
    aggregate.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(PlayerStartingPlanetsSetup("game_1", "player_1", planets)) =
    command_handler.process(cmd)
    |> list.find(fn(e) {
      case e {
        PlayerStartingPlanetsSetup(..) -> True
        _ -> False
      }
    })
  assert planets != []
}
