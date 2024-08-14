import birl.{type Time, now}
import events/game.{type GameEvent}
import events/session.{type SessionEvent}
import models/common.{type Color}
import utils/uuid

pub type EventSource {
  NoSource
  PlayerSource(Color)
}

pub type EventData {
  GameEvent(GameEvent)
  SessionEvent(SessionEvent)
}

pub opaque type Event {
  Event(id: String, data: EventData, source: EventSource, created_at: Time)
}

fn create(data: EventData, source: EventSource) {
  Event(id: uuid.new(), data: data, source: source, created_at: now())
}

pub fn game_event(event: GameEvent, source: EventSource) {
  event |> GameEvent |> create(source)
}

pub fn session_event(event: SessionEvent, source: EventSource) {
  event |> SessionEvent |> create(source)
}

pub fn data(event: Event) -> EventData {
  let Event(_, data, ..) = event
  data
}
