import core/models/command_token.{type CommandTokenPool}
import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}
import core/models/objective.{type SecretObjective}
import core/models/planetary_system.{type Planet}
import core/models/technology.{type Technology}
import core/models/unit.{type UnitAmount}

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
