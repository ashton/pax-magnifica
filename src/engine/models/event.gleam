import birl.{type Time, now}
import core/models/common.{type Color}
import core/models/state.{type State, Initial}
import draft/events/draft.{type DraftEvent}
import engine/events/game.{type GameEvent}
import engine/events/player.{type PlayerEvent}
import gleam/list
import gleam/option.{type Option}
import utils/uuid

pub type EventSource {
  NoSource
  Draft
  PlayerSource(Color)
}

pub type EventData {
  GameEvent(GameEvent)
  PlayerEvent(PlayerEvent)
  DraftEvent(DraftEvent)
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

pub fn player_event(event: PlayerEvent, source: EventSource) {
  event |> PlayerEvent |> create(source)
}

pub fn draft_event(event: DraftEvent) {
  event |> DraftEvent |> create(Draft)
}

pub fn data(event: Event) -> EventData {
  let Event(_, data, ..) = event
  data
}

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
  case event |> data() {
    PlayerEvent(event) -> player.event_handler(event, state)
    GameEvent(event) -> game.event_handler(event, state)
    DraftEvent(event) -> draft.event_handler(event, state)
  }
}
