import actors/game_manager
import chip
import engine/models/command.{type Command}
import gleam/result

pub fn start() {
  chip.start()
}

pub fn new_game(registry) {
  let #(actor_id, game_actor) = game_manager.new_game_actor()

  game_actor
  |> chip.new()
  |> chip.tag(actor_id)
  |> chip.register(registry, _)

  actor_id
}

pub fn update_game(registry, id: String, command: Command) {
  chip.find(registry, id)
  |> result.map(game_manager.update_game(_, command))
}

pub fn game_state(registry, game_id: String) {
  chip.find(registry, game_id)
  |> result.replace_error("Not found")
  |> result.then(game_manager.game_state)
}
