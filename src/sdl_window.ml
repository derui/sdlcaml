(**
 * this module provide lowlevel SDL bindings of SDL WM System. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(**
 * Sets the window title and icon name. Can only set window
 * title, doesn't set icon name.
 *
 * @param title window title (default: previous setted value)
 * @param icon icon name (default: previous setted value)
 * @param dummy dummy argument.
 *)
external set_caption: ?title:string -> ?icon:string -> unit -> unit =
    "sdlcaml_wm_set_caption"

(**
 * Gets the window title and icon name as tuple.
 * Getting tuple's first element is {b title}, second one is
 * {b icon name}.
 * If you want to get only title or icon name, see and use
 * {!get_title} and {!get_icon_name} below.
 *
 * @return tuple as (title, icon name)
 *)
external get_caption: unit -> string * string = "sdlcaml_wm_get_caption"

(**
 * Gets the window title.
 * If you want to get only icon name, see and use {!get_icon_name} below.
 *
 * @return window title
 *)
external get_title: unit -> string = "sdlcaml_wm_get_title"

(**
 * Gets the icon name.
 * If you want to get only title, see and use {!get_title} above.
 *
 * @return icon name
 *)
external get_icon_name: unit -> string = "sdlcaml_wm_get_icon_name"

(**
 * Iconify/Minimise the window. If this function is successful,
 * the application will receive {!SDL_APPACTIVE} loss event.
 *  (Please see {!Sdl_event} module.)
 * If the environment doesn't support iconify/minimise, return false
 * from this.
 *
 * @return true if this funciton is successful
 *)
external iconify_window: unit -> bool = "sdlcaml_wm_iconify_window"

(**
 * Toggle the application between window and fullscreen mode, if
 * supported.
 * This function always use surface of window screen. I regard
 * is able to other surfaces as to be unnessesary...
 *
 * @return return true if it is successful
 *)
external toggle_fullscreen: unit -> bool = "sdlcaml_wm_toggle_fullscreen"

(**
 * Binding of SDL_GrabMode.
 *)
type grab_mode =
  SDL_GRAB_QUERY
| SDL_GRAB_ON
| SDL_GRAB_OFF

(**
 * Grabs mouse and keyboard input.
 * See {b SDL_GrabInput} to about Grabbing means.
 *
 * When mode is SDL_GRAB_QUERY, not change grab mode, but return
 * current grab mode.
 *
 * @param
 *)
external grab_input: grab_mode -> grab_mode = "sdlcaml_wm_grab_input"
