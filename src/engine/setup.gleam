import engine/game/aggregate
import engine/game/entity
import eventsourcing
import eventsourcing/memory_store
import gleam/erlang/process
import gleam/option.{None}
import gleam/otp/static_supervisor
import utils/uuid

pub fn start() {
  let id = uuid.new()
  let events_name = process.new_name("game_events_" <> id)
  let snapshot_name = process.new_name("game_snapshots_" <> id)

  let #(eventstore, memory_store_spec) =
    memory_store.supervised(
      events_name,
      snapshot_name,
      static_supervisor.OneForOne,
    )

  let assert Ok(_) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(memory_store_spec)
    |> static_supervisor.start()

  let es_name = process.new_name("game_es_" <> id)

  let assert Ok(es_spec) =
    eventsourcing.supervised(
      name: es_name,
      eventstore: eventstore,
      handle: aggregate.handle,
      apply: aggregate.apply,
      empty_state: entity.initial(),
      queries: [],
      snapshot_config: None,
    )

  let assert Ok(_) =
    static_supervisor.new(static_supervisor.OneForOne)
    |> static_supervisor.add(es_spec)
    |> static_supervisor.start()

  process.named_subject(es_name)
}
