import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game_setup.{type GameSetupType}

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
  FrontierTokensPlaced(game_id: String, token_locations: List(String))
  SystemTilePlaced(game_id: String, tile_id: String, location: String)
  GalaxyBuildCompleted(game_id: String)
  InitialComponentsSetup(game_id: String)

  SecretObjectivesChosen(
    game_id: String,
    player_id: String,
    objective_id: String,
  )

  PublicObjectivesRevealed(game_id: String, objectives: List(String))
  GameSetupCompleted(game_id: String)
  GameStarted(game_id: String, players: List(String), game_board: String)
}
