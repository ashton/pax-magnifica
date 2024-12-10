import actors/session_manager
import core/models/player.{User}
import engine/commands/game as game_commmands
import engine/commands/player as player_commands
import engine/models/command

pub fn main() {
  // Start the live sessions registry.
  let assert Ok(session_store) = session_manager.start()

  let game1_actor_id = session_manager.new_game(session_store)

  let create_game_command =
    game_commmands.init_game(game1_actor_id)
    |> command.game_action(issuer: "")

  let join_user1 =
    player_commands.join_lobby(User(name: "player1"))
    |> command.player_action(issuer: "")

  let join_user2 =
    player_commands.join_lobby(User(name: "player2"))
    |> command.player_action(issuer: "")
}
