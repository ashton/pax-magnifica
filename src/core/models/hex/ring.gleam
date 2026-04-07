import core/models/hex/hex.{type Hex}
import core/models/hex/vector
import gleam/dict
import gleam/list
import gleam/result
import utils/result_utils

pub opaque type HexGridRing {
  HexGridRing(radius: Int, items: List(Hex))
}

pub fn new(
  number number: Int,
  coordinates coordinates: List(Hex),
) -> HexGridRing {
  HexGridRing(radius: number, items: coordinates)
}

pub fn number(ring: HexGridRing) -> Int {
  radius(ring)
}

pub fn coordinates(ring: HexGridRing) -> List(#(Int, Int)) {
  []
}

fn walk_direction(
  current current: vector.Vector,
  target target: vector.Vector,
  direction direction: vector.Vector,
  items items: List(vector.Vector),
) -> List(vector.Vector) {
  let items = list.append(items, [current])

  case current == target {
    True -> items
    False ->
      current
      |> vector.add(direction)
      |> walk_direction(target, direction, items)
  }
}

fn build_ring(radius radius: Int) -> Result(HexGridRing, String) {
  let rotation_vectors =
    hex.directions()
    |> dict.to_list()
    |> list.map(fn(pair) {
      let #(_, val) = pair
      val
    })
    |> list.map(result.map(_, vector.scale(_, radius)))

  let rotation_vectors_combinations = list.window_by_2(rotation_vectors)

  {
    use first_item <- result.try(
      list.first(rotation_vectors) |> result.replace_error("not found."),
    )
    use last_item <- result.try(
      list.last(rotation_vectors) |> result.replace_error("not found."),
    )

    rotation_vectors_combinations
    |> list.append([#(last_item, first_item)])
    |> list.fold(from: Ok([]), with: fn(results, current_pair) {
      let #(first_vec, second_vec) = current_pair
      let sub = result_utils.lift2(vector.subtract)
      let walk =
        result_utils.lift3(fn(current, target, direction) {
          walk_direction(
            current,
            target,
            direction,
            results |> result.unwrap([]),
          )
        })

      sub(second_vec, first_vec)
      |> result.map(vector.reduce(_, radius))
      |> walk(first_vec, second_vec, _)
    })
    |> result.map(list.unique)
    |> result.map(list.map(_, hex.from_vector))
    |> result.map(result.all)
    |> result.flatten()
    |> result.map(HexGridRing(radius, _))
  }
}

pub fn create(radius radius: Int) -> Result(HexGridRing, String) {
  case radius {
    0 -> {
      hex.from_pair(#(0, 0))
      |> result.map(list.wrap)
      |> result.map(HexGridRing(_, radius:))
    }

    1 -> {
      hex.directions()
      |> dict.to_list()
      |> list.map(fn(pair) {
        let #(_, val) = pair
        val
      })
      |> list.map(result.try(_, hex.from_vector))
      |> result.all()
      |> result.map(HexGridRing(_, radius:))
    }
    _ -> build_ring(radius:)
  }
}

pub fn radius(ring: HexGridRing) -> Int {
  let HexGridRing(radius:, ..) = ring

  radius
}

pub fn items(ring: HexGridRing) -> List(Hex) {
  let HexGridRing(items:, ..) = ring

  items
}
