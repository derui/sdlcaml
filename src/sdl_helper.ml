
let bool_to_int = function
  | false -> 0
  | true -> 1

let int_to_bool = function
  | 0 -> false
  | _ -> true

(** Return either Success or Failure whether return code as ret is success or failure *)
let ret_to_result ret result = Sdl_util.catch (fun () -> ret = 0) result
