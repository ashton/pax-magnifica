import core/models/command_token.{FleetPool, StrategyPool, TacticPool}
import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}
import core/models/objective.{type SecretObjective}
import engine/game_setup/commands.{
  type GameSetupCommand, AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame,
  DealSecretObjectives, JoinGame, SetPlayerInitialComponents, StartGame,
}
import game/factions
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import utils/uuid

pub fn create_game(player_count: Int, setup_type: GameSetupType) {
  commands.CreateGame(uuid.new(), player_count, setup_type)
}

pub fn join_game(
  game_id: String,
  player_id: String,
  color: Color,
  faction: FactionIdentifier,
) {
  commands.JoinGame(game_id, player_id, color, faction)
}

pub fn add_secret_objective_to_player(
  game_id: String,
  player_id: String,
  objective: SecretObjective,
) {
  commands.AddSecretObjectiveToPlayer(game_id, player_id, objective)
}

pub fn deal_secret_objectives(
  game_id: String,
  player_id: String,
  objectives: List(SecretObjective),
) -> Result(GameSetupCommand, String) {
  case list.length(objectives) == 2 {
    True -> Ok(commands.DealSecretObjectives(game_id, player_id, objectives))
    False -> Error("Exactly 2 secret objectives must be dealt to a player")
  }
}

pub fn start_game() {
  commands.StartGame
}

pub fn appoint_speaker(
  game_id: String,
  players: List(String),
) -> Result(GameSetupCommand, String) {
  case list.first(players) {
    Ok(player_id) -> Ok(commands.AppointSpeaker(game_id, player_id))
    Error(_) -> Error("Cannot appoint speaker: player list is empty")
  }
}

pub fn setup_player_initial_components(
  game_id: String,
  player_id: String,
  faction_identifier: FactionIdentifier,
) -> GameSetupCommand {
  let faction_data = factions.make(faction_identifier).data
  commands.SetPlayerInitialComponents(
    game_id: game_id,
    player_id: player_id,
    starting_technologies: faction_data.starting_technologies,
    starting_units: faction_data.starting_units,
    starting_planets: faction_data.starting_planets,
    starting_command_tokens: [TacticPool(3), FleetPool(3), StrategyPool(2)],
  )
}

fn validate_player_count(player_count: Int) -> Result(Int, String) {
  case player_count >= 3, player_count <= 6 {
    True, True -> Ok(player_count)
    _, _ ->
      Error(
        "Invalid player count: "
        <> int.to_string(player_count)
        <> ". A game should have 3 players minimum and 6 players maximum.",
      )
  }
}

pub fn validate_command(
  command: GameSetupCommand,
) -> Result(GameSetupCommand, String) {
  case command {
    CreateGame(game_id, player_count, _) ->
      case string.is_empty(game_id) {
        True -> Error("Game id cannot be empty")
        False ->
          validate_player_count(player_count)
          |> result.replace(command)
      }

    JoinGame(game_id, player_id, _, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    AddSecretObjectiveToPlayer(game_id, player_id, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    DealSecretObjectives(game_id, player_id, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    AppointSpeaker(game_id, player_id) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    SetPlayerInitialComponents(game_id, player_id, _, _, _, _) ->
      case string.is_empty(game_id) || string.is_empty(player_id) {
        True -> Error("Game id and player id cannot be empty")
        False -> Ok(command)
      }

    StartGame -> Ok(command)
  }
}
