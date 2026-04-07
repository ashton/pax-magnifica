type BinaryFun(a, b, c) =
  fn(a, b) -> c

type TernaryFun(a, b, c, d) =
  fn(a, b, c) -> d

type BinaryFunLifted(a, b, c, error) =
  fn(Result(a, error), Result(b, error)) -> Result(c, error)

type TernaryFunLifted(a, b, c, d, error) =
  fn(Result(a, error), Result(b, error), Result(c, error)) -> Result(d, error)

pub fn lift2(fun: BinaryFun(a, b, c)) -> BinaryFunLifted(a, b, c, error) {
  let lifted_fun = fn(res_arg1: Result(a, error), res_arg2: Result(b, error)) -> Result(
    c,
    error,
  ) {
    case res_arg1, res_arg2 {
      Ok(arg1), Ok(arg2) -> fun(arg1, arg2) |> Ok()
      Error(err), _ -> Error(err)
      _, Error(err) -> Error(err)
    }
  }

  lifted_fun
}

pub fn lift3(fun: TernaryFun(a, b, c, d)) -> TernaryFunLifted(a, b, c, d, error) {
  let lifted_fun = fn(
    res_arg1: Result(a, error),
    res_arg2: Result(b, error),
    res_arg3: Result(c, error),
  ) -> Result(d, error) {
    case res_arg1, res_arg2, res_arg3 {
      Ok(arg1), Ok(arg2), Ok(arg3) -> fun(arg1, arg2, arg3) |> Ok()
      Error(err), _, _ -> Error(err)
      _, Error(err), _ -> Error(err)
      _, _, Error(err) -> Error(err)
    }
  }

  lifted_fun
}
