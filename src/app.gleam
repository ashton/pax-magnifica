import actors/session_manager
import commands/game as game_commmands
import commands/player as player_commands
import gleam/io.{debug}
import models/command
import models/player.{User}

pub fn main() {
  // Start the live sessions registry.
  let assert Ok(session_store) = session_manager.start()

  let game1_actor_id = session_manager.new_game(session_store)

  let create_game_command =
    game_commmands.init_game(game1_actor_id)
    |> command.game_action()
    |> command.new(issuer: "")

  let join_user1 =
    player_commands.join_lobby(User(name: "player1"))
    |> command.player_action()
    |> command.new(issuer: "")

  let join_user2 =
    player_commands.join_lobby(User(name: "player2"))
    |> command.player_action()
    |> command.new(issuer: "")

  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      create_game_command,
    )

  let _ = session_manager.update_game(session_store, game1_actor_id, join_user1)

  let _ = session_manager.update_game(session_store, game1_actor_id, join_user2)

  session_manager.game_state(session_store, game1_actor_id)
  |> debug
}
