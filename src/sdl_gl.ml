open Ctypes
open Foreign
open Sdlcaml_flags

type t = Sdl_types.GLContext.t
let t = Sdl_types.GLContext.t
type window = Sdl_types.Window.t
let window = Sdl_types.Window.t

module Inner = struct
  let create_context = foreign "SDL_GL_CreateContext" (window @-> returning t)
  let delete_context = foreign "SDL_GL_DeleteContext" (t @-> returning void)
  let get_attribute = foreign "SDL_GL_GetAttribute" (int @-> ptr int @-> returning int)
  let get_current_context = foreign "SDL_GL_GetCurrentContext" (void @-> returning t)
  let get_current_window = foreign "SDL_GL_GetCurrentWindow" (void @-> returning window)
  let get_swap_interval = foreign "SDL_GL_GetSwapInterval" (void @-> returning int)
  let reset_attributes = foreign "SDL_GL_ResetAttributes" (void @-> returning void)
  let set_attribute = foreign "SDL_GL_SetAttribute" (int @-> int @-> returning int)
  let set_swap_interval = foreign "SDL_GL_SetSwapInterval" (int @-> returning int)
  let swap_window = foreign "SDL_GL_SwapWindow" (window @-> returning void)
end

let create_context w =
  let ret = Inner.create_context w in
  Sdl_util.catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let delete_context ctx =
  let open Core.Std in
  Inner.delete_context ctx;
  Sdl_util.catch (Fn.const true) ignore

let get_current () =
  let ctx = Inner.get_current_context ()
  and win = Inner.get_current_window () in
  Sdl_util.catch (fun () -> to_voidp ctx <> null && to_voidp win <> null)
    (fun () -> (ctx, win))

let use_version ?(core_profile=true) ~major ~minor () =
  let module Gl_attr = Sdl_gl_attr in
  let module Gl_profile = Sdl_gl_profile in
  let core_setting = if core_profile then
      Inner.set_attribute Gl_attr.(to_int SDL_GL_CONTEXT_PROFILE_MASK)
        Gl_profile.(to_int `CORE)
    else 0 in
  let major = Inner.set_attribute Gl_attr.(to_int SDL_GL_CONTEXT_MAJOR_VERSION) major
  and minor = Inner.set_attribute Gl_attr.(to_int SDL_GL_CONTEXT_MINOR_VERSION) minor in
  Sdl_util.catch (fun () -> core_setting = 0 && major = 0 && minor = 0) ignore

let get_attribute attr =
  let buf = CArray.make int 2 in
  let ret = Inner.get_attribute Sdl_gl_attr.(to_int attr) (CArray.start buf) in
  Sdl_util.catch (fun () -> ret = 0) (fun () -> CArray.get buf 0)

let set_attribute ~attr ~value =
  let ret = Inner.set_attribute Sdl_gl_attr.(to_int attr) value in
  Sdl_util.catch (fun () -> ret = 0) ignore

let reset_attributes = Inner.reset_attributes

let get_swap_interval () =
  let ret = Inner.get_swap_interval () in
  Sdl_util.catch (fun () -> ret >= 0) (fun () ->
    match ret with
    | 0 -> `No
    | 1 -> `Buffer
    | _ -> failwith "Unknown type"
  )

let set_swap_interval v =
  let ret = Inner.set_swap_interval v in
  Sdl_util.catch (fun () -> ret = 0) ignore

let swap_window = Inner.swap_window
