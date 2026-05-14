import core/models/command_token.{
  type CommandTokenPool, FleetPool, StrategyPool, TacticPool,
}
import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}
import core/models/objective.{type SecretObjective}
import core/models/planetary_system.{type Planet}
import core/models/technology.{type Technology}
import core/models/unit.{type UnitAmount}
import game/factions
import gleam/list
import utils/uuid

pub type GameSetupCommand {
  CreateGame(game_id: String, player_count: Int, setup_type: GameSetupType)

  JoinGame(
    game_id: String,
    player_id: String,
    color: Color,
    faction: FactionIdentifier,
  )

  AppointSpeaker(game_id: String, player_id: String)

  SetPlayerInitialComponents(
    game_id: String,
    player_id: String,
    starting_technologies: List(Technology),
    starting_units: List(UnitAmount),
    starting_planets: List(Planet),
    starting_command_tokens: List(CommandTokenPool),
  )

  DealSecretObjectives(
    game_id: String,
    player_id: String,
    objectives: List(SecretObjective),
  )
  AddSecretObjectiveToPlayer(
    game_id: String,
    player_id: String,
    objective: SecretObjective,
  )
  StartGame
  //TODO Map and players setup
  //StandardDraftCommand(StandardDraftCommand)
  //MiltyDraftCommand(StandardDraftCommand)
}

pub fn create_game(player_count: Int, setup_type: GameSetupType) {
  CreateGame(uuid.new(), player_count, setup_type)
}

pub fn join_game(
  game_id: String,
  player_id: String,
  color: Color,
  faction: FactionIdentifier,
) {
  JoinGame(game_id, player_id, color, faction)
}

pub fn add_secret_objective_to_player(
  game_id: String,
  player_id: String,
  objective: SecretObjective,
) {
  AddSecretObjectiveToPlayer(game_id, player_id, objective)
}

pub fn deal_secret_objectives(
  game_id: String,
  player_id: String,
  objectives: List(SecretObjective),
) -> Result(GameSetupCommand, String) {
  case list.length(objectives) == 2 {
    True -> Ok(DealSecretObjectives(game_id, player_id, objectives))
    False -> Error("Exactly 2 secret objectives must be dealt to a player")
  }
}

pub fn start_game() {
  StartGame
}

pub fn appoint_speaker(
  game_id: String,
  players: List(String),
) -> Result(GameSetupCommand, String) {
  case list.first(players) {
    Ok(player_id) -> Ok(AppointSpeaker(game_id, player_id))
    Error(_) -> Error("Cannot appoint speaker: player list is empty")
  }
}

pub fn setup_player_initial_components(
  game_id: String,
  player_id: String,
  faction_identifier: FactionIdentifier,
) -> GameSetupCommand {
  let faction_data = factions.make(faction_identifier).data
  SetPlayerInitialComponents(
    game_id: game_id,
    player_id: player_id,
    starting_technologies: faction_data.starting_technologies,
    starting_units: faction_data.starting_units,
    starting_planets: faction_data.starting_planets,
    starting_command_tokens: [TacticPool(3), FleetPool(3), StrategyPool(2)],
  )
}
