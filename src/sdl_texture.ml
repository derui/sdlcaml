open Ctypes
open Foreign
open Sdlcaml_flags
open Sdlcaml_structures

type t = Sdl_types.Texture.t
let t = Sdl_types.Texture.t

module A = CArray

module Inner = struct
  let create_texture = foreign "SDL_CreateTexture" (Sdl_types.Renderer.t @-> uint32_t @->
                                                    int @-> int @-> int @-> returning t)
  let create_texture_from_surface = foreign "SDL_CreateTextureFromSurface"
    (Sdl_types.Renderer.t @-> Sdl_types.Surface.t @-> returning t)
  let destroy_texture = foreign "SDL_DestroyTexture" (t @-> returning void)

  let gl_bind_texture = foreign "SDL_GL_BindTexture" (t @-> ptr float @-> ptr float @-> returning int)
  let gl_unbind_texture = foreign "SDL_GL_UnbindTexture" (t @-> returning int)
  let get_texture_alpha_mod = foreign "SDL_GetTextureAlphaMod" (t @-> ptr uint8_t @-> returning int)
  let get_texture_blend_mode = foreign "SDL_GetTextureBlendMode" (t @-> ptr uint32_t @-> returning int)
  let get_texture_color_mod = foreign "SDL_GetTextureColorMod" (t @-> ptr uint8_t @->
                                                                ptr uint8_t @-> ptr uint8_t @-> returning int)
  let query_texture = foreign "SDL_QueryTexture" (t @-> ptr uint32_t @-> ptr int @-> ptr int @->
                                                  ptr int @-> returning int)
  let set_texture_alpha_mod = foreign "SDL_SetTextureAlphaMod" (t @-> uint8_t @-> returning int)
  let set_texture_blend_mode = foreign "SDL_SetTextureBlendMode" (t @-> uint32_t @-> returning int)
  let set_texture_color_mod = foreign "SDL_SetTextureColorMod" (t @-> uint8_t @->
                                                                uint8_t @-> uint8_t @-> returning int)
end

let catch = Sdl_util.catch

let create ~renderer ~format ~access ~width ~height () =
  let open Sdlcaml_flags in
  let format = Sdl_pixel_format_enum.to_int32 format |> Unsigned.UInt32.of_int32 in
  let access = Sdl_texture_access.to_int access in
  let ret = Inner.create_texture renderer format access width height in
  catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let create_from_surface ~renderer ~surface =
  let ret = Inner.create_texture_from_surface renderer surface in
  catch (fun () -> to_voidp ret <> null) (fun () -> ret)

let destroy t =
  Inner.destroy_texture t;
  Sdl_types.Result.return ()

let bind_gl texture = 
  let width = A.make float 1
  and height = A.make float 1 in
  Sdl_helper.ret_to_result (Inner.gl_bind_texture texture (A.start width) (A.start height)) (fun () ->
    (A.get width 0, A.get height 0)
  )

let unbind_gl texture = Sdl_helper.ret_to_result (Inner.gl_unbind_texture texture) ignore

let get_alpha_mod texture =
  let alpha = A.make uint8_t 1 in
  let ret = Inner.get_texture_alpha_mod texture (A.start alpha) in
  Sdl_helper.ret_to_result ret (fun () -> A.get alpha 0 |> Unsigned.UInt8.to_int)

let get_blend_mode texture =
  let blend_mode = A.make uint32_t 1 in
  let ret = Inner.get_texture_blend_mode texture (A.start blend_mode) in
  Sdl_helper.ret_to_result ret (fun () ->
    A.get blend_mode 0 |> Unsigned.UInt32.to_int32 |> Int32.to_int |> Sdl_blendmode.of_int)

let get_color_mod texture =
  let r = A.make uint8_t 1
  and g = A.make uint8_t 1
  and b = A.make uint8_t 1 in
  let ret = Inner.get_texture_color_mod texture (A.start r) (A.start g) (A.start b) in
  Sdl_helper.ret_to_result ret (fun () ->
    let r = A.get r 0 |> Unsigned.UInt8.to_int
    and g = A.get g 0 |> Unsigned.UInt8.to_int
    and b = A.get b 0 |> Unsigned.UInt8.to_int in
    {Color.r;g;b;a = 255}
  )

let set_alpha_mod ~texture ~alpha =
  let alpha = Unsigned.UInt8.of_int alpha in
  let ret = Inner.set_texture_alpha_mod texture alpha in
  Sdl_helper.ret_to_result ret ignore

let set_blend_mode ~texture ~blendmode =
  let blendmode = Sdl_blendmode.to_int blendmode |> Int32.of_int |> Unsigned.UInt32.of_int32 in
  let ret = Inner.set_texture_blend_mode texture blendmode in
  Sdl_helper.ret_to_result ret ignore

let set_color_mod ~texture ~color =
  let r = color.Color.r |> Unsigned.UInt8.of_int
  and g = color.Color.g |> Unsigned.UInt8.of_int
  and b = color.Color.b |> Unsigned.UInt8.of_int in
  let ret = Inner.set_texture_color_mod texture r g b in
  Sdl_helper.ret_to_result ret ignore

let query_format texture =
  let format = A.make uint32_t 1 in
  let nul = from_voidp int null in
  let ret = Inner.query_texture texture (A.start format) nul nul nul in
  Sdl_helper.ret_to_result ret (fun () ->
    A.get format 0 |> Unsigned.UInt32.to_int32 |> Sdl_pixel_format_enum.of_int32
  )

let query_access texture =
  let access = A.make int 1 in
  let nul = from_voidp int null in
  let u32_nul = from_voidp uint32_t null in
  let ret = Inner.query_texture texture u32_nul (A.start access) nul nul in
  Sdl_helper.ret_to_result ret (fun () -> A.get access 0 |> Sdl_texture_access.of_int)

let query_size texture =
  let w = A.make int 1 
  and h = A.make int 1 in
  let nul = from_voidp int null in
  let u32_nul = from_voidp uint32_t null in
  let ret = Inner.query_texture texture u32_nul nul (A.start w) (A.start h) in
  Sdl_helper.ret_to_result ret (fun () ->
    {Size.width = A.get w 0; height = A.get h 0}
  )
