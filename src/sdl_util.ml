
let catch_exn : 'a . (string -> exn) -> (unit -> bool) -> (unit -> 'a) -> 'a = fun exn pred success ->
  if not (pred ()) then
    raise (exn (Sdl_error.get ()))
  else
    success ()

let catch pred success =
  let error = Sdl_error.get () in
  if not (pred ()) then Sdl_types.Result.fail error else Sdl_types.Result.return (success ())
