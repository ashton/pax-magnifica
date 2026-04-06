# pmbg_ti4

[![Package Version](https://img.shields.io/hexpm/v/pmbg_ti4)](https://hex.pm/packages/pmbg_ti4)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/pmbg_ti4/)

```sh
gleam add pmbg_ti4
```
```gleam
import pmbg_ti4

pub fn main() {
  // TODO: An example of the project in use
}
```

Further documentation can be found at <https://hexdocs.pm/pmbg_ti4>.

## Development

```sh
gleam run   # Run the project
gleam test  # Run the tests
gleam shell # Run an Erlang shell
```

# A Domain-Driven Design Blueprint for a Digital Twilight Imperium

## I. Introduction: Framing the Galactic Conquest

*Twilight Imperium 4th Edition* (TI4) is a masterpiece of complexity in tabletop gaming. It's a domain defined by a vast number of components—over 350 units, 450 cards, and 700 tokens—and a modular board that ensures no two games are the same. The game's epic narrative of conquest, politics, and trade unfolds over a notoriously long playtime, often lasting from five to fourteen hours. This sheer scale makes a digital adaptation a formidable challenge. A simple data-centric software model would inevitably fail under the weight of TI4's intricate and highly contextual rules. The game is a dynamic system of interacting behaviors, faction-specific exceptions, and strict procedures. To succeed, we need a more sophisticated approach. **Domain-Driven Design (DDD)** provides the necessary tools, shifting our focus from database tables to the rich, living domain of the game itself.

DDD is a software philosophy that prioritizes a deep understanding of the domain. It mandates a focus on the game's rules as the central concern and emphasizes the use of a **Ubiquitous Language**—a shared, unambiguous vocabulary used by developers and in the code. For TI4, this language is already expertly defined in the official *Living Rules Reference*. This report will use DDD to create a blueprint for a digital TI4, starting with high-level **Bounded Contexts** to partition the game's complexity, then moving to tactical design of **Aggregates**, **Entities**, and **Value Objects** that form the core model.

The goal is to deliver a comprehensive, rule-adherent DDD model that can serve as the architectural foundation for a fully automated digital version of TI4. This engine must manage the game's complex state, enforce its vast ruleset, and resolve intricate player interactions without ambiguity, supporting both real-time and asynchronous "play-by-post" styles popular in the online community.

---
## II. Strategic Design: Defining the Bounded Contexts of the Imperium

The first step in taming a domain as vast as TI4 is strategic decomposition. We partition the domain into several distinct **Bounded Contexts**. Each context is a self-contained subdomain with its own specific responsibilities and models, forming the foundational architecture of the system.

### A. The Game Setup Context 🛠️

This context is a specialized, transient "factory" responsible for the entire pre-game procedure. Its lifecycle begins when a new game is initiated and ends the moment the first round starts. Its sole purpose is to manage the complex, multi-step setup process and produce the initial, valid state for the main game engine. This context is flexible enough to handle both the standard rules-as-written setup and popular community variants like the **Milty Draft**. If the Prophecy of Kings expansion is used, this context is also responsible for placing a **Frontier Token** in each system that does not contain a planet and is not a home system.

The core of this context is a single, stateful aggregate root: `GameSetup`. This aggregate acts as a state machine, enforcing the correct sequence of actions based on the chosen `setupType`.
* For a **`standard`** setup, it enforces the 12-step process from the rulebook: players choose factions, then collaboratively build the galaxy.
* For a **`milty`** setup, it manages a completely different flow, orchestrating a snake draft where players select from a pre-generated pool of galaxy "slices," factions, and speaker positions.

The `GameSetup` aggregate's final output is the initial state of the `Player` and `GameBoard` aggregates. Upon completion, it emits a `GameStarted` event containing this initial state, which is then handed off to the Core Gameplay Context. This creates a clean separation between the rules of *setting up* a game and the rules of *playing* it.

---
### B. The Core Gameplay Context 🎲

This is the heart of the application—the primary "game engine." It is the authoritative source for the canonical state of the galaxy and is responsible for enforcing the game's rules during play. Its primary function is to maintain the state of the two most important Aggregates: the shared `GameBoard` and each individual `Player`. It processes all player-initiated actions—be they Tactical, Strategic, or Component actions—by validating their legality against the current game state and the comprehensive ruleset. Upon successful validation, it updates the state of the relevant aggregates, ensuring the game remains in a consistent and valid state at all times. This context relies heavily on the **Rules Engine Subdomain** to correctly apply dynamic rule modifications.

---
### C. The Game Flow Context ➡️

This context acts as the game's master conductor or state machine. Its sole concern is orchestrating the progression of the game through its rigidly defined phases. It is distinct from the Core Gameplay Context because its responsibility is not *what* happens, but *when* it happens. It manages the immutable sequence of a `Game Round`: `Strategy Phase`, `Action Phase`, `Status Phase`, and `Agenda Phase`. It determines the `Active Player` based on `Initiative Order` and signals the beginning and end of each phase and turn. This separation is crucial for managing the game's tempo and enabling asynchronous play. For implementation, this orchestration is managed by an internal **`GameFlowManager`** entity, a special kind of state machine that reacts to game events to drive the workflow forward.

---
### D. The Combat Resolution Context 💥

This is a specialized, transient context that is invoked by the Core Gameplay Context whenever a space or ground combat is initiated. It exists to encapsulate the complex, multi-step, and often interactive sequence of a battle. Its lifecycle begins when combat starts and ends when a victor is determined. It manages the entire lifecycle of a `Space Combat` or `Ground Combat` instance, rigorously following the sequence of steps: `Anti-Fighter Barrage`, `Announce Retreats`, `Roll Dice`, `Assign Hits`, and `Retreat`. This context is a primary consumer of the **Rules Engine**, querying it at multiple steps (e.g., before rolling dice, when assigning hits) to check for any active abilities that could alter the outcome.

---
## III. The Ubiquitous Language: A Glossary for Galactic Rule

The foundation of any DDD project is the **Ubiquitous Language**—a single, shared vocabulary used in all conversations and code. For TI4, we adopt the official terminology from the *Rules Reference* with absolute fidelity to eliminate ambiguity and ensure the software model is a direct reflection of the domain.

* **Core Actions:** Activate, Control, Exhaust, Ready, Produce, Destroy, Move, Score.
* **Key Concepts:**
    * **Anomaly:** A special hazardous condition in a system tile, such as a Nebula or Asteroid Field. Its effects are modeled as a `Rule` within the Rules Engine.
    * **Exploration:** A special action in the Prophecy of Kings expansion that allows a player to draw a card from a deck corresponding to a planet's trait (Cultural, Hazardous, Industrial) or from a Frontier deck.
    * **Frontier Token:** A token placed on empty, non-home systems during setup in a Prophecy of Kings game, which can be explored.
    * **Rule:** A structured object representing a modification to the game's standard procedures. Rules originate from various sources (factions, technologies, agendas) and are managed by the **Rules Engine**.
    * **System Tile:** A hexagonal tile representing a region of space. In the model, `SystemTile` refers to the static "blueprint" of a tile (its name, anomalies, planets). A `SystemTileInstance` is a specific tile on the board with a dynamic state.
    * **Planet:** A celestial body within a system. In the model, a `Planet` object refers to the static "blueprint" data of a planet (its name, base values, trait). A `PlanetInstance` is a specific planet on the board that can be controlled and exhausted.
    * **Unit:** A physical piece on the board, categorized as a `Ship`, `Ground Force`, or `Structure`.
    * **Command Token:** A finite resource used to perform Tactical Actions, activate Strategy Card secondaries, and determine fleet size.
    * **Fleet Pool:** The area on a player's command sheet holding command tokens that determine the maximum number of non-fighter ships allowed in a single system.
    * **Resources:** A planet's economic value, spent to `Produce` units and use certain technologies.
    * **Influence:** A planet's political value, spent to gain command tokens and cast votes during the Agenda Phase.
    * **Commodities & Trade Goods:** Economic tokens representing a player's wealth. Commodities must be traded to become versatile Trade Goods.
    * **Technology:** A card representing a scientific advancement that provides a player with new abilities or unit upgrades.
    * **Strategy Card:** One of eight powerful cards chosen each round that grants a unique primary action and determines initiative order.
    * **Action Card:** A card drawn by players that provides a variety of tactical effects and interrupts.
    * **Agenda Card:** A card representing a galactic law or directive that is voted on during the Agenda Phase.
    * **Objective Card:** A card (either Public or Secret) that specifies a condition which, when met, allows a player to `Score` victory points.
* **Important States:** Active System, Active Player, Neighbors, Blockaded, Damaged.

---
## IV. A Catalog of Commands and Events by Context

The domain's dynamics are captured through **Commands** (a player's intent to change state) and **Events** (a factual record of a state change that has occurred). This catalog details the specific commands and events for each Bounded Context.

### A. Game Setup Context

This context's single aggregate, `GameSetup`, processes commands to build the game state. The process it follows depends on the `setupType` chosen at creation.

* **Aggregate Root:** `GameSetup` (Identified by `GameId`)
* **Commands (Intents):**
    * `CreateGame(gameId, playerCount, victoryPointTarget, setupType: 'standard' | 'milty', expansionFlags, miltyDraftSettings)`
    * `JoinGame(accountId, color)`
    * **Standard Setup Commands:**
        * `ChooseFaction(playerId, factionId)`
        * `PlaceSystemTile(playerId, tileId, location)`
    * **Milty Draft Commands:**
        * `GenerateMiltyDraftOptions(gameId, settings)`
        * `DraftSlice(playerId, sliceId)`
        * `DraftFaction(playerId, factionId)`
        * `DraftPosition(playerId, positionId)`
    * **Finalization Commands (Both Setups):**
        * `ChooseSecretObjective(playerId, objectiveId)`
        * `StartGame()`
* **Events (Facts):**
    * `GameCreated(gameId, playerCount, victoryPointTarget, setupType, expansionFlags)`
    * `PlayerJoined(playerId, accountId, color)`
    * `SpeakerAppointed(playerId)`
    * `FrontierTokensPlaced(tokenLocations)`
    * **Standard Setup Events:**
        * `FactionChosen(playerId, factionId)`
        * `SystemTilePlaced(playerId, tileId, location)`
        * `GalaxyBuildCompleted()`
    * **Milty Draft Events:**
        * `MiltyDraftOptionsGenerated(slices, factions, positions)`
        * `SliceDrafted(playerId, sliceId)`
        * `FactionDrafted(playerId, factionId)`
        * `PositionDrafted(playerId, positionId)`
        * `MiltyDraftCompleted()`
    * **Finalization Events (Both Setups):**
        * `StartingComponentsDistributed(playerId, components)`
        * `SecretObjectiveChosen(playerId, objectiveId)`
        * `InitialPublicObjectivesRevealed(objectiveIds)`
        * `GameSetupCompleted()`
        * `GameStarted(initialPlayerStates, initialGameBoardState)`

---
### B. Game Flow Context

This context orchestrates the game's sequence, primarily by reacting to events from other contexts via its internal `GameFlowManager` entity.

* **Events:** `GameRoundStarted`, `StrategyPhaseBegun`, `ActionPhaseBegun`, `PlayerTurnBegun`, `PlayerPassed`, `StatusPhaseBegun`, `AgendaPhaseBegun`, `GameEnded`.

---
### C. Core Gameplay Context

This context processes the main player actions affecting the `Player` and `GameBoard` aggregates.

* **Aggregate Roots:** `Player`, `GameBoard`
* **Commands:** `PerformTacticalAction`, `PerformStrategicAction`, `PlayActionCard`, `ScorePublicObjective`, `ExplorePlanet`, `ExploreFrontier`, `ConductTransaction`, `PassActionPhase`, `VoteOnAgenda`.
* **Events:** `SystemActivated`, `ShipsMoved`, `PlanetExplored`, `FrontierExplored`, `PlanetControlChanged`, `UnitsProduced`, `TechnologyResearched`, `ActionCardDrawn`, `PublicObjectiveScored`, `VictoryPointsGained`, `AgendaRevealed`, `LawEnacted`.

---
### D. Combat Resolution Context

This context manages the multi-step combat process.

* **Aggregate Root:** `Combat` (Transient)
* **Commands:** `ResolveCombat`, `AnnounceRetreat`, `AssignHits`.
* **Events:** `SpaceCombatInitiated`, `AntiFighterBarrageFired`, `CombatRollsMade`, `HitsAssigned`, `UnitSustainedDamage`, `UnitDestroyedInCombat`, `CombatConcluded`.

---
## V. The Player Aggregate: The Seat of Power

An **Aggregate** is a cluster of objects treated as a single unit for state changes. The `Player` Aggregate represents a single player and all components under their direct control, acting as a "consistency boundary" to enforce rules.

### A. Aggregate Root: `Player` Entity

The `Player` entity is the entry point for all commands modifying a player's state.

* **Identifiers:** The `Player` entity uses two identifiers for different purposes:
    * **`PlayerId`**: A transient identifier, unique only within the context of a single game (e.g., "Player 3 in Game #123"). It represents the player's role in this specific match.
    * **`AccountId`**: A permanent, global identifier (e.g., a GUID) that uniquely identifies the human being across the entire system. This acts as a stable link to a `User` entity in a separate `Identity & Access Management` Bounded Context, which would manage details like screen names and emails.
* **State:** Holds fundamental player information such as `PlayerColor`, current `VictoryPoints`, and a reference to their unique `FactionSheet`.

---
### B. Internal Entities

* **`FactionSheet` 📜:** This entity's identity is the faction itself. It acts as a comprehensive container for all the unique rules and starting components that define that faction.
    * **`FactionId`**: A unique identifier (e.g., `jol_nar`, `hacan`).
    * **`FactionName`**: The display name (e.g., "The Universities of Jol-Nar").
    * **`CommodityValue`**: An integer representing their trade good icon value.
    * **`StartingUnits`**: A collection of `UnitType` and quantity pairs for game start.
    * **`StartingTechnologies`**: A list of `TechnologyId`s the player begins with.
    * **`FactionAbilities`**: A collection of `Rule` objects that represent the faction's unique, permanent abilities.
    * **`PromissoryNote`**: An object detailing the unique text and effect of their special promissory note.
    * **`Leaders`**: (For Prophecy of Kings) A collection holding the state and abilities of the faction's `Agent`, `Commander`, and `Hero`.
    * **`UpgradedUnitStats`**: A map linking faction-specific technologies to the unit upgrades they unlock.
* **`CommandSheet`:** This entity manages the allocation of a player's command tokens across the three distinct pools: `Tactic`, `Fleet`, and `Strategy`.

---
### C. Value Objects

* **`CommandPools`:** An immutable object representing the counts of tokens in the three pools.
* **`Wallet`:** An immutable object containing the counts of `TradeGoods` and `Commodities`.

---
### D. Owned Collections

The `Player` Aggregate owns and manages collections of various game components: `Technologies`, `ActionCards`, `PromissoryNotes`, `Objectives`, `RelicFragments`.

---
## VI. The Game Board Aggregate: Mapping the Galaxy

The `GameBoard` Aggregate represents the shared space where all player interactions occur. It is the single source of truth for the location of every unit, the control of every planet, and the spatial relationships between every system in the galaxy.

### The "Blueprint vs. Building" Model for Static Data

A core design principle for this aggregate is the separation of a component's static "blueprint" from its dynamic "building" instance. At application startup, all static game data (e.g., from JSON files defining planets and system tiles) is loaded into memory as rich, immutable domain objects (e.g., `Planet`, `SystemTile`). These are stored in a central, in-memory registry. The entities within the `GameBoard` aggregate (`PlanetInstance`, `SystemTileInstance`) then hold a direct reference to these rich domain objects, making the model expressive and self-contained.

---
### Managing the Galactic Layout 🗺️

The `GameBoard` entity manages the positions of all tiles using a coordinate system suitable for a hexagonal grid, such as **axial or cube coordinates**. The core of its state is a map where the key is a `Coordinate` Value Object and the value is the corresponding `SystemTileInstance` entity. This structure allows the `GameBoard` to enforce critical rules like placement (no two tiles in the same location) and adjacency (including wormholes).

---
### `GameBoard` Entity Attributes 📝

The root entity holds the tile grid and any other state that belongs to the board as a whole.

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`gameId`** | `GameId` | The unique identifier for the game. |
| **`tileGrid`** | `Map<Coordinate, SystemTileInstance>` | The core data structure mapping each coordinate to the `SystemTileInstance` at that location. |
| **`wormholeIndex`** | `Map<WormholeType, List<Coordinate>>` | A lookup map to quickly find all systems containing a specific type of wormhole. |
| **`custodiansTokenLocation`** | `PlanetId` (nullable) | The ID of Mecatol Rex, where the Custodians token is located. Null once taken. |
| **`publicObjectiveDeck`** | `Deck<ObjectiveCard>` | The face-down deck of public objective cards. |
| **`revealedObjectives`** | `List<ObjectiveCard>` | The list of currently revealed public objectives. |
| **`actionCardDeck`** | `Deck<ActionCard>` | The face-down deck of action cards. |
| **`agendaDeck`** | `Deck<AgendaCard>` | The face-down deck of agenda cards. |
| **`culturalExplorationDeck`** | `Deck<ExplorationCard>` | (PoK) The deck for exploring Cultural planets. |
| **`hazardousExplorationDeck`** | `Deck<ExplorationCard>` | (PoK) The deck for exploring Hazardous planets. |
| **`industrialExplorationDeck`** | `Deck<ExplorationCard>` | (PoK) The deck for exploring Industrial planets. |
| **`frontierExplorationDeck`** | `Deck<ExplorationCard>` | (PoK) The deck for exploring frontier tokens. |
| **`activeLaws`** | `List<Rule>` | A list of all `Rule` objects originating from "Law" agendas that are currently affecting the game. |

---
### Internal Entity: `SystemTileInstance` 🪐

This entity represents a specific hex tile placed on the board. Its state changes as command tokens are placed or ships move in.

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`location`** | `Coordinate` | The unique identifier for this entity within the `GameBoard`; its position on the grid. |
| **`systemTile`** | `SystemTile` | A direct reference to the rich, immutable "blueprint" `SystemTile` object, defining its name, planets, anomalies, etc. |
| **`hasFrontierToken`** | `boolean` | (PoK) `true` if this system contains an un-explored frontier token. |
| **`commandTokens`** | `List<PlayerId>` | A list of player IDs who have a command token in this system. |
| **`shipsInSpace`** | `List<UnitInstanceId>` | A list of IDs for the `UnitInstance` entities currently in the space area of this system. |
| **`planetInstanceIds`** | `List<PlanetId>` | A list of IDs for the `PlanetInstance` entities that exist within this system. |

---
### Internal Entity: `PlanetInstance` 🪐

This entity represents a single planet on the board, tracking its unique state.

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`planetId`** | `PlanetId` | The unique identifier for this entity (e.g., `mecatol_rex`). |
| **`planetData`** | `Planet` | A direct reference to the rich, immutable "blueprint" `Planet` object, defining its name, resources, influence, trait, etc. |
| **`controllingPlayerId`** | `PlayerId` (nullable) | The ID of the player who currently controls the planet. `null` if uncontrolled. |
| **`isExhausted`** | `boolean` | `true` if the planet's resources/influence have been spent this round. |
| **`unitsOnPlanet`** | `List<UnitInstanceId>` | A list of IDs for ground forces and structures on this planet's surface. |
| **`attachedCards`** | `List<CardId>` | A list of IDs for cards (e.g., exploration attachments) attached to this planet. |

---
### Blueprint Domain Objects: `SystemTile` and `Planet` 📜

These are the rich, immutable "blueprint" objects that are loaded at application startup. They represent the static definitions of the game's components.

#### `SystemTile` Object Attributes

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`systemTileId`** | `SystemTileId` | The unique identifier from the physical game (e.g., `tile_18`). |
| **`name`** | `string` | The display name of the system (e.g., "Mecatol Rex"). |
| **`anomaly`** | `Enum` (nullable) | The type of anomaly in the system, if any (e.g., `NEBULA`, `ASTEROID_FIELD`). |
| **`wormholes`** | `List<Enum>` | A list of wormhole types present in the system (e.g., `[ALPHA]`). |
| **`planetIds`** | `List<PlanetId>` | A list of IDs for the `Planet` blueprints that are on this tile. |

#### `Planet` Object Attributes

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`planetId`** | `PlanetId` | The unique identifier for the planet blueprint (e.g., `mecatol_rex`). |
| **`name`** | `string` | The display name of the planet (e.g., "Mecatol Rex"). |
| **`resources`** | `integer` | The base resource value of the planet. |
| **`influence`** | `integer` | The base influence value of the planet. |
| **`trait`** | `Enum` (nullable) | The planet's trait, if any (e.g., `CULTURAL`, `INDUSTRIAL`, `HAZARDOUS`). |
| **`techSpecialty`** | `Enum` (nullable) | The planet's technology specialty, if any (e.g., `BIOTIC`, `WARFARE`). |

---
## VII. The Core Rules Engine Subdomain ⚖️

A core challenge in modeling TI4 is that its rules are not static; they are constantly modified by factions, technologies, action cards, and agendas. To manage this complexity, we introduce a dedicated **Rules Engine Subdomain**. This is a foundational, cross-cutting component that other contexts rely on. Instead of services like `MovementService` or `CombatService` needing to know about every possible rule exception, they have a single point of contact: the `RulesEngine`.

### A. The Unified `Rule` Object
Every special rule in the game, regardless of its source, is modeled as a universal `Rule` object.

| Attribute | Type / Description | Purpose |
| :--- | :--- | :--- |
| **`ruleId`** | `RuleId` | A unique identifier for this rule instance (e.g., `action_card_sabotage_1`). |
| **`source`** | `Source` | A Value Object indicating where the rule came from (e.g., `{ type: FACTION_ABILITY, id: 'jol_nar_fragile' }` or `{ type: TECHNOLOGY, id: 'dark_energy_tap' }`). |
| **`trigger`** | `Enum` | The specific "hook" or moment in the game when this rule should be checked (e.g., `PRE_COMBAT_ROLL`). |
| **`effect`** | `Effect` | The Value Object describing the actual modification to the rules (e.g., `MODIFY_COMBAT_ROLL`, `ADD_ACTION`). The implementation of the effect follows the **Strategy Pattern**. |
| **`duration`** | `Enum` | How long the rule is active (e.g., `PERMANENT`, `THIS_ACTION`, `THIS_ROUND`). |

---
### B. The Central `RulesRegistry`
This is a stateful object within the `Core Gameplay Context` that holds a collection of all **currently active** `Rule` objects from all sources.
* **At Game Start:** The registry is populated with all `PERMANENT` rules from each player's `FactionSheet` and the rules for any anomalies on the board.
* **When a Technology is Researched:** The `Rule` object associated with that technology is added to the registry.
* **When an Action Card is Played:** The `Rule` from that card is temporarily added to the registry.
* **When a Law is Passed:** The `Rule` from the Agenda Card is added to the registry with a `PERMANENT` duration.

---
### C. The `RulesEngine` in Action
The `RulesEngine` is a **stateless domain service** that knows how to query the `RulesRegistry` to get a complete picture of the current rules.

**Example: The Jol-Nar's "Fragile" ability in combat.**
1. The `CombatResolutionContext` needs to resolve a combat roll.
2. It asks the central `RulesEngine`: **"What are the combat modifiers for Player X for a `PRE_COMBAT_ROLL` trigger?"**
3. The `RulesEngine` queries the `RulesRegistry` for all active rules that match the player and trigger.
4. It finds the `jol_nar_fragile` rule, inspects its `effect`, and returns a `-1` modifier.
5. The `CombatResolutionContext` receives the `-1` modifier and applies it, without ever needing to know the rule's source.

This design cleanly separates the process of an action from the ever-changing rules that govern it, making the entire system robust, logical, and highly extensible.

---
## VIII. The Game Setup Context: A Deeper Look 🧐

To handle the complexity of both standard and Milty Draft setups, the `GameSetup` aggregate is designed as a sophisticated state machine.

* **Aggregate Root (`GameSetup` Entity):** This is the master entity for the entire setup process, identified by the `GameId`. It holds the overall state, such as `SetupPhase`, a list of `Players`, and the chosen `setupType`.
* **Internal Entities:**
    * **`MiltyDraftInstance`:** This entity exists only when `setupType` is `milty`. It is the "Draft Master," responsible for managing the state and integrity of the draft. Its state includes:
        * **`DraftPool`:** An internal object holding the collections of available options: `List<Slice>`, `List<FactionId>`, `List<Position>`.
        * **`DraftOrder`:** An ordered list of `PlayerId`s for the snake draft.
        * **`CurrentDrafterIndex`:** A pointer to the current player in the `DraftOrder`.
        * **`PlayerPicks`:** A map of `PlayerId` to the choices they have made.
* **Value Objects:**
    * **`Slice`:** An immutable object defined by its attributes, not a persistent identity.
        * **Attributes:** `SliceId` (a readable name like "Slice A"), an immutable `List<SystemTileId>` of its five tiles, and pre-calculated metrics like `OptimalResources` and `OptimalInfluence` for balancing.
    * **`Position`:** An immutable object describing a player's seat relative to the Speaker.
        * **Attributes:** `Description` (e.g., "Speaker", "2nd Position") and `Order` (an integer, 1, 2, etc.).

When the aggregate receives a command like `DraftSlice`, it validates that it's the correct player's turn and that the chosen `Slice` is available in the `DraftPool`. If valid, it emits the `SliceDrafted` event. The aggregate's state is then updated by applying this event: the slice is removed from the `DraftPool`, associated with the player in `PlayerPicks`, and the `CurrentDrafterIndex` is advanced. This ensures a consistent and rule-adherent draft process.

---
## IX. Conclusion

By applying the principles of Domain-Driven Design, we can systematically deconstruct the monumental complexity of *Twilight Imperium 4th Edition*. This blueprint, with its clear **Bounded Contexts**, a precise **Ubiquitous Language**, and robust **Aggregates**, provides a solid foundation. The event-driven architecture using specific **Commands** and **Events** is perfectly suited to the game's reactive, interrupt-driven nature and is inherently designed to support both real-time and asynchronous play. The introduction of a central **Rules Engine Subdomain** provides a powerful, extensible mechanism for managing the game's dynamic and ever-changing ruleset. This model is more than just a plan for a database; it is a comprehensive map of the game's rich domain, providing a clear foundation for building a digital version that is truly faithful to the epic spirit of the original.
