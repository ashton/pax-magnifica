import commands/game.{type GameCommand, CreateGame} as game_commands
import events/game as game_events
import gleam/erlang/process
import gleam/list
import gleam/otp/actor
import models/command.{type Command, Command}
import models/event.{type Event}

fn handle_commands(
  command: Command(d),
  events: List(Event(p)),
) -> actor.Next(Command(d), List(Event(p))) {
  case command {
    Command(data: CreateGame(players, map), issuer: issuer, ..) ->
      GameCreated(players: players, map: map)
      |> list.wrap()
      |> list.append()
      |> actor.continue
  }
}

pub fn new(initial_value: List(Event(p))) {
  let assert Ok(event_store) = actor.start(initial_value, handle_commands)

  event_store
}

pub fn stop() {
  actor.Stop(process.Normal)
}

pub fn issue_command(store, command: Command(d)) {
  process.send(store, command)
}
