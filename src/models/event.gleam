import birl.{type Time}
import models/common.{type Color}

pub type EventSource {
  NoSource
  PlayerSource(Color)
}

pub type Event(event_payload) {
  Event(id: String, data: event_payload, source: EventSource, created_at: Time)
}
