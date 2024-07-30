import gleam/option

pub fn or(opt, default) {
  option.unwrap(opt, default)
}
