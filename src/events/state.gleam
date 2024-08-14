import events/game
import events/session.{type SessionEvent}
import gleam/list
import gleam/option.{type Option}
import gleam/result
import models/event.{type Event, GameEvent, SessionEvent}
import models/state.{type State, Initial}

pub fn reduce(
  events: List(Event),
  initial_state: Option(State),
) -> Result(State, String) {
  let state = initial_state |> option.unwrap(Initial)
  events |> list.fold(from: Ok(state), with: event_handler)
}

fn event_handler(
  state: Result(State, String),
  event: Event,
) -> Result(State, String) {
  case event |> event.data() {
    SessionEvent(event) ->
      state
      |> result.then(fn(state) { session.event_handler(event, state) })
    GameEvent(event) ->
      state
      |> result.then(fn(state) { game.event_handler(event, state) })
  }
}
