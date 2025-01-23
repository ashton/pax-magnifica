import core/models/common.{type Color}
import core/models/faction.{type FactionIdentifier}
import core/models/game
import core/models/map
import core/models/player.{type User}
import draft/models/draft.{DraftRunning, StandardDraft}
import draft/models/standard.{
  type StandardDraftResult, type SystemDraft, StandardDraftPool,
  StandardDraftResult, SystemDraft,
}
import game/factions
import game/systems
import gleam/list
import gleam/option.{Some}

pub fn generate_faction_pool() {
  factions.all
  |> list.shuffle()
}

fn take_blue_systems(amount: Int) {
  systems.blue_systems
  |> list.shuffle()
  |> list.take(amount)
}

fn take_red_systems(amount: Int) {
  systems.blue_systems
  |> list.shuffle()
  |> list.take(amount)
}

fn take_systems(red red_amount: Int, blue blue_amount: Int) {
  blue_amount
  |> take_blue_systems()
  |> list.append(take_red_systems(red_amount))
}

pub fn generate_systems_pool(users: List(User)) {
  case users |> list.length() {
    3 -> take_systems(blue: 6, red: 2)
    4 -> take_systems(blue: 5, red: 3)
    5 -> take_systems(blue: 4, red: 2)
    6 -> take_systems(blue: 3, red: 2)
    7 -> take_systems(blue: 3, red: 2)
    8 -> take_systems(blue: 4, red: 2)
    _ -> panic
  }
}

pub fn setup(participants: List(User)) {
  let pool = StandardDraftPool(available_factions: [], available_systems: [])

  StandardDraft(participants:, state: DraftRunning, pool:, result: [])
}

pub fn select_faction(
  result result: List(StandardDraftResult),
  user user: User,
  faction faction: FactionIdentifier,
) {
  result
  |> list.map(fn(result) {
    case result.user == user {
      True -> StandardDraftResult(..result, faction: faction |> Some)
      False -> result
    }
  })
}

pub fn build_positions(
  result result: List(StandardDraftResult),
  speaker speaker: User,
) {
  let assert Ok(#(speaker, _)) =
    result
    |> list.pop(fn(item) { item.user == speaker })

  result
  |> list.prepend(speaker)
  |> list.zip([
    game.Speaker,
    game.Second,
    game.Third,
    game.Fourth,
    game.Fifth,
    game.Sixth,
    game.Seventh,
    game.Eighth,
  ])
  |> list.map(fn(item) {
    let #(res, position) = item

    StandardDraftResult(..res, position: position |> Some)
  })
}

pub fn place_system(
  result result: List(StandardDraftResult),
  system_draft system_draft: SystemDraft,
) {
  let SystemDraft(user:, system:, col:, row:) = system_draft
  result
  |> list.map(fn(result) {
    case result.user == user {
      True ->
        StandardDraftResult(
          ..result,
          tiles: result.tiles
            |> list.prepend(map.Tile(system:, coordinates: #(col, row))),
        )
      False -> result
    }
  })
}

pub fn select_color(
  result result: List(StandardDraftResult),
  user user: User,
  color color: Color,
) {
  result
  |> list.map(fn(result) {
    case result.user == user {
      True -> StandardDraftResult(..result, color: color |> Some)
      False -> result
    }
  })
}
