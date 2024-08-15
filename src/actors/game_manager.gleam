import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/option.{None}
import gleam/otp/actor
import gleam/result
import ids/uuid
import models/command.{type Command}
import models/event.{type Event, reduce}
import models/state.{type State}

pub type GameId =
  String

pub opaque type GameManagerState {
  GameManagerState(id: GameId, events: List(Event))
}

pub fn events(state: GameManagerState) {
  let GameManagerState(_id, events) = state
  events
}

pub fn game_id(state: GameManagerState) {
  let GameManagerState(id, _events) = state
  id
}

pub opaque type GameManagerMessage {
  UpdateGameState(event: Command)
  GetGameState(caller: Subject(Result(GameManagerState, String)))
  Snapshot(caller: Subject(Result(State, String)))
}

fn handle_message(
  message: GameManagerMessage,
  state: Result(GameManagerState, String),
) {
  case message {
    UpdateGameState(command) ->
      state
      |> result.map(fn(current_state) {
        let new_event = command.handle_command(command)

        GameManagerState(id: current_state |> game_id(), events: [
          new_event,
          ..events(current_state)
        ])
      })

    GetGameState(client) -> {
      actor.send(client, state)
      state
    }

    Snapshot(client) -> {
      state
      |> result.map(fn(current_state) {
        let snapshot =
          current_state
          |> events
          |> list.reverse()
          |> reduce(None)

        actor.send(client, snapshot)
        current_state
      })
    }
  }
  |> actor.continue()
}

pub fn new_game_actor() -> #(GameId, Subject(GameManagerMessage)) {
  let assert Ok(game_id) = uuid.generate_v4()
  let assert Ok(actor) =
    actor.start(Ok(GameManagerState(id: game_id, events: [])), handle_message)

  #(game_id, actor)
}

pub fn update_game(actor: Subject(GameManagerMessage), command: Command) -> Nil {
  process.send(actor, UpdateGameState(command))
}

pub fn manager_state(
  subject: Subject(GameManagerMessage),
) -> Result(GameManagerState, String) {
  actor.call(subject, GetGameState(_), 100)
}

pub fn game_state(subject: Subject(GameManagerMessage)) -> Result(State, String) {
  actor.call(subject, Snapshot(_), 100)
}
