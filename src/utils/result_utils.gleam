pub type BinaryFun(a, b, c) =
  fn(a, b) -> c

pub type BinaryFunLifted(a, b, c, error) =
  fn(Result(a, error), Result(b, error)) -> Result(c, error)

pub fn lift2(fun: BinaryFun(a, b, c)) -> BinaryFunLifted(a, b, c, error) {
  let lifted_fun = fn(res_arg1: Result(a, error), res_arg2: Result(b, error)) -> Result(
    c,
    error,
  ) {
    case res_arg1, res_arg2 {
      Ok(arg1), Ok(arg2) -> fun(arg1, arg2) |> Ok
      Error(err), _ -> Error(err)
      _, Error(err) -> Error(err)
    }
  }

  lifted_fun
}
