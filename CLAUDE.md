# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
gleam run                               # Run the project
gleam test                              # Run all tests with random order
gleam test -- --seed [randomSeed]       # Run tests in a reproducible order
gleam test -- test/mod_test.gleam       # Run all tests in the `module.gleam` file
gleam test -- test/mod_test.gleam:42    # Run test on line 42
gleam test -- --test mod_test.fn_name   # Run a single test in `fn_name` inside `mod_test.gleam` file
gleam format --check src test           # Check formatting
gleam format src test                   # Auto-format code
gleam shell                             # Start Erlang REPL
gleam deps download                     # Install dependencies
```

## Architecture

This is a **Twilight Imperium 4th Edition** game engine written in **Gleam** (functional, statically typed, compiles to Erlang/OTP), using **DDD + CQRS + Event Sourcing** with the **Actor Model**.

### Core Patterns

- **Commands** describe intent (write side). **Events** describe facts (immutable, logged). State is reconstructed by reducing events — never mutated directly.
- **Aggregates** own two responsibilities: (1) `handle_*` validates commands and emits events; (2) `apply(state, event) -> state` folds events back into state. State folding is the aggregate's job — `event_handler.gleam` is not used for this.
- Game lifecycle is a **state machine**: `Initial → Lobby → PlayerSetup → MapSetup → Active → Ended`.
- Each game runs as an isolated **OTP actor** managed by `SessionManager`.

### Development Workflow

#### Adding functionalities
When adding new functionalities ALWAYS use Test Driven Development, generate AT LEAST one, but preferentially multiple test cases BEFORE starting to generate the implementation for the functionality. 

#### Changing existent functionalities
When changing existent functionalities, ALWAYS check if there test cases for that functionality already, BEFORE generating the implementation, try to improve the current test cases or add missing test cases if there is some,
only then, generate the implementation, and at the end, ALWAYS run the tests to make sure the change didn't break anything.

### Layer Structure

| Directory | Responsibility |
|---|---|
| `src/core/models/` | Pure domain types (Player, Game, Map, Hex, Factions, Units…) — no side effects |
| `src/engine/` | Aggregates (validate + fold) and command handlers per bounded context |
| `src/game/` | Static game data (all factions, planets, systems, technologies, units) |
| `src/actors/` | OTP infrastructure: `SessionManager` (registry) and `GameManager` (per-game actor) |
| `src/plugins/` | External adapters (e.g., Tabletop Simulator string parser) |
| `src/utils/` | UUID, Option, Result helpers |
| `test/unit/` | Unit tests mirroring `src/` structure |

### Bounded Contexts (inside `src/engine/`)

- **`lobby/`** — Player joining, seat assignment
- **`game_setup/`** — Aggregate for setup phase (standard vs. Milty Draft modes)
- **`map/`** — Hexagonal board construction and validation
- **`game/phases/lobby/`** — Orchestration of commands/events during the lobby phase
- **`tactical_action/`** — System activation and unit movement during a player's tactical action

#### Internal organization of complex bounded contexts

When a bounded context grows complex, extract domain rules into sub-modules rather than splitting into separate contexts. Sub-modules keep the aggregate thin and readable while avoiding cross-context coordination overhead.

```
engine/tactical_action/
  commands.gleam
  events.gleam
  aggregate.gleam          ← validates commands, emits events, and folds state via apply/2
  activation/
    validation.gleam       ← activation-specific domain rules
  movement/
    validation.gleam       ← movement rules + Outcome type
```

The aggregate delegates validation to sub-modules and translates their results into events. Sub-modules own their domain types (e.g. `movement.Outcome`).

**When to split into a separate bounded context instead:** when a concept can happen independently of the parent action (e.g. faction abilities that move ships outside the normal tactical action flow). Until then, keep it internal.

#### Command enrichment pattern

Aggregates must stay pure (state + command → events, no side-effects). When validation requires data from another bounded context (or player capabilities), the **caller** enriches the command before dispatching:

1. The read-side projection holds the cross-context data (e.g. `GameState.fleets: Dict(Hex, String)`)
2. The actor/command handler queries it, filters to the relevant subset, and adds it to the command (e.g. `enemy_fleets: List(#(Hex, String))`)
3. The aggregate validates using only what the command provides

Player capabilities follow the same pattern: pass the full domain type (e.g. `player_technologies: List(Technology)`), not a derived boolean (e.g. `has_antimass_deflectors: Bool`). The validation derives what it needs from the rich type.

For movement commands, `MovementContext` is the standard enrichment struct. It currently carries `enemy_fleets`, `anomalies`, and `player_technologies`.

This keeps aggregates testable in isolation — tests pass the enriched data directly without needing to set up external state.

#### Two-step mechanics pattern

Some mechanics require an external input between two phases (e.g. dice rolls for gravity rift damage). Model these as a pending-encounter cycle:

1. Phase 1 emits an encounter event (e.g. `GravityRiftEncountered`) that adds a `(from, to)` pair to a `pending_*` field in state via `aggregate.apply`.
2. The actor performs the external action (rolls dice, asks the player) and dispatches a resolve command with the result (e.g. `ResolveGravityRift(units_removed:)`).
3. Phase 2 validates the pending encounter exists, emits a resolved event (e.g. `GravityRiftResolved`), and `aggregate.apply` removes the entry from `pending_*`.

The aggregate stays pure — no randomness, no external calls. Gravity rift is the reference implementation.

### Hexagonal Grid (`src/core/models/hex/`)

TI4 uses a hex map. The implementation uses **axial coordinates** (`hex.gleam`), with cube coordinate conversion (`vector.gleam`), ring operations (`ring.gleam`), and a grid container (`grid.gleam`).

Key functions in `hex.gleam`:
- `distance/2` — hex distance between two positions
- `neighbors/1` — the 6 adjacent hexes
- `path/2` — intermediate hexes on the straight-line route (cube-coordinate lerp), excludes endpoints
- `has_path_avoiding/4` — BFS check: does any path of ≤ N steps exist that avoids a given set of hexes (used for movement blocking)

### Adding a New Command/Event

1. Define the command type in the relevant `commands.gleam` inside the bounded context.
2. Define the event type in the matching `events.gleam`.
3. In `aggregate.gleam`, add a `handle_*` function that validates the command against state and returns the events.
4. In the same `aggregate.gleam`, extend `apply(state, event) -> state` to fold the new event into state.

### Test Organization

#### File layout

```
test/
  helpers/          — shared test helpers imported by multiple test files
    hex.gleam       — hex position fixtures (origin, adjacent, far, …)
    units.gleam     — unit factory functions (carrier, cruiser, fighter, …)
    state.gleam     — TacticalActionState builder
    context.gleam   — MovementContext builders + pub const enemy_id
    anomalies.gleam — anomaly-based MovementContext builders (one helper per anomaly type)
  integration/      — end-to-end flow tests
  unit/             — mirrors src/ structure
    core/…
    engine/…
    plugins/…
```

Split test files by functional concern within a bounded context. For example, `tactical_action` has `system_activation_test.gleam` and `movement_test.gleam` instead of one monolithic `aggregate_test.gleam`. When a test file exceeds ~150 lines of test functions, consider splitting it.

Tests for `aggregate.apply` (state folding) live in `state_fold_test.gleam` per bounded context, tagged with `"state_fold"` as the module tag.

#### Tags

Every test function must start with `use <- unitest.tags([...])` (first line of the body). Tags follow a three-level scheme:

```gleam
use <- unitest.tags(["<kind>", "<context>", "<module>"])
```

| Level | Values |
|---|---|
| kind | `unit`, `integration` |
| context | see table below |
| module | file name without `_test.gleam` (e.g. `movement`, `aggregate`) |

Context tag reference:

| Path | Context tag |
|---|---|
| `test/unit/core/models/grid/` | `hex_grid` |
| `test/unit/core/value_objects/` | `value_objects` |
| `test/unit/engine/action_phase/` | `action_phase` |
| `test/unit/engine/game_setup/` | `game_setup` |
| `test/unit/engine/lobby/` | `lobby` |
| `test/unit/engine/map/` | `map` |
| `test/unit/engine/scoring/` | `scoring` |
| `test/unit/engine/strategic_action/` | `strategic_action` |
| `test/unit/engine/strategy_phase/` | `strategy_phase` |
| `test/unit/engine/tactical_action/` | `tactical_action` |
| `test/unit/plugins/` | `plugins` |
| `test/integration/` | use filename as context, omit module tag |

Run a subset of tests by tag:

```bash
gleam test -- --tag tactical_action   # all tests for a bounded context
gleam test -- --tag movement          # all tests for a specific module
gleam test -- --tag unit              # all unit tests
gleam test -- --tag integration       # all integration tests
```

### README

`README.md` contains the full DDD blueprint: Bounded Contexts, Ubiquitous Language glossary, and the complete Command/Event catalog. Read it for domain terminology and design intent before making significant domain changes.
