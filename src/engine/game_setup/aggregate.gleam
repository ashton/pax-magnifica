import core/value_objects/game
import core/value_objects/player
import engine/game_setup/commands.{
  type GameSetupCommand, AddSecretObjectiveToPlayer, AppointSpeaker, CreateGame,
  DealSecretObjectives, JoinGame, SetPlayerInitialComponents, StartGame,
}
import engine/game_setup/events.{type GameSetupEvent, PlayerGainedCommandTokens}
import gleam/int
import gleam/result

const default_victory_points = 10

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

fn validate_ids(game_id: String, player_id: String) -> Result(Nil, String) {
  use _ <- result.try(game.new_id(game_id))
  use _ <- result.try(player.new_id(player_id))
  Ok(Nil)
}

fn validate(
  command: GameSetupCommand,
) -> Result(GameSetupCommand, String) {
  case command {
    CreateGame(game_id, player_count, _) ->
      game.new_id(game_id)
      |> result.try(fn(_) { validate_player_count(player_count) })
      |> result.replace(command)

    JoinGame(game_id, player_id, _, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    AddSecretObjectiveToPlayer(game_id, player_id, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    DealSecretObjectives(game_id, player_id, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    AppointSpeaker(game_id, player_id) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    SetPlayerInitialComponents(game_id, player_id, _, _, _, _) ->
      validate_ids(game_id, player_id)
      |> result.replace(command)

    StartGame -> Ok(command)
  }
}

pub fn handle(
  command: GameSetupCommand,
) -> Result(List(GameSetupEvent), String) {
  use _ <- result.try(validate(command))
  case command {
    CreateGame(game_id, player_count, setup_type) ->
      Ok([
        events.GameCreated(
          game_id,
          player_count,
          default_victory_points,
          setup_type,
        ),
      ])

    JoinGame(game_id, player_id, color, faction) ->
      Ok([events.PlayerJoined(game_id, player_id, color, faction)])

    DealSecretObjectives(game_id, player_id, objectives) ->
      Ok([events.SecretObjectivesDealt(game_id, player_id, objectives)])

    AddSecretObjectiveToPlayer(game_id, player_id, objective) ->
      Ok([events.PlayerAddedSecretObjective(game_id, player_id, objective)])

    AppointSpeaker(game_id, player_id) ->
      Ok([events.SpeakerAppointed(game_id, player_id)])

    SetPlayerInitialComponents(
      game_id,
      player_id,
      techs,
      units,
      starting_planets,
      starting_command_tokens,
    ) ->
      Ok([
        events.PlayerStartingTechnologiesSetup(game_id, player_id, techs),
        events.PlayerStartingUnitsSetup(game_id, player_id, units),
        events.PlayerStartingPlanetsSetup(game_id, player_id, starting_planets),
        PlayerGainedCommandTokens(game_id, player_id, starting_command_tokens),
      ])

    StartGame -> Ok([])
  }
}
