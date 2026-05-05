import core/models/common.{Blue}
import core/models/faction.{Arborec, Hacan}
import core/models/game_setup.{Milty, Standard}
import core/models/objective.{SecretObjective}
import core/models/unit.{
  CarrierAmount, CruiserAmount, FighterAmount, InfantryAmount, PDSAmount,
  SpaceDockAmount,
}
import engine/game_setup/aggregate
import engine/game_setup/commands.{
  AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame, JoinGame,
  SetPlayerInitialComponents, StartGame,
}
import engine/game_setup/events.{
  GameCreated, PlayerAddedSecretObjective, PlayerGainedCommandTokens,
  PlayerJoined, PlayerStartingPlanetsSetup, PlayerStartingTechnologiesSetup,
  PlayerStartingUnitsSetup, SecretObjectivesDealt, SpeakerAppointed,
}
import game/technologies
import gleam/list

// ── CreateGame ────────────────────────────────────────────────────────────────

pub fn handle_create_game_emits_game_created_test() {
  let cmd = commands.create_game(6, Standard)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(GameCreated(_, 6, 10, Standard)) = list.first(events)
}

pub fn handle_create_game_default_victory_points_test() {
  let cmd = commands.create_game(3, Milty)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(GameCreated(_, _, victory_points, _)) = list.first(events)
  assert victory_points == 10
}

pub fn handle_create_game_empty_id_returns_error_test() {
  let cmd = CreateGame("", 6, Standard)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_create_game_below_min_players_returns_error_test() {
  let cmd = CreateGame("game_1", 2, Standard)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_create_game_above_max_players_returns_error_test() {
  let cmd = CreateGame("game_1", 7, Standard)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_create_game_min_players_succeeds_test() {
  let cmd = CreateGame("game_1", 3, Standard)
  let assert Ok(_) = aggregate.handle(cmd)
}

pub fn handle_create_game_milty_type_test() {
  let cmd = CreateGame("game_1", 4, Milty)
  let assert Ok(_) = aggregate.handle(cmd)
}

// ── JoinGame ──────────────────────────────────────────────────────────────────

pub fn handle_join_game_emits_player_joined_test() {
  let cmd = commands.join_game("game_1", "player_1", Blue, Hacan)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert PlayerJoined("game_1", "player_1", Blue, Hacan) == event
}

pub fn handle_join_game_empty_game_id_returns_error_test() {
  let cmd = JoinGame("", "player_1", Blue, Hacan)
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_join_game_empty_player_id_returns_error_test() {
  let cmd = JoinGame("game_1", "", Blue, Hacan)
  let assert Error(_) = aggregate.handle(cmd)
}

// ── AddSecretObjectiveToPlayer ────────────────────────────────────────────────

pub fn handle_add_secret_objective_emits_event_test() {
  let objective = SecretObjective("obj_42")
  let cmd =
    commands.add_secret_objective_to_player("game_1", "player_1", objective)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert PlayerAddedSecretObjective("game_1", "player_1", objective) == event
}

pub fn handle_add_secret_objective_empty_fields_returns_error_test() {
  let cmd = AddSecretObjectiveToPlayer("", "player_1", SecretObjective("obj_1"))
  let assert Error(_) = aggregate.handle(cmd)
}

// ── DealSecretObjectives ──────────────────────────────────────────────────────

pub fn deal_secret_objectives_returns_command_test() {
  let objectives = [SecretObjective("obj_1"), SecretObjective("obj_2")]
  let assert Ok(cmd) =
    commands.deal_secret_objectives("game_1", "player_1", objectives)
  let assert commands.DealSecretObjectives("game_1", "player_1", objs) = cmd
  assert objs == objectives
}

pub fn deal_secret_objectives_requires_exactly_two_test() {
  let assert Error(_) =
    commands.deal_secret_objectives("game_1", "player_1", [
      SecretObjective("obj_1"),
    ])
}

pub fn deal_secret_objectives_rejects_empty_list_test() {
  let assert Error(_) =
    commands.deal_secret_objectives("game_1", "player_1", [])
}

pub fn deal_secret_objectives_rejects_more_than_two_test() {
  let assert Error(_) =
    commands.deal_secret_objectives("game_1", "player_1", [
      SecretObjective("obj_1"),
      SecretObjective("obj_2"),
      SecretObjective("obj_3"),
    ])
}

pub fn handle_deal_secret_objectives_emits_event_test() {
  let objectives = [SecretObjective("obj_1"), SecretObjective("obj_2")]
  let assert Ok(cmd) =
    commands.deal_secret_objectives("game_1", "player_1", objectives)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert SecretObjectivesDealt("game_1", "player_1", objectives) == event
}

// ── AppointSpeaker ────────────────────────────────────────────────────────────

pub fn appoint_speaker_picks_first_player_test() {
  let assert Ok(cmd) =
    commands.appoint_speaker("game_1", ["alice", "bob", "charlie"])
  let assert AppointSpeaker("game_1", "alice") = cmd
}

pub fn appoint_speaker_with_empty_players_returns_error_test() {
  let assert Error(_) = commands.appoint_speaker("game_1", [])
}

pub fn handle_appoint_speaker_emits_event_test() {
  let assert Ok(cmd) =
    commands.appoint_speaker("game_1", ["alice", "bob", "charlie"])
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(event) = list.first(events)
  assert SpeakerAppointed("game_1", "alice") == event
}

pub fn handle_appoint_speaker_empty_game_id_returns_error_test() {
  let cmd = AppointSpeaker("", "alice")
  let assert Error(_) = aggregate.handle(cmd)
}

pub fn handle_appoint_speaker_empty_player_id_returns_error_test() {
  let cmd = AppointSpeaker("game_1", "")
  let assert Error(_) = aggregate.handle(cmd)
}

// ── SetPlayerInitialComponents ────────────────────────────────────────────────

pub fn setup_player_initial_components_resolves_arborec_technologies_test() {
  let assert SetPlayerInitialComponents(_, _, techs, _, _, _) =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  assert list.contains(techs, technologies.magen_defense_grid)
}

pub fn setup_player_initial_components_resolves_arborec_units_test() {
  let assert SetPlayerInitialComponents(_, _, _, units, _, _) =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  assert list.contains(units, CarrierAmount(1))
  assert list.contains(units, CruiserAmount(1))
  assert list.contains(units, FighterAmount(2))
  assert list.contains(units, InfantryAmount(4))
  assert list.contains(units, SpaceDockAmount(1))
  assert list.contains(units, PDSAmount(1))
}

pub fn setup_player_initial_components_carries_ids_test() {
  let assert SetPlayerInitialComponents("game_1", "player_1", _, _, _, _) =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
}

pub fn handle_setup_player_emits_four_events_test() {
  let cmd =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(events) = aggregate.handle(cmd)
  assert list.length(events) == 4
}

pub fn handle_setup_player_emits_command_tokens_event_test() {
  let cmd =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(PlayerGainedCommandTokens("game_1", "player_1", _)) =
    list.find(events, fn(e) {
      case e {
        PlayerGainedCommandTokens(..) -> True
        _ -> False
      }
    })
}

pub fn handle_setup_player_emits_technologies_event_test() {
  let cmd =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(PlayerStartingTechnologiesSetup("game_1", "player_1", techs)) =
    list.find(events, fn(e) {
      case e {
        PlayerStartingTechnologiesSetup(..) -> True
        _ -> False
      }
    })
  assert list.contains(techs, technologies.magen_defense_grid)
}

pub fn handle_setup_player_emits_units_event_test() {
  let cmd =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(PlayerStartingUnitsSetup("game_1", "player_1", units)) =
    list.find(events, fn(e) {
      case e {
        PlayerStartingUnitsSetup(..) -> True
        _ -> False
      }
    })
  assert units != []
}

pub fn handle_setup_player_emits_planets_event_test() {
  let cmd =
    commands.setup_player_initial_components("game_1", "player_1", Arborec)
  let assert Ok(events) = aggregate.handle(cmd)
  let assert Ok(PlayerStartingPlanetsSetup("game_1", "player_1", planets)) =
    list.find(events, fn(e) {
      case e {
        PlayerStartingPlanetsSetup(..) -> True
        _ -> False
      }
    })
  assert planets != []
}

// ── StartGame ─────────────────────────────────────────────────────────────────

pub fn handle_start_game_returns_empty_events_test() {
  let cmd = commands.start_game()
  let assert Ok(events) = aggregate.handle(cmd)
  let assert StartGame = cmd
  assert events == []
}
