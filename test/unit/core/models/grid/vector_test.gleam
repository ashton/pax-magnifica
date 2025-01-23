import core/models/hex/vector
import glacier/should

pub fn equal_test() {
  let v1 =
    vector.new(0, 0, 0)
    |> should.be_ok()

  let v2 =
    vector.new(0, 0, 0)
    |> should.be_ok()

  vector.equal(v1, v2)
  |> should.be_true()
}

pub fn from_triplet_test() {
  let v1 =
    #(0, 0, 0)
    |> vector.from_triplet()
    |> should.be_ok()

  let v2 =
    vector.new(0, 0, 0)
    |> should.be_ok()

  vector.equal(v1, v2)
  |> should.be_true()
}

pub fn to_triplet_test() {
  let vec =
    vector.new(0, 0, 0)
    |> should.be_ok()

  vec
  |> vector.to_triplet()
  |> should.equal(#(0, 0, 0))
}

pub fn rotate_clockwise_test() {
  //vector size 1
  vector.new(-1, 1, 0)
  |> should.be_ok()
  |> vector.rotate_clockwise()
  |> vector.equal(vector.new(-1, 0, 1) |> should.be_ok())
  |> should.be_true()

  //vector size 2
  vector.new(-2, 2, 0)
  |> should.be_ok()
  |> vector.rotate_clockwise()
  |> vector.equal(vector.new(-2, 0, 2) |> should.be_ok())
  |> should.be_true()
}

pub fn rotate_counter_clockwise_test() {
  //vector size 1
  vector.new(-1, 1, 0)
  |> should.be_ok()
  |> vector.rotate_counter_clockwise()
  |> vector.equal(vector.new(0, 1, -1) |> should.be_ok())
  |> should.be_true()

  //vector size 2
  vector.new(-2, 2, 0)
  |> should.be_ok()
  |> vector.rotate_counter_clockwise()
  |> vector.equal(vector.new(0, 2, -2) |> should.be_ok())
  |> should.be_true()
}

pub fn scale_test() {
  vector.new(-2, 2, 0)
  |> should.be_ok()
  |> vector.scale(2)
  |> should.equal(vector.new(-4, 4, 0) |> should.be_ok())
}
