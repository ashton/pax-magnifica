import core/models/hex/vector.{type Vector}
import gleam/bool
import gleam/dict
import gleam/float
import gleam/int
import gleam/list
import gleam/result

pub opaque type Hex {
  Hex(col: Int, row: Int)
}

pub fn directions() {
  [
    #(0, vector.new(0, -1, 1)),
    #(1, vector.new(1, -1, 0)),
    #(2, vector.new(1, 0, -1)),
    #(3, vector.new(0, 1, -1)),
    #(4, vector.new(-1, 1, 0)),
    #(5, vector.new(-1, 0, 1)),
  ]
  |> dict.from_list()
}

fn diagonal(col, row) -> Int {
  -col - row
}

fn diagonal_from_hex(hex: Hex) -> Int {
  diagonal(hex.col, hex.row)
}

pub fn new(col: Int, row: Int) -> Result(Hex, String) {
  case col + row + diagonal(col, row) {
    0 -> Hex(col, row) |> Ok
    _ -> Error("invalid hex coordinates")
  }
}

pub fn from_vector(vec: Vector) -> Result(Hex, String) {
  let #(col, row, _) = vec |> vector.to_triplet()

  new(col, row)
}

pub fn to_vector(subject: Hex) -> Result(Vector, String) {
  let Hex(col:, row:) = subject
  let diag = diagonal(col, row)

  vector.new(col, row, diag)
}

pub fn from_pair(p: #(Int, Int)) -> Result(Hex, String) {
  let #(col, row) = p
  new(col, row)
}

pub fn to_pair(hex: Hex) -> #(Int, Int) {
  #(hex.col, hex.row)
}

pub fn equal(hex1 one: Hex, hex2 other: Hex) -> Bool {
  bool.and(one.col == other.col, one.row == other.row)
}

pub fn add(subject: Hex, vec: Vector) -> Result(Vector, String) {
  let diag = diagonal_from_hex(subject)
  let #(vcol, vrow, vdiag) = vector.to_triplet(vec)
  vector.new(subject.col + vcol, subject.row + vrow, diag + vdiag)
}

pub fn subtract(subject: Hex, vec: Vector) -> Result(Vector, String) {
  let diag = diagonal_from_hex(subject)
  let #(vcol, vrow, vdiag) = vector.to_triplet(vec)
  vector.new(subject.col - vcol, subject.row - vrow, diag - vdiag)
}

pub fn neighbors(origin_hex: Hex) -> Result(List(Hex), String) {
  directions()
  |> dict.to_list
  |> list.map(fn(pair) {
    let #(_, val) = pair
    val
  })
  |> list.map(result.try(_, add(origin_hex, _)))
  |> list.map(with: result.try(_, from_vector))
  |> result.all()
}

pub fn rotate_clockwise(subject: Hex, around center: Hex) -> Result(Hex, String) {
  use subject_vec <- result.try(to_vector(subject))
  use center_vec <- result.try(to_vector(center))

  let relative = vector.subtract(subject_vec, center_vec)
  let #(x, y, z) = vector.to_triplet(relative)

  // Clockwise 60° rotation in cube coordinates: (x, y, z) → (-y, -z, -x)
  use rotated <- result.try(vector.new(-y, -z, -x))

  rotated
  |> vector.add(center_vec)
  |> from_vector()
}

pub fn rotate_counter_clockwise(
  subject: Hex,
  around center: Hex,
) -> Result(Hex, String) {
  use subject_vec <- result.try(to_vector(subject))
  use center_vec <- result.try(to_vector(center))

  let relative = vector.subtract(subject_vec, center_vec)
  let #(x, y, z) = vector.to_triplet(relative)

  // Counter-clockwise 60° rotation in cube coordinates: (x, y, z) → (-z, -x, -y)
  use rotated <- result.try(vector.new(-z, -x, -y))

  rotated
  |> vector.add(center_vec)
  |> from_vector()
}

pub fn distance(one: Hex, other: Hex) -> Result(Int, String) {
  other
  |> to_vector()
  |> result.try(subtract(one, _))
  |> result.try(fn(res: Vector) {
    let #(vcol, vrow, vdiag) = res |> vector.to_triplet()
    let col_abs = vcol |> int.absolute_value()
    let row_abs = vrow |> int.absolute_value()
    let diag_abs = vdiag |> int.absolute_value()

    { col_abs + diag_abs + row_abs }
    |> int.divide(2)
    |> result.replace_error("Unable to calculate distance")
  })
}

// Returns the intermediate hexes on the straight-line path from `from` to `to`,
// excluding the endpoints. Used to detect blocking enemy fleets during movement.
pub fn path(from: Hex, to: Hex) -> Result(List(Hex), String) {
  use dist <- result.try(distance(from, to))
  case dist <= 1 {
    True -> Ok([])
    False -> {
      let Hex(fx, fy) = from
      let Hex(tx, ty) = to
      list.repeat(0, dist - 1)
      |> list.index_map(fn(_, i) {
        let i = i + 1
        let t = int.to_float(i) /. int.to_float(dist)
        let lx = int.to_float(fx) +. int.to_float(tx - fx) *. t
        let ly = int.to_float(fy) +. int.to_float(ty - fy) *. t
        let lz = 0.0 -. lx -. ly
        cube_round(lx, ly, lz)
      })
      |> result.all()
    }
  }
}

// Returns True if there is any path from `from` to `to` of at most `max_steps`
// that does not transit through any hex in `blocked`. The destination itself
// is never treated as blocked — arriving there is always valid.
pub fn has_path_avoiding(
  from: Hex,
  to: Hex,
  max_steps: Int,
  blocked: List(Hex),
) -> Bool {
  do_bfs([#(from, 0)], [from], to, max_steps, blocked)
}

fn do_bfs(
  queue: List(#(Hex, Int)),
  visited: List(Hex),
  to: Hex,
  max_steps: Int,
  blocked: List(Hex),
) -> Bool {
  case queue {
    [] -> False
    [#(current, steps), ..rest] ->
      case current == to {
        True -> True
        False ->
          case steps >= max_steps {
            True -> do_bfs(rest, visited, to, max_steps, blocked)
            False -> {
              let assert Ok(nbrs) = neighbors(current)
              let candidates =
                list.filter(nbrs, fn(h) {
                  !list.contains(visited, h)
                  && { h == to || !list.contains(blocked, h) }
                })
              do_bfs(
                list.append(
                  rest,
                  list.map(candidates, fn(h) { #(h, steps + 1) }),
                ),
                list.append(visited, candidates),
                to,
                max_steps,
                blocked,
              )
            }
          }
      }
  }
}

fn cube_round(fx: Float, fy: Float, fz: Float) -> Result(Hex, String) {
  let rx = float.round(fx)
  let ry = float.round(fy)
  let rz = float.round(fz)
  let x_diff = float.absolute_value(int.to_float(rx) -. fx)
  let y_diff = float.absolute_value(int.to_float(ry) -. fy)
  let z_diff = float.absolute_value(int.to_float(rz) -. fz)
  case x_diff >. y_diff && x_diff >. z_diff {
    True -> new(-ry - rz, ry)
    False ->
      case y_diff >. z_diff {
        True -> new(rx, -rx - rz)
        False -> new(rx, ry)
      }
  }
}
