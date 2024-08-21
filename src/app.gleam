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

  let pick_faction1_command =
    draft_commands.pick_faction(User(name: "player1"), faction: faction.Nekro)
    |> command.draft_action(issuer: "player1")

  let pick_faction2_command =
    draft_commands.pick_faction(User(name: "player2"), faction: faction.JolNar)
    |> command.draft_action(issuer: "player2")

  let pick_position1_command =
    draft_commands.pick_position(user: User(name: "player1"), position: Speaker)
    |> command.draft_action(issuer: "player1")

  let pick_position2_command =
    draft_commands.pick_position(user: User(name: "player2"), position: Second)
    |> command.draft_action(issuer: "player2")

  let pick_system1_command =
    draft_commands.pick_system(
      user: User(name: "player1"),
      system: systems.planetary_system_4,
    )
    |> command.draft_action(issuer: "player1")

  let pick_system2_command =
    draft_commands.pick_system(
      user: User(name: "player2"),
      system: systems.planetary_system_8,
    )
    |> command.draft_action(issuer: "player2")

  let pick_color1_command =
    draft_commands.pick_color(User(name: "player1"), common.Blue)
    |> command.draft_action(issuer: "player1")

  let pick_color2_command =
    draft_commands.pick_color(User(name: "player1"), common.Yellow)
    |> command.draft_action(issuer: "player2")

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
      pick_faction1_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_faction2_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_position1_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_position2_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_system1_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_system2_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_color1_command,
    )
  let _ =
    session_manager.update_game(
      session_store,
      game1_actor_id,
      pick_color2_command,
    )
  session_manager.game_state(session_store, game1_actor_id)
  |> debug
}
