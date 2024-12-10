import gleam/option.{type Option}

pub type Value {
  Resource(value: Int)
  Influence(value: Int)
}

pub type Cost {
  Cost(value: Value, reference_amount: Int)
}

pub type Hit {
  Hit(
    dice_amount: Option(Int),
    hit_on: Int,
    range: Option(Int),
    extra_dice: Option(Int),
    reroll_misses: Bool,
  )
}

pub type Color {
  Black
  Blue
  Green
  Orange
  Pink
  Purple
  Red
  Yellow
}

pub type Strategy {
  Leadership
  Diplomacy
  Politics
  Construction
  Trade
  Warfare
  Technology
  Imperial
}
