import core/models/game_setup.{Standard}
import core/models/map.{Map}
import core/models/player.{User}
import core/models/state.{Initial, Lobby, MapSetup}
import engine/game_setup/commands.{CreateGame, create_game as game_setup_create_game}
import engine/lobby/aggregate as lobby_aggregate
import engine/lobby/command_handler as lobby_command_handler
import engine/lobby/commands as lobby_commands
import engine/lobby/event_handler as lobby_event_handler
import engine/map/aggregate as map_aggregate
import engine/map/command_handler as map_command_handler
import engine/map/commands as map_commands
import engine/map/event_handler as map_event_handler
import gleam/dict
import gleam/list
import gleam/string
import plugins/tts_string
import unitest

/// Step 1: Create a game (lobby)
pub fn create_lobby_test() {
  use <- unitest.tag("integration")

  let game_id = "test_game"
  let cmd = lobby_commands.create_lobby(game_id)

  let assert Ok(_) = lobby_aggregate.validate_command(cmd)

  let events = lobby_command_handler.process(cmd)
  let state = list.fold(events, Initial, lobby_event_handler.apply)

  assert Lobby(state: []) == state
}

/// Step 2: Multiple users join the lobby
pub fn users_join_lobby_test() {
  use <- unitest.tag("integration")

  let game_id = "test_game"
  let alice = User("Alice")
  let bob = User("Bob")
  let charlie = User("Charlie")

  let state =
    lobby_commands.create_lobby(game_id)
    |> lobby_command_handler.process()
    |> list.fold(Initial, lobby_event_handler.apply)

  let state =
    [alice, bob, charlie]
    |> list.fold(state, fn(s, user) {
      lobby_commands.join_lobby(game_id, user)
      |> lobby_command_handler.process()
      |> list.fold(s, lobby_event_handler.apply)
    })

  let assert Lobby(users) = state
  assert [alice, bob, charlie] == users
}

/// Step 3: Game is setup (game setup command is created with a new ID)
pub fn game_setup_creates_game_command_test() {
  use <- unitest.tag("integration")

  let player_count = 3
  let cmd = game_setup_create_game(player_count, Standard)

  let assert CreateGame(game_id, 3, Standard) = cmd
  assert string.length(game_id) > 0
}

/// Step 4: Map is created using the TTS plugin string
pub fn map_created_from_tts_string_test() {
  use <- unitest.tag("integration")

  // A 3-ring map has 19 hexes; Mecatol is auto-prepended, so we supply 18 tiles
  let tts = "19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36"
  let assert Ok(tiles) = tts_string.map_from_tts_string(tts)
  assert dict.size(tiles) == 19

  // Build the MapSetup state by creating a map grid first
  // Note: the command handler passes player_count directly to grid.new as the ring radius
  let create_grid_cmd = map_commands.create_map_grid(3)
  let assert Ok(_) = map_aggregate.validate_command(create_grid_cmd)
  let state =
    map_command_handler.process(create_grid_cmd)
    |> list.fold(Initial, map_event_handler.apply)
  let assert MapSetup(ms) = state

  // Complete the map using tiles parsed from the TTS string
  let state =
    map_commands.complete(ms.id, tiles)
    |> map_command_handler.process()
    |> list.fold(state, map_event_handler.apply)

  let assert MapSetup(final_ms) = state
  let assert Map(final_tiles, _) = final_ms.map
  assert dict.size(final_tiles) == 19
}

/// Full integration: all steps chained together
pub fn full_game_flow_test() {
  use <- unitest.tag("integration")

  let game_id = "integration_game"
  let player_count = 3
  let alice = User("Alice")
  let bob = User("Bob")
  let charlie = User("Charlie")

  // 1. Create the lobby
  let create_cmd = lobby_commands.create_lobby(game_id)
  let assert Ok(_) = lobby_aggregate.validate_command(create_cmd)
  let state =
    lobby_command_handler.process(create_cmd)
    |> list.fold(Initial, lobby_event_handler.apply)
  let assert Lobby([]) = state

  // 2. Users join the lobby
  let state =
    [alice, bob, charlie]
    |> list.fold(state, fn(s, user) {
      lobby_commands.join_lobby(game_id, user)
      |> lobby_command_handler.process()
      |> list.fold(s, lobby_event_handler.apply)
    })
  let assert Lobby(users) = state
  assert list.length(users) == player_count

  // 3. Game is setup
  let setup_cmd = game_setup_create_game(player_count, Standard)
  let assert CreateGame(setup_game_id, 3, Standard) = setup_cmd
  assert string.length(setup_game_id) > 0

  // 4. Create map grid (transitions to MapSetup state)
  let create_grid_cmd = map_commands.create_map_grid(player_count)
  let assert Ok(_) = map_aggregate.validate_command(create_grid_cmd)
  let map_state =
    map_command_handler.process(create_grid_cmd)
    |> list.fold(Initial, map_event_handler.apply)
  let assert MapSetup(ms) = map_state

  // 5. Parse TTS string and complete the map
  // player_count=3 → grid.new(3) = 3-ring grid (19 hexes); Mecatol is auto-prepended, so supply 18 tiles
  let tts = "19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36"
  let assert Ok(tiles) = tts_string.map_from_tts_string(tts)
  assert dict.size(tiles) == 19

  let map_state =
    map_commands.complete(ms.id, tiles)
    |> map_command_handler.process()
    |> list.fold(map_state, map_event_handler.apply)

  let assert MapSetup(final_ms) = map_state
  let assert Map(final_tiles, _) = final_ms.map
  assert dict.size(final_tiles) == 19
}
