import core/models/hex/grid
import core/models/map
import core/models/state.{type State, GameState, PlayingPhase}
import engine/map/event_handler as handler
import engine/map/events
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn grid_defined_test() {
  let state = PlayingPhase(game: GameState(id: "game_id", map: map.default()))
  let assert Ok(grid) = grid.new(3)
  let event = events.grid_defined("map_id", grid)

  handler.apply(state, event)
  |> fn(state: State) {
    let assert PlayingPhase(game: GameState(map: map.Drafting(grid:, ..), ..)) =
      state
    grid
  }
  |> should.be_some()
  |> should.equal(grid)
}
