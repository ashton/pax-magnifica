import gleam/erlang/process.{type Subject}
import gleam/list
import gleam/otp/actor.{type Next}
import models/event.{type Event}

pub type GameManagerState {
  GameManagerState(events: List(Event))
}

pub type GameManagerMessage {
  NewEvent(Event)
}
