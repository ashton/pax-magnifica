import core/models/common.{Blue}
import core/models/faction.{Arborec, Hacan}
import core/models/game_setup.{Milty, Standard}
import core/models/objective.{SecretObjective}
import core/models/unit.{CarrierAmount, CruiserAmount, FighterAmount, InfantryAmount, PDSAmount, SpaceDockAmount}
import engine/game_setup/aggregate
import engine/game_setup/commands.{
  AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame, JoinGame,
  SetPlayerInitialComponents, StartGame,
}
import game/technologies
import gleam/list

pub fn validate_create_game_with_valid_data_test() {
  let cmd = commands.create_game(6, Standard)
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == cmd
}

pub fn validate_create_game_with_empty_id_test() {
  let cmd = CreateGame("", 6, Standard)
  let assert Error(err) = aggregate.validate_command(cmd)
  assert "Game id cannot be empty" == err
}

pub fn validate_create_game_below_min_players_test() {
  let cmd = CreateGame("game_1", 2, Standard)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_create_game_above_max_players_test() {
  let cmd = CreateGame("game_1", 7, Standard)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_create_game_with_min_players_test() {
  let cmd = CreateGame("game_1", 3, Standard)
  let assert Ok(_) = aggregate.validate_command(cmd)
}

pub fn validate_join_game_test() {
  let cmd = commands.join_game("game_1", "player_1", Blue, Hacan)
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == cmd
}

pub fn validate_join_game_with_empty_game_id_test() {
  let cmd = JoinGame("", "player_1", Blue, Hacan)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_join_game_with_empty_player_id_test() {
  let cmd = JoinGame("game_1", "", Blue, Hacan)
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_add_secret_objective_to_player_test() {
  let cmd =
    commands.add_secret_objective_to_player(
      "game_1",
      "player_1",
      SecretObjective("obj_1"),
    )
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == cmd
}

pub fn validate_add_secret_objective_to_player_with_empty_fields_test() {
  let cmd = AddSecretObjectiveToPlayer("", "player_1", SecretObjective("obj_1"))
  let assert Error(_) = aggregate.validate_command(cmd)
}

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

pub fn validate_start_game_test() {
  let cmd = commands.start_game()
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == StartGame
}

pub fn milty_setup_type_is_accepted_test() {
  let cmd = CreateGame("game_1", 4, Milty)
  let assert Ok(_) = aggregate.validate_command(cmd)
}

pub fn appoint_speaker_picks_first_player_test() {
  let assert Ok(cmd) =
    commands.appoint_speaker("game_1", ["alice", "bob", "charlie"])
  let assert AppointSpeaker("game_1", "alice") = cmd
}

pub fn validate_appoint_speaker_test() {
  let assert Ok(cmd) = commands.appoint_speaker("game_1", ["alice", "bob"])
  let assert Ok(result) = aggregate.validate_command(cmd)
  assert result == cmd
}

pub fn validate_appoint_speaker_with_empty_game_id_test() {
  let cmd = AppointSpeaker("", "alice")
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn validate_appoint_speaker_with_empty_player_id_test() {
  let cmd = AppointSpeaker("game_1", "")
  let assert Error(_) = aggregate.validate_command(cmd)
}

pub fn appoint_speaker_with_empty_players_returns_error_test() {
  let assert Error(_) = commands.appoint_speaker("game_1", [])
}

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
