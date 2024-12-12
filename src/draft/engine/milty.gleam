import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game.{type Game, type Position}
import core/models/hex/coordinate
import core/models/map
import core/models/planetary_system.{type System}
import core/models/player.{type User}
import draft/models/draft.{type Draft, DraftRunning, MiltyDraft}
import draft/models/milty.{
  type MiltyDraftResult, type MiltySlice, MiltyDraftPool, MiltyDraftResult,
  MiltySlice, MiltySliceCoordinate,
}
import game/factions
import game/systems
import gleam/bool
import gleam/io
import gleam/list
import gleam/option.{type Option, None, Some}
import gleam/pair

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

pub fn select_slice(
  draft draft: List(MiltyDraftResult),
  user user: User,
  systems systems: List(System),
) -> List(MiltyDraftResult) {
  draft
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        MiltyDraftResult(
          ..result,
          slice: MiltySlice(..result.slice, neighbors: systems),
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
  let assert MiltyDraft(result:, ..) = draft

  let players =
    io.debug(result)
    |> list.map(fn(res) {
      let assert Some(faction) = res.faction
      let assert Some(color) = res.color
      player.setup_player(user: res.user, faction: factions.make(faction))
      |> pair.new(color, _)
    })

  let map =
    result
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
            map.Tile(system:, coordinates: coords |> coordinate.from_pair())
          },
        )

      [
        map.Tile(
          system: home_system,
          coordinates: coordinate.new(home_col, home_row),
        ),
        ..neighbors
      ]
    })
    |> list.flatten()
    |> map.init()

  game.setup_game(players:, map:)
}
