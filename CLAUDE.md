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
- **Aggregates** validate commands and emit events. **Event handlers** fold events into state.
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
| `src/engine/` | Command handlers, event handlers, aggregates per bounded context |
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

### Hexagonal Grid (`src/core/models/hex/`)

TI4 uses a hex map. The implementation uses **axial coordinates** (`hex.gleam`), with cube coordinate conversion (`vector.gleam`), ring operations (`ring.gleam`), and a grid container (`grid.gleam`).

### Adding a New Command/Event

1. Define the command type in the relevant `commands.gleam` inside the bounded context.
2. Define the event type in the matching `events.gleam`.
3. Implement the command handler (validates state → returns events).
4. Implement the event handler (folds event into state).

### README

`README.md` contains the full DDD blueprint: Bounded Contexts, Ubiquitous Language glossary, and the complete Command/Event catalog. Read it for domain terminology and design intent before making significant domain changes.
