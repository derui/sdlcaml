open Num

(* identity function *)
let id t = t
let const x _ = x
let flip f x y = f y x

let (|>) f g = g f
let (<|) f g = f g

(* initialization list. this return list that applied each [0..n) to
   f. it likes [f(0);f(1);..f(n-1)]
*)
let init n f =
  let rec init_ current f lst =
    if current >= n then lst
    else init_ (succ current) f lst @ [f(current)]
  in init_ 0 f []


(* return list within the compass of given min to given max. *)
let range (s, l) =
  let rec range_ cur lst =
    if cur >/ l then List.rev lst
    else range_ (succ_num cur) (cur :: lst)
  in range_ s []

let is_none = function
    None -> true
  | _ -> false

let is_some = function
    Some _ -> true
  | _ -> false

let cmp_float ~epsilon f1 f2 =
  let sub = (f1 -. f2) in
  let sub_abs = abs_float sub in
  if sub_abs <= epsilon then 0
  else if sub < 0.0 then -1
  else 1
