import core/models/hex/hex.{type Hex}
import core/models/hex/vector
import gleam/list
import gleam/result
import gleam/set

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
  current current,
  target target,
  direction direction,
  items items,
) {
  let items = items |> set.insert(this: current)

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
    vector.vector_directions
    |> list.map(vector.scale(_, radius))

  let rotation_vectors_combinations = list.window_by_2(rotation_vectors)

  {
    use first_item <- result.then(
      list.first(rotation_vectors) |> result.replace_error("not found."),
    )
    use last_item <- result.then(
      list.last(rotation_vectors) |> result.replace_error("not found."),
    )

    [#(last_item, first_item)]
    |> list.append(rotation_vectors_combinations)
    |> list.fold(from: set.new(), with: fn(results, current_pair) {
      let #(first_vec, second_vec) = current_pair
      second_vec
      |> vector.subtract(first_vec)
      |> vector.reduce(radius)
      |> walk_direction(first_vec, second_vec, _, results)
    })
    |> set.to_list()
    |> list.map(hex.from_vector)
    |> result.all()
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
      vector.vector_directions
      |> list.map(hex.from_vector)
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
