open Ctypes
open Foreign

module Inner = struct
  let clear = foreign "SDL_ClearError" (void @-> returning void)
  let get = foreign "SDL_GetError" (void @-> returning string)
end

let clear () = Inner.clear () |> ignore

let get () = Inner.get ()
