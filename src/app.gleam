import actors/session_manager
import commands/draft as draft_commands
import commands/game as game_commmands
import commands/player as player_commands
import game/systems
import gleam/io.{debug}
import models/command
import models/common
import models/draft.{Milty}
import models/faction
import models/game.{Second, Speaker}
import models/player.{User}

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

  let start_draft_command =
    draft_commands.prepare_draft(Milty)
    |> command.draft_action(issuer: "")

  let start_game_command =
    game_commmands.start_game(game1_actor_id) |> command.game_action(issuer: "")

  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      create_game_command,
    )

  let _ = session_manager.update_game(session_store, game1_actor_id, join_user1)

  let _ = session_manager.update_game(session_store, game1_actor_id, join_user2)

  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      start_draft_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      start_game_command,
    )

  session_manager.game_state(session_store, game1_actor_id)
  |> debug
}
