import game/factions
import game/systems
import gleam/bool
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair
import models/common.{type Color}
import models/draft.{type Draft, DraftRunning, MiltyDraft}
import models/drafts/milty.{
  type MiltyDraftResult, type MiltySlice, MiltyDraftPool, MiltyDraftResult,
  MiltySlice, MiltySliceCoordinate,
}
import models/faction.{type FactionIdentifier}
import models/game.{type Game, type Position}
import models/map
import models/planetary_system.{type System}
import models/player.{type User}

const default_player_count = 6

pub const slice_coordinates = [
  MiltySliceCoordinate(
    home: #(0, -3),
    neighbors: [#(-1, 2), #(0, -2), #(1, -3), #(0, -1), #(1, -2)],
  ),
  MiltySliceCoordinate(
    home: #(3, -3),
    neighbors: [#(2, -3), #(2, -2), #(3, -2), #(1, -1), #(2, -1)],
  ),
  MiltySliceCoordinate(
    home: #(3, 0),
    neighbors: [#(3, -1), #(2, 0), #(2, 1), #(1, 0), #(1, 1)],
  ),
  MiltySliceCoordinate(
    home: #(0, 3),
    neighbors: [#(1, 2), #(0, 2), #(-1, 3), #(0, 1), #(-1, 2)],
  ),
  MiltySliceCoordinate(
    home: #(-3, 3),
    neighbors: [#(-2, 3), #(-2, 2), #(-3, 2), #(-1, 1), #(-2, 1)],
  ),
  MiltySliceCoordinate(
    home: #(-3, 0),
    neighbors: [#(-3, 1), #(-2, 0), #(-2, -1), #(-1, 0), #(-1, -1)],
  ),
]

pub fn total_players(player_count: Option(Int)) {
  player_count |> option.unwrap(default_player_count)
}

pub fn generate_faction_pool(override_amount player_count: Option(Int)) {
  factions.all
  |> list.shuffle()
  |> list.take(total_players(player_count) + 3)
}

pub fn generate_slices_pool(override_amount player_count: Option(Int)) {
  let available_systems =
    [
      systems.planetary_systems,
      systems.wormhole_systems,
      systems.anomaly_systems,
      systems.empty_systems,
    ]
    |> list.flatten()
    |> list.shuffle()

  let #(_, slice_pool) =
    player_count
    |> total_players()
    |> list.range(0, _)
    |> list.fold(from: #(available_systems, []), with: fn(result, _) {
      let #(available_systems, slices) = result

      #(available_systems |> list.drop(5), [
        available_systems |> list.take(5),
        ..slices
      ])
    })

  slice_pool
}

pub fn setup(
  participants: Option(List(User)),
  override_player_count player_count: Option(Int),
) -> Draft {
  let participants = participants |> option.unwrap([])

  MiltyDraft(
    state: DraftRunning,
    participants:,
    pool: MiltyDraftPool(
      available_factions: generate_faction_pool(player_count),
      available_slices: generate_slices_pool(player_count),
      available_positions: [
        game.Speaker,
        game.Second,
        game.Third,
        game.Fourth,
        game.Fifth,
        game.Sixth,
        game.Seventh,
        game.Eighth,
      ]
        |> list.take(player_count |> total_players()),
    ),
    result: participants
      |> list.map(fn(participant) {
        MiltyDraftResult(
          user: participant,
          faction: None,
          slice: MiltySlice(home: None, neighbors: []),
          position: None,
          color: None,
        )
      }),
  )
}

pub fn select_faction(
  draft draft: List(MiltyDraftResult),
  user user: User,
  faction faction: FactionIdentifier,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        MiltyDraftResult(
          ..result,
          faction: faction |> Some,
          slice: MiltySlice(
            home: faction |> factions.home_system() |> Some,
            neighbors: [],
          ),
        )
      False -> result
    }
  })
}

fn build_slice(
  faction: Option(FactionIdentifier),
  slice: MiltySlice,
  new_system: System,
) -> MiltySlice {
  let home =
    faction
    |> option.map(factions.home_system)
    |> option.or(slice.home, _)

  let neighbors = [new_system, ..slice.neighbors]

  MiltySlice(home:, neighbors:)
}

pub fn select_system(
  draft draft: List(MiltyDraftResult),
  user user: User,
  system system: System,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        MiltyDraftResult(
          ..result,
          slice: build_slice(result.faction, result.slice, system),
        )
      False -> result
    }
  })
}

pub fn select_position(
  draft draft: List(MiltyDraftResult),
  user user: User,
  position position: Position,
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True -> MiltyDraftResult(..result, position: position |> Some)
      False -> result
    }
  })
}

pub fn select_color(
  draft draft: List(MiltyDraftResult),
  user user: User,
  color color: Color,
) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True -> MiltyDraftResult(..result, color: color |> Some)
      False -> result
    }
  })
}

pub fn finished(draft: List(MiltyDraftResult)) {
  draft
  |> list.all(fn(draft_result) {
    draft_result.faction
    |> option.is_some()
    |> bool.and(draft_result.slice.home |> option.is_some())
    |> bool.and(
      draft_result.slice.neighbors |> list.is_empty() |> bool.negate(),
    )
    |> bool.and(draft_result.position |> option.is_some())
  })
}

pub fn new_game(draft: Draft) -> Game {
  let players =
    io.debug(draft.result)
    |> list.map(fn(res) {
      let assert Some(faction) = res.faction
      let assert Some(color) = res.color
      player.setup_player(user: res.user, faction: factions.make(faction))
      |> pair.new(color, _)
    })

  let map =
    draft.result
    |> list.map(fn(item) { item.slice })
    |> list.zip(slice_coordinates)
    |> list.map(fn(item) {
      let #(slice, slice_coordinates) = item
      let assert Some(home_system) = slice.home
      let #(home_col, home_row) = slice_coordinates.home

      let neighbors =
        list.map2(
          slice.neighbors,
          slice_coordinates.neighbors,
          with: fn(system, coords) {
            let #(col, row) = coords
            map.Tile(system:, col:, row:)
          },
        )

      [map.Tile(system: home_system, col: home_col, row: home_row), ..neighbors]
    })
    |> list.flatten()
    |> map.init()

  game.setup_game(players:, map:)
}
