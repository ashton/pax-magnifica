import core/models/map
import core/models/state.{type State}
import engine/map/events.{type MapEvent}
import gleam/option.{Some}

pub fn apply(state: State, event: MapEvent) -> State {
  case event {
    events.GridDefined(grid:, ..) -> {
      use prev_game <- state.update_playing_phase(state)
      use prev_map <- state.update_game_map(prev_game)
      use _prev_grid <- map.update_drafting_grid(prev_map)

      grid |> Some
    }
    _ -> state
  }
}
