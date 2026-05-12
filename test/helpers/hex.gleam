import core/models/hex/hex.{type Hex}

// At distance 2 from origin() with two possible intermediate hexes:
// adjacent()=(1,-1) and alt_intermediate()=(1,0). Used to test path routing.
pub fn origin() -> Hex {
  let assert Ok(h) = hex.new(0, 0)
  h
}

pub fn adjacent() -> Hex {
  let assert Ok(h) = hex.new(1, -1)
  h
}

pub fn far() -> Hex {
  let assert Ok(h) = hex.new(2, -2)
  h
}

pub fn two_paths_from() -> Hex {
  let assert Ok(h) = hex.new(2, -1)
  h
}

pub fn alt_intermediate() -> Hex {
  let assert Ok(h) = hex.new(1, 0)
  h
}

// At distance 3 from origin(). Intermediate hexes (via hex.path) are far() and
// adjacent() — useful for testing two-rift scenarios.
pub fn three_away() -> Hex {
  let assert Ok(h) = hex.new(3, -3)
  h
}
