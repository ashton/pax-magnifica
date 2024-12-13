import gleam/string
import gleam/list
import engine/map/command_handler.{process}
import engine/map/events.{MapCreated}
import glacier
import glacier/should

pub fn main() {
  glacier.main()
}

pub fn process_create_map_grid_command_test() {
  let command = commands.create_map_grid(3)

  process(command)
  |> should.be_ok()
  |> list.first()
  |> fn(event) {
    let assert MapCreated(id, grid) = event
    id |> string.is_empty() |> should.be_false()
  }
}
