import core/models/state.{type State}
import engine/map/events.{type MapEvent, GridDefined, MapCreated, TileSet}

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    GridDefined(..) -> todo
    TileSet(..) -> todo
    MapCreated(..) -> todo
  }
}
