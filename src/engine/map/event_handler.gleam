import core/models/map as game_map
import core/models/state.{type State, MapSetup}
import core/models/state/map.{MapState}
import engine/map/events.{type MapEvent, GridDefined, MapCreated, TileSet}

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    GridDefined(game, _grid) ->
      MapSetup(state: MapState(id: game, map: game_map.default()))

    TileSet(_, system, hex) ->
      state.update_map(state, fn(ms) {
        let assert Ok(updated_map) = game_map.add_tile(Ok(ms.map), hex, system)
        MapState(..ms, map: updated_map)
      })

    MapCreated(_, completed_map) ->
      state.update_map(state, fn(ms) { MapState(..ms, map: completed_map) })
  }
}
