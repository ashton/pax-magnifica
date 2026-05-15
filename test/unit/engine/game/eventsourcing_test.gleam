import core/models/player.{User}
import core/models/state.{Lobby}
import engine/game/commands.{LobbyCommand}
import engine/game/events.{LobbyEvent}
import engine/lobby/commands as lobby_commands
import engine/lobby/events as lobby_events
import engine/setup
import eventsourcing
import gleam/erlang/process
import unitest

pub fn execute_command_and_load_aggregate_test() {
  use <- unitest.tags(["unit", "game", "eventsourcing"])
  let es = setup.start()

  let response =
    eventsourcing.execute_with_response(
      es,
      "game_1",
      LobbyCommand(lobby_commands.create_lobby("game_1")),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(response, 1000)

  let subject = eventsourcing.load_aggregate(es, "game_1")
  let assert Ok(Ok(agg)) = process.receive(subject, 1000)
  let assert Lobby([]) = agg.entity.state
}

pub fn execute_multiple_commands_test() {
  use <- unitest.tags(["unit", "game", "eventsourcing"])
  let es = setup.start()

  let r1 =
    eventsourcing.execute_with_response(
      es,
      "game_1",
      LobbyCommand(lobby_commands.create_lobby("game_1")),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r1, 1000)

  let r2 =
    eventsourcing.execute_with_response(
      es,
      "game_1",
      LobbyCommand(lobby_commands.join_lobby("game_1", User("Alice"))),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r2, 1000)

  let subject = eventsourcing.load_aggregate(es, "game_1")
  let assert Ok(Ok(agg)) = process.receive(subject, 1000)
  let assert Lobby([User("Alice")]) = agg.entity.state
}

pub fn load_events_returns_all_events_test() {
  use <- unitest.tags(["unit", "game", "eventsourcing"])
  let es = setup.start()

  let r1 =
    eventsourcing.execute_with_response(
      es,
      "game_1",
      LobbyCommand(lobby_commands.create_lobby("game_1")),
      [],
    )
  let assert Ok(Ok(Nil)) = process.receive(r1, 1000)

  let subject = eventsourcing.load_events(es, "game_1")
  let assert Ok(Ok(events)) = process.receive(subject, 1000)
  let assert [envelope] = events
  let assert LobbyEvent(lobby_events.LobbyCreated("game_1")) = envelope.payload
}

pub fn domain_error_propagates_test() {
  use <- unitest.tags(["unit", "game", "eventsourcing"])
  let es = setup.start()

  let response =
    eventsourcing.execute_with_response(
      es,
      "game_1",
      LobbyCommand(lobby_commands.create_lobby("")),
      [],
    )
  let assert Ok(Error(eventsourcing.DomainError(_))) =
    process.receive(response, 1000)
}
