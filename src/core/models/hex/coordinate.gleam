pub opaque type Coordinate {
  Coordinate(x: Int, y: Int)
}

pub fn new(x: Int, y: Int) {
  Coordinate(x:, y:)
}

pub fn from_pair(pair: #(Int, Int)) {
  let #(x, y) = pair

  Coordinate(x:, y:)
}

pub fn to_pair(coord: Coordinate) -> #(Int, Int) {
  let Coordinate(x:, y:) = coord

  #(x, y)
}
