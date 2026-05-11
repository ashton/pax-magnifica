// Hex rotation uses cube coordinate formulas applied relative to a center:
//   Clockwise:         (x, y, z) → (-y, -z, -x)
//   Counter-clockwise: (x, y, z) → (-z, -x, -y)
// --- Clockwise ---

import core/models/hex/hex
import unitest

pub fn rotate_clockwise_around_self_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  let assert Ok(subject) = hex.new(1, -1)

  let assert Ok(result) = hex.rotate_clockwise(subject, around: subject)

  assert hex.equal(subject, result)
}

pub fn rotate_clockwise_one_step_from_origin_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // Direction 0 neighbor (0,-1) rotated one step CW around origin → direction 1 (1,-1)
  let assert Ok(center) = hex.new(0, 0)
  let assert Ok(subject) = hex.new(0, -1)
  let assert Ok(expected) = hex.new(1, -1)

  let assert Ok(result) = hex.rotate_clockwise(subject, around: center)

  assert hex.equal(expected, result)
}

pub fn rotate_clockwise_six_times_returns_to_start_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // Six 60° clockwise rotations form a full circle — must return to start
  let assert Ok(center) = hex.new(0, 0)
  let assert Ok(subject) = hex.new(2, -1)

  let assert Ok(result) =
    [1, 2, 3, 4, 5, 6]
    |> list_fold_result(subject, fn(acc, _) {
      hex.rotate_clockwise(acc, around: center)
    })

  assert hex.equal(subject, result)
}

pub fn rotate_clockwise_non_origin_center_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // subject (1,0), center (1,-1): relative cube (0,1,-1) → rotated (-1,1,0) → absolute (0,0,0)
  let assert Ok(center) = hex.new(1, -1)
  let assert Ok(subject) = hex.new(1, 0)
  let assert Ok(expected) = hex.new(0, 0)

  let assert Ok(result) = hex.rotate_clockwise(subject, around: center)

  assert hex.equal(expected, result)
}

// --- Counter-clockwise ---

pub fn rotate_counter_clockwise_around_self_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  let assert Ok(subject) = hex.new(1, -1)

  let assert Ok(result) = hex.rotate_counter_clockwise(subject, around: subject)

  assert hex.equal(subject, result)
}

pub fn rotate_counter_clockwise_one_step_from_origin_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // Direction 1 neighbor (1,-1) rotated one step CCW around origin → direction 0 (0,-1)
  let assert Ok(center) = hex.new(0, 0)
  let assert Ok(subject) = hex.new(1, -1)
  let assert Ok(expected) = hex.new(0, -1)

  let assert Ok(result) = hex.rotate_counter_clockwise(subject, around: center)

  assert hex.equal(expected, result)
}

pub fn rotate_counter_clockwise_six_times_returns_to_start_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // Six 60° counter-clockwise rotations form a full circle — must return to start
  let assert Ok(center) = hex.new(0, 0)
  let assert Ok(subject) = hex.new(2, -1)

  let assert Ok(result) =
    [1, 2, 3, 4, 5, 6]
    |> list_fold_result(subject, fn(acc, _) {
      hex.rotate_counter_clockwise(acc, around: center)
    })

  assert hex.equal(subject, result)
}

pub fn rotate_counter_clockwise_non_origin_center_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // subject (1,0), center (1,-1): relative cube (0,1,-1) → (-z,-x,-y) = (1,0,-1) → absolute (2,-1,-1) = hex(2,-1)
  let assert Ok(center) = hex.new(1, -1)
  let assert Ok(subject) = hex.new(1, 0)
  let assert Ok(expected) = hex.new(2, -1)

  let assert Ok(result) = hex.rotate_counter_clockwise(subject, around: center)

  assert hex.equal(expected, result)
}

// --- Inverse relationship ---

pub fn rotate_clockwise_then_counter_clockwise_is_identity_test() {
  use <- unitest.tags(["unit", "hex_grid", "hex_rotation"])
  // CW followed by CCW must yield the original hex
  let assert Ok(center) = hex.new(0, 0)
  let assert Ok(subject) = hex.new(1, -2)

  let assert Ok(after_cw) = hex.rotate_clockwise(subject, around: center)
  let assert Ok(result) = hex.rotate_counter_clockwise(after_cw, around: center)

  assert hex.equal(subject, result)
}

// --- Helpers ---

fn list_fold_result(
  list: List(a),
  initial: b,
  f: fn(b, a) -> Result(b, String),
) -> Result(b, String) {
  case list {
    [] -> Ok(initial)
    [head, ..tail] ->
      case f(initial, head) {
        Ok(next) -> list_fold_result(tail, next, f)
        Error(e) -> Error(e)
      }
  }
}
