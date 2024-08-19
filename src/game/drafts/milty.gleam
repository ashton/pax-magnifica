import game/factions
import game/systems
import gleam/bool
import gleam/list
import gleam/option.{type Option, None}
import models/draft.{type Draft, DraftRunning, MiltyDraft}
import models/drafts/milty.{MiltyDraftPool, MiltyDraftResult, MiltySlice}
import models/game
import models/player.{type User}

const default_player_count = 6

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
        )
      }),
  )
}

pub fn finished(draft: Draft) {
  draft.result
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
