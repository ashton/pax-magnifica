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

pub fn initiative(card: Strategy) -> Int {
  case card {
    Leadership -> 1
    Diplomacy -> 2
    Politics -> 3
    Construction -> 4
    Trade -> 5
    Warfare -> 6
    Technology -> 7
    Imperial -> 8
  }
}
