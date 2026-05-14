import core/models/strategy.{
  type Strategy, Construction, Diplomacy, Imperial, Leadership, Politics,
  Technology, Trade, Warfare,
}

pub const all: List(Strategy) = [
  Leadership,
  Diplomacy,
  Politics,
  Construction,
  Trade,
  Warfare,
  Technology,
  Imperial,
]
