import core/models/command_token.{type CommandTokenPool}
import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}
import core/models/objective.{type SecretObjective}
import core/models/planetary_system.{type Planet}
import core/models/technology.{type Technology}
import core/models/unit.{type UnitAmount}

pub type GameSetupEvent {
  GameCreated(
    game_id: String,
    player_count: Int,
    victory_points: Int,
    setup_type: GameSetupType,
  )

  PlayerJoined(
    game_id: String,
    player_id: String,
    color: Color,
    faction: FactionIdentifier,
  )

  SpeakerAppointed(game_id: String, player_id: String)
  SystemTilePlaced(game_id: String, tile_id: String, location: String)
  GalaxyBuildCompleted(game_id: String)

  PlayerStartingTechnologiesSetup(
    game_id: String,
    player_id: String,
    technologies: List(Technology),
  )

  PlayerStartingUnitsSetup(
    game_id: String,
    player_id: String,
    units: List(UnitAmount),
  )

  PlayerStartingPlanetsSetup(
    game_id: String,
    player_id: String,
    planets: List(Planet),
  )

  PlayerGainedCommandTokens(
    game_id: String,
    player_id: String,
    tokens: List(CommandTokenPool),
  )

  SecretObjectivesDealt(
    game_id: String,
    player_id: String,
    objectives: List(SecretObjective),
  )

  PlayerAddedSecretObjective(
    game_id: String,
    player_id: String,
    objective: SecretObjective,
  )

  PublicObjectivesRevealed(game_id: String, objectives: List(String))
  GameSetupCompleted(game_id: String)
  GameStarted(game_id: String, players: List(String), game_board: String)
}
