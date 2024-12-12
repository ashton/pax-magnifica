import core/models/hex/coordinate.{type Coordinate}

pub opaque type HexGridRing {
  HexGridRing(ring_number: Int, coordinates: List(Coordinate))
}

pub fn new(
  number number: Int,
  coordinates coordinates: List(Coordinate),
) -> HexGridRing {
  HexGridRing(ring_number: number, coordinates:)
}

pub fn number(ring: HexGridRing) -> Int {
  let HexGridRing(ring_number:, ..) = ring

  ring_number
}

pub fn coordinates(ring: HexGridRing) -> List(Coordinate) {
  let HexGridRing(coordinates:, ..) = ring

  coordinates
}
