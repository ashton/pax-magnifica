import core/models/game_setup.{
  type GameSetup, GameSetup, Lobby, PreparingGame, SetupComplete,
}
import engine/game_setup/events.{
  type GameSetupEvent, GameCreated, GameSetupCompleted, GameStarted,
  GalaxyBuildCompleted, PlayerAddedSecretObjective, PlayerGainedCommandTokens,
  PlayerJoined, PlayerStartingPlanetsSetup, PlayerStartingTechnologiesSetup,
  PlayerStartingUnitsSetup, PublicObjectivesRevealed, SecretObjectivesDealt,
  SpeakerAppointed, SystemTilePlaced,
}
import gleam/list
import gleam/option.{type Option, Some}

pub fn apply(state: Option(GameSetup), event: GameSetupEvent) -> Option(GameSetup) {
  case event {
    GameCreated(game_id, player_count, _, _) ->
      Some(GameSetup(
        game_id: game_id,
        player_count: player_count,
        players: [],
        initial_speaker: "",
        map: "",
        phase: Lobby,
      ))

    PlayerJoined(_, player_id, _, _) ->
      option.map(state, fn(gs) {
        GameSetup(..gs, players: list.append(gs.players, [player_id]))
      })

    SpeakerAppointed(_, player_id) ->
      option.map(state, fn(gs) { GameSetup(..gs, initial_speaker: player_id) })

    GalaxyBuildCompleted(_) ->
      option.map(state, fn(gs) { GameSetup(..gs, phase: PreparingGame) })

    GameSetupCompleted(_) | GameStarted(_, _, _) ->
      option.map(state, fn(gs) { GameSetup(..gs, phase: SetupComplete) })

    SystemTilePlaced(_, _, _)
    | PlayerStartingTechnologiesSetup(_, _, _)
    | PlayerStartingUnitsSetup(_, _, _)
    | PlayerStartingPlanetsSetup(_, _, _)
    | PlayerGainedCommandTokens(_, _, _)
    | SecretObjectivesDealt(_, _, _)
    | PlayerAddedSecretObjective(_, _, _)
    | PublicObjectivesRevealed(_, _) -> state
  }
}
