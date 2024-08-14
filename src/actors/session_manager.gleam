import chip
import gleam/erlang/process.{type Subject, Normal}
import gleam/function.{identity}
import gleam/option.{None}
import gleam/otp/actor.{Continue, Ready, Spec, Stop}
import gleam/result
import ids/uuid
import models/event.{type Event}

pub type SessionId =
  String

pub type SessionManagerTopic {
  Session
  Game
}

pub type SessionManagerError {
  StartError
  NotFound
}

pub type Registry =
  chip.Registry(SessionManagerMessage, SessionId, SessionManagerTopic)

pub type Record {
  Record(id: String, events: List(Event))
}

pub type SessionManagerState {
  SessionManagerState(subject: Subject(SessionManagerMessage), record: Record)
}

pub opaque type SessionManagerMessage {
  GetSessionDetails(caller: Subject(Record))
  UpdateSessionDetails(List(Event))
  AppendState(caller: Subject(Result(List(Event), String)), Event)
  Halt
}

pub fn start() {
  chip.start()
}

fn handle_init(session_id: SessionId) {
  let subject = process.new_subject()
  let state =
    SessionManagerState(
      subject: subject,
      record: Record(id: session_id, events: []),
    )
  let selector = process.new_selector() |> process.selecting(subject, identity)

  Ready(state, selector)
}

fn handle_message(message: SessionManagerMessage, state: SessionManagerState) {
  case message {
    GetSessionDetails(caller) -> {
      actor.send(caller, state.record)
      Continue(state, None)
    }

    UpdateSessionDetails(events) -> {
      let record = Record(..state.record, events: events)
      let state = SessionManagerState(..state, record: record)
      Continue(state, None)
    }

    AppendState(caller, event) -> todo

    Halt -> Stop(Normal)
  }
}

pub fn new_session(
  registry: Registry,
) -> Result(Subject(SessionManagerMessage), SessionManagerError) {
  let session_id = uuid.generate_v4()
  let subject =
    session_id
    |> result.then(fn(session_id) {
      actor.start_spec(Spec(
        init: fn() { handle_init(session_id) },
        init_timeout: 10,
        loop: handle_message,
      ))
      |> result.replace_error("StartError")
    })

  subject
  |> result.map(chip.new)
  |> result.map(chip.tag(_, session_id |> result.unwrap("")))
  |> result.map(chip.register(registry, _))
  |> result.map(fn(_) { subject })
  |> result.flatten()
  |> result.map_error(fn(_) { StartError })
}

pub fn get_session(
  registry: Registry,
  session_id: String,
) -> Result(Subject(SessionManagerMessage), Nil) {
  chip.find(registry, session_id)
}

pub fn fetch_session_details(subject: Subject(SessionManagerMessage)) -> Record {
  actor.call(subject, GetSessionDetails(_), 100)
}

pub fn update_session_details(
  subject: Subject(SessionManagerMessage),
  events: List(Event),
) {
  actor.send(subject, UpdateSessionDetails(events))
}
