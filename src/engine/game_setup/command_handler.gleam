import engine/game_setup/commands.{
  type GameSetupCommand, AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame,
  DealSecretObjectives, JoinGame, SetPlayerInitialComponents, StartGame,
}
import engine/game_setup/events.{
  type GameSetupEvent, PlayerGainedCommandTokens,
}

const default_victory_points = 10

pub fn process(command: GameSetupCommand) -> List(GameSetupEvent) {
  case command {
    CreateGame(game_id, player_count, setup_type) -> [
      events.GameCreated(game_id, player_count, default_victory_points, setup_type),
    ]

    JoinGame(game_id, player_id, color, faction) -> [
      events.PlayerJoined(game_id, player_id, color, faction),
    ]

    DealSecretObjectives(game_id, player_id, objectives) -> [
      events.SecretObjectivesDealt(game_id, player_id, objectives),
    ]

    AddSecretObjectiveToPlayer(game_id, player_id, objective) -> [
      events.PlayerAddedSecretObjective(game_id, player_id, objective),
    ]

    AppointSpeaker(game_id, player_id) -> [
      events.SpeakerAppointed(game_id, player_id),
    ]

    SetPlayerInitialComponents(
      game_id,
      player_id,
      techs,
      units,
      starting_planets,
      starting_command_tokens,
    ) -> [
      events.PlayerStartingTechnologiesSetup(game_id, player_id, techs),
      events.PlayerStartingUnitsSetup(game_id, player_id, units),
      events.PlayerStartingPlanetsSetup(game_id, player_id, starting_planets),
      PlayerGainedCommandTokens(game_id, player_id, starting_command_tokens),
    ]

    // StartGame requires additional context (players list, board) not yet
    // available in a stateless command handler — left for future implementation
    StartGame -> []
  }
}
