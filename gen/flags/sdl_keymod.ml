type t =
    KMOD_GUI
  | KMOD_ALT
  | KMOD_SHIFT
  | KMOD_CTRL
  | KMOD_MODE
  | KMOD_CAPS
  | KMOD_NUM
  | KMOD_RGUI
  | KMOD_LGUI
  | KMOD_RALT
  | KMOD_LALT
  | KMOD_RCTRL
  | KMOD_LCTRL
  | KMOD_RSHIFT
  | KMOD_LSHIFT
  | KMOD_NONE

let to_int = function
  | KMOD_NONE   -> 0x0000
  | KMOD_LSHIFT -> 0x0001
  | KMOD_RSHIFT -> 0x0002
  | KMOD_LCTRL  -> 0x0040
  | KMOD_RCTRL  -> 0x0080
  | KMOD_LALT   -> 0x0100
  | KMOD_RALT   -> 0x0200
  | KMOD_LGUI   -> 0x0400
  | KMOD_RGUI   -> 0x0800
  | KMOD_NUM    -> 0x1000
  | KMOD_CAPS   -> 0x2000
  | KMOD_MODE   -> 0x4000
  | KMOD_GUI    -> 0x0400 lor 0x0800
  | KMOD_ALT    -> 0x0100 lor 0x0200
  | KMOD_SHIFT  -> 0x0001 lor 0x0002
  | KMOD_CTRL   -> 0x0040 lor 0x0080

let of_int = function
  | 0x0000 -> KMOD_NONE
  | m when m land 0x0001 = 0x0001 -> KMOD_LSHIFT
  | m when m land 0x0002 = 0x0002 -> KMOD_RSHIFT
  | m when m land 0x0040 = 0x0040 -> KMOD_LCTRL
  | m when m land 0x0080 = 0x0080 -> KMOD_RCTRL
  | m when m land 0x0100 = 0x0100 -> KMOD_LALT
  | m when m land 0x0200 = 0x0200 -> KMOD_RALT
  | m when m land 0x0400 = 0x0400 -> KMOD_LGUI
  | m when m land 0x0800 = 0x0800 -> KMOD_RGUI
  | m when m land 0x1000 = 0x1000 -> KMOD_NUM
  | m when m land 0x2000 = 0x2000 -> KMOD_CAPS
  | m when m land 0x4000 = 0x4000 -> KMOD_MODE
  | m when m land 0x0C00 = 0x0C00 -> KMOD_GUI
  | m when m land 0x0300 = 0x0300 -> KMOD_ALT
  | m when m land 0x0003 = 0x0003 -> KMOD_SHIFT
  | m when m land 0x00C0 = 0x00C0 -> KMOD_CTRL
  | m -> failwith (Printf.sprintf "Give invalid value to match any variant : %04x" m)

let to_list m =
  let rec to_list_rec m l =
    match of_int m with
    | KMOD_NONE -> KMOD_NONE :: l
    | f -> to_list_rec (m land (lnot (to_int f))) (f :: l)
  in
  to_list_rec m []
