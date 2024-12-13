import core/models/map.{Tile}
import core/models/state.{type State}
import engine/map/events.{type MapEvent}
import gleam/list
import gleam/option.{Some}

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    events.GridDefined(grid:, ..) -> {
      use prev_game <- state.update_playing_phase(state)
      use prev_map <- state.update_game_map(prev_game)
      use _prev_grid <- map.update_drafting_grid(prev_map)

      grid |> Some
    }

    events.TileSet(system:, coordinates:, ..) -> {
      use prev_game <- state.update_playing_phase(state)
      use prev_map <- state.update_game_map(prev_game)
      use prev_tiles <- map.update_drafting_tiles(prev_map)

      prev_tiles
      |> list.append(Tile(system:, coordinates:) |> list.wrap())
    }
    _ -> state
  }
}
