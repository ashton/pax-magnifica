import core/value_objects/game
import unitest

pub fn new_id_valid_test() {
  use <- unitest.tags(["unit", "value_objects", "game"])
  let assert Ok(id) = game.new_id("game_1")
  assert game.id_value(id) == "game_1"
}

pub fn new_id_empty_returns_error_test() {
  use <- unitest.tags(["unit", "value_objects", "game"])
  let assert Error(_) = game.new_id("")
}
