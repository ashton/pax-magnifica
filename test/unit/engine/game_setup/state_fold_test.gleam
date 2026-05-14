import core/models/common.{Blue, Green}
import core/models/faction.{Hacan, Sol}
import core/models/game_setup.{
  GameSetup, Lobby, PreparingGame, SetupComplete, Standard,
}
import engine/game_setup/aggregate
import core/models/objective.{SecretObjective}
import engine/game_setup/events.{
  GameCreated, GameSetupCompleted, GameStarted, GalaxyBuildCompleted,
  PlayerAddedSecretObjective, PlayerGainedCommandTokens, PlayerJoined,
  PlayerStartingPlanetsSetup, PlayerStartingTechnologiesSetup,
  PlayerStartingUnitsSetup, PublicObjectivesRevealed, SecretObjectivesDealt,
  SpeakerAppointed, SystemTilePlaced,
}
import gleam/option.{None, Some}
import unitest

pub fn apply_game_created_initialises_state_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let event = GameCreated("game_1", 6, 10, Standard)
  let assert Some(gs) = aggregate.apply(None, event)

  assert gs.game_id == "game_1"
  assert gs.player_count == 6
  assert gs.players == []
  assert gs.phase == Lobby
}

pub fn apply_game_created_sets_empty_speaker_and_map_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let event = GameCreated("game_1", 4, 10, Standard)
  let assert Some(gs) = aggregate.apply(None, event)

  assert gs.initial_speaker == ""
  assert gs.map == ""
}

pub fn apply_player_joined_adds_player_id_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: [],
      initial_speaker: "",
      map: "",
      phase: Lobby,
    ))
  let event = PlayerJoined("game_1", "player_1", Green, Sol)
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.players == ["player_1"]
}

pub fn apply_player_joined_appends_to_existing_players_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: ["player_1"],
      initial_speaker: "",
      map: "",
      phase: Lobby,
    ))
  let event = PlayerJoined("game_1", "player_2", Blue, Hacan)
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.players == ["player_1", "player_2"]
}

pub fn apply_speaker_appointed_sets_speaker_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: ["player_1", "player_2"],
      initial_speaker: "",
      map: "",
      phase: Lobby,
    ))
  let event = SpeakerAppointed("game_1", "player_1")
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.initial_speaker == "player_1"
}

pub fn apply_galaxy_build_completed_transitions_to_preparing_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: [],
      initial_speaker: "",
      map: "",
      phase: Lobby,
    ))
  let event = GalaxyBuildCompleted("game_1")
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.phase == PreparingGame
}

pub fn apply_game_setup_completed_transitions_to_setup_complete_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: [],
      initial_speaker: "player_1",
      map: "",
      phase: PreparingGame,
    ))
  let event = GameSetupCompleted("game_1")
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.phase == SetupComplete
}

pub fn apply_game_started_transitions_to_setup_complete_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: [],
      initial_speaker: "player_1",
      map: "",
      phase: PreparingGame,
    ))
  let event = GameStarted("game_1", ["player_1", "player_2"], "map_data")
  let assert Some(gs) = aggregate.apply(state, event)

  assert gs.phase == SetupComplete
}

pub fn apply_data_events_do_not_change_phase_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let state =
    Some(GameSetup(
      game_id: "game_1",
      player_count: 3,
      players: [],
      initial_speaker: "",
      map: "",
      phase: Lobby,
    ))

  let assert Some(gs1) =
    aggregate.apply(state, SystemTilePlaced("game_1", "tile_1", "hex_1"))
  assert gs1.phase == Lobby

  let assert Some(gs3) =
    aggregate.apply(
      state,
      PlayerStartingTechnologiesSetup("game_1", "player_1", []),
    )
  assert gs3.phase == Lobby

  let assert Some(gs3b) =
    aggregate.apply(state, PlayerStartingUnitsSetup("game_1", "player_1", []))
  assert gs3b.phase == Lobby

  let assert Some(gs3c) =
    aggregate.apply(
      state,
      PlayerStartingPlanetsSetup("game_1", "player_1", []),
    )
  assert gs3c.phase == Lobby

  let assert Some(gs3d) =
    aggregate.apply(
      state,
      PlayerGainedCommandTokens("game_1", "player_1", []),
    )
  assert gs3d.phase == Lobby

  let assert Some(gs4) =
    aggregate.apply(
      state,
      PlayerAddedSecretObjective("game_1", "player_1", SecretObjective("obj_1")),
    )
  assert gs4.phase == Lobby

  let assert Some(gs4b) =
    aggregate.apply(
      state,
      SecretObjectivesDealt("game_1", "player_1", []),
    )
  assert gs4b.phase == Lobby

  let assert Some(gs5) =
    aggregate.apply(state, PublicObjectivesRevealed("game_1", []))
  assert gs5.phase == Lobby
}

pub fn apply_on_none_state_returns_none_for_non_creating_events_test() {
  use <- unitest.tags(["unit", "game_setup", "state_fold"])
  let event = PlayerJoined("game_1", "player_1", Green, Sol)
  assert None == aggregate.apply(None, event)
}
