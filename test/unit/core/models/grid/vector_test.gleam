import core/models/hex/vector

pub fn equal_test() {
  let assert Ok(v1) = vector.new(0, 0, 0)
  let assert Ok(v2) = vector.new(0, 0, 0)

  assert vector.equal(v1, v2)
}

pub fn from_triplet_test() {
  let assert Ok(v1) = #(0, 0, 0) |> vector.from_triplet()
  let assert Ok(v2) = vector.new(0, 0, 0)

  assert vector.equal(v1, v2)
}

pub fn to_triplet_test() {
  let assert Ok(subject) = vector.new(0, 0, 0)

  assert #(0, 0, 0) == vector.to_triplet(subject)
}

pub fn rotate_clockwise_test() {
  //vector size 1
  let assert Ok(subject) = vector.new(-1, 1, 0)
  let res = subject |> vector.rotate_clockwise()

  let assert Ok(expectation) = vector.new(-1, 0, 1)
  assert expectation == res

  //vector size 2
  let assert Ok(subject) = vector.new(-2, 2, 0)
  let res = subject |> vector.rotate_clockwise()

  let assert Ok(expectation) = vector.new(-2, 0, 2)
  assert expectation == res
}

pub fn rotate_counter_clockwise_test() {
  //vector size 1
  let assert Ok(subject) = vector.new(-1, 1, 0)
  let res = subject |> vector.rotate_counter_clockwise()

  let assert Ok(expectation) = vector.new(0, 1, -1)
  assert expectation == res

  //vector size 2
  let assert Ok(subject) = vector.new(-2, 2, 0)
  let res = subject |> vector.rotate_counter_clockwise()

  let assert Ok(expectation) = vector.new(0, 2, -2)
  assert expectation == res
}

pub fn scale_test() {
  let assert Ok(subject) = vector.new(-2, 2, 0)

  let res = subject |> vector.scale(2)

  let assert Ok(expectation) = vector.new(-4, 4, 0)
  assert expectation == res
}
