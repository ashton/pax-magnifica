import game/draft
import gleam/io
import gleam/result
import models/common.{type Color}
import models/draft.{type Draft, type DraftType} as _
import models/faction.{type FactionIdentifier}
import models/game.{type Position}
import models/planetary_system.{type System}
import models/player.{type User}
import models/state.{
  type State, DraftPhase, EndGamePhase, Initial, LobbyPhase, PlayingPhase,
}

pub type DraftEvent {
  DraftInitiated(kind: DraftType)
  FactionSelected(faction: FactionIdentifier, user: User)
  SystemSelected(system: System, user: User)
  PositionSelected(position: Position, user: User)
  ColorSelected(color: Color, user: User)
}

fn lobby_phase_event_handler(
  event: DraftEvent,
  users: List(User),
) -> Result(State, String) {
  case event {
    DraftInitiated(kind) -> draft.setup(kind, users) |> DraftPhase |> Ok
    _ -> Error("Start a draft first!")
  }
}

fn draft_phase_event_handler(
  event: DraftEvent,
  draft: Draft,
) -> Result(State, String) {
  case event {
    DraftInitiated(..) -> Error("Draft was alredy initiated!")
    FactionSelected(faction, user) ->
      draft.set_faction(draft:, user:, faction:) |> Ok
    SystemSelected(system, user) ->
      draft.set_system(draft:, user:, system:) |> Ok
    PositionSelected(position, user) ->
      draft.set_position(draft:, user:, position:) |> Ok
    ColorSelected(user: user, color: color) ->
      draft.set_color(draft:, user:, color:) |> Ok
  }
  |> result.map(DraftPhase)
}

pub fn event_handler(
  event: DraftEvent,
  state: Result(State, String),
) -> Result(State, String) {
  case io.debug(state) {
    Ok(Initial) -> Error("You need to create a game first")
    Ok(LobbyPhase(users)) -> lobby_phase_event_handler(io.debug(event), users)
    Ok(DraftPhase(draft)) -> draft_phase_event_handler(io.debug(event), draft)
    Ok(PlayingPhase(..)) -> Error("This game already started!")
    Ok(EndGamePhase(..)) -> Error("This game already finished!")
    error -> error
  }
}
