import core/value_objects/game

pub fn new_id_valid_test() {
  let assert Ok(id) = game.new_id("game_1")
  assert game.id_value(id) == "game_1"
}

pub fn new_id_empty_returns_error_test() {
  let assert Error(_) = game.new_id("")
}
