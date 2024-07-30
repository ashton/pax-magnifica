import models/common.{type Color}

pub type PromissoryNote {
  CeaseFire(Color)
  TradeAgreement(Color)
  PoliticalSecret(Color)
  SupportForTheThrone(Color)
  Custom
}
