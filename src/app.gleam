import actors/session_manager
import events/game as game_events
import game/factions
import game/systems
import gleam/io.{debug, println}
import gleam/list
import models/common.{Black, Blue}
import models/event.{NoSource}
import models/game
import models/map.{Tile}
import models/player.{User}

pub fn main() {
  println("creating map")
  let map =
    systems.all_systems
    |> list.index_map(fn(system, index) { Tile(index, system) })
    |> map.init()

  println("creating player 1")
  let player1 =
    player.setup_player(player.User(name: "Player 1"), factions.make_arborec())

  println("creating player 2")
  let player2 =
    player.setup_player(player.User(name: "Player 2"), factions.make_saar())

  let game =
    game.setup_game(players: [#(Black, player1), #(Blue, player2)], map: map)

  let game2 =
    game.setup_game(players: [#(Blue, player1), #(Black, player2)], map: map)

  // Start the live sessions registry.
  let assert Ok(session_store) = session_manager.start()
  let assert Ok(game_session) = session_manager.new_session(session_store)

  println("game session")
  session_manager.fetch_session_details(game_session)
  |> debug

  //game created event
  let game_created_event =
    game_events.game_created() |> event.game_event(NoSource)

  let player1 =
    player.setup_player(
      User(name: "Player 1"),
      faction: factions.make_yssaril(),
    )
  let player1_joined_event =
    game_events.player_joined("game_id", player1)
    |> event.game_event(NoSource)

  session_manager.update_session_details(game_session, [game_created_event])

  println("updated game session")
  session_manager.fetch_session_details(game_session)
  |> debug
}
