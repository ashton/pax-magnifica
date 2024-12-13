import core/models/hex/coordinate
import core/models/hex/grid
import core/models/map.{Tile}
import core/models/state.{type State, GameState, PlayingPhase}
import engine/map/event_handler as handler
import engine/map/events
import game/systems
import glacier
import glacier/should
import gleam/option.{None, Some}

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

pub fn set_first_tile_and_map_still_drafting_test() {
  let state = PlayingPhase(game: GameState(id: "game_id", map: map.default()))
  let expected_tile =
    Tile(system: systems.mecatol_rex_system, coordinates: coordinate.new(0, 0))
  let event =
    events.tile_set("game_id", systems.mecatol_rex_system, coordinate.new(0, 0))

  handler.apply(state, event)
  |> fn(state: State) {
    let assert PlayingPhase(game: GameState(map: map.Drafting(tiles:, ..), ..)) =
      state
    tiles
  }
  |> should.equal([expected_tile])
}

pub fn set_more_than_one_tile_and_map_still_drafting_test() {
  let first_tile =
    Tile(system: systems.planetary_system_6, coordinates: coordinate.new(0, 1))
  let expected_tile = Tile(systems.mecatol_rex_system, coordinate.new(0, 0))
  let state =
    PlayingPhase(game: GameState(
      id: "game_id",
      map: map.new_drafting(Some([first_tile]), None),
    ))
  let event =
    events.tile_set("game_id", systems.mecatol_rex_system, coordinate.new(0, 0))

  handler.apply(state, event)
  |> fn(state: State) {
    let assert PlayingPhase(game: GameState(map: map.Drafting(tiles:, ..), ..)) =
      state
    tiles
  }
  |> should.equal([first_tile, expected_tile])
}

// pub fn set_tile_and_map_is_finished_test() {
//   let assert Ok(initial_grid) = grid.new(0)
//   let expected_tile = Tile(systems.mecatol_rex_system, coordinate.new(0, 0))
//   let state =
//     PlayingPhase(game: GameState(
//       id: "game_id",
//       map: map.new_drafting(None, initial_grid |> Some),
//     ))
//   let event =
//     events.tile_set("game_id", systems.mecatol_rex_system, coordinate.new(0, 0))
//
//   handler.apply(state, event)
//   |> fn(state: State) {
//     let assert PlayingPhase(game: GameState(map: new_map, ..)) = state
//     new_map
//   }
//   |> should.equal(map.new([expected_tile]))
// }
