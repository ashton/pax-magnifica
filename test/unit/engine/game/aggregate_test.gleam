import core/models/game_setup
import core/models/player.{User}
import core/models/state.{Lobby}
import core/models/victory_point
import engine/game/aggregate
import engine/game/commands.{LobbyCommand, ScoringCommand, SetupCommand}
import engine/game/entity
import engine/game/events.{LobbyEvent, ScoringEvent, SetupEvent}
import engine/game_setup/commands as setup_commands
import engine/game_setup/events as setup_events
import engine/lobby/commands as lobby_commands
import engine/lobby/events as lobby_events
import engine/scoring/commands as scoring_commands
import engine/scoring/events as scoring_events
import gleam/option.{Some}
import unitest

// ── handle delegates to lobby ────────────────────────────────────────────────

pub fn handle_lobby_command_delegates_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let cmd = LobbyCommand(lobby_commands.create_lobby("game_1"))
  let assert Ok([LobbyEvent(lobby_events.LobbyCreated("game_1"))]) =
    aggregate.handle(entity, cmd)
}

pub fn handle_lobby_command_validation_error_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let cmd = LobbyCommand(lobby_commands.create_lobby(""))
  let assert Error(_) = aggregate.handle(entity, cmd)
}

// ── handle delegates to game_setup ───────────────────────────────────────────

pub fn handle_setup_command_delegates_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let cmd =
    SetupCommand(setup_commands.CreateGame("game_1", 4, game_setup.Standard))
  let assert Ok([SetupEvent(setup_events.GameCreated("game_1", 4, 10, _))]) =
    aggregate.handle(entity, cmd)
}

// ── handle delegates to scoring ──────────────────────────────────────────────

pub fn handle_scoring_command_delegates_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let cmd =
    ScoringCommand(scoring_commands.award_victory_points(
      "game_1",
      "player_1",
      victory_point.PublicObjectiveScored("obj_1"),
      2,
    ))
  let assert Ok([
    ScoringEvent(scoring_events.PlayerScoredVictoryPoints(
      "game_1",
      "player_1",
      _,
      2,
    )),
  ]) = aggregate.handle(entity, cmd)
}

// ── apply delegates to lobby ─────────────────────────────────────────────────

pub fn apply_lobby_event_updates_state_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let event = LobbyEvent(lobby_events.LobbyCreated("game_1"))
  let updated = aggregate.apply(entity, event)
  let assert Lobby([]) = updated.state
}

pub fn apply_lobby_user_joined_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.GameEntity(..entity.initial(), state: Lobby(state: []))
  let user = User("Alice")
  let event = LobbyEvent(lobby_events.UserJoined("game_1", user))
  let updated = aggregate.apply(entity, event)
  let assert Lobby([User("Alice")]) = updated.state
}

// ── apply delegates to game_setup ────────────────────────────────────────────

pub fn apply_setup_event_updates_setup_state_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let event =
    SetupEvent(setup_events.GameCreated("game_1", 4, 10, game_setup.Standard))
  let updated = aggregate.apply(entity, event)
  let assert Some(_) = updated.setup
}

// ── apply delegates to scoring ───────────────────────────────────────────────

pub fn apply_scoring_event_updates_scoring_state_test() {
  use <- unitest.tags(["unit", "game", "aggregate"])
  let entity = entity.initial()
  let event =
    ScoringEvent(scoring_events.PlayerScoredVictoryPoints(
      "game_1",
      "player_1",
      victory_point.PublicObjectiveScored("obj_1"),
      2,
    ))
  let updated = aggregate.apply(entity, event)
  let assert Some(_) = updated.scoring
}
