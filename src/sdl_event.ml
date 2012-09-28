(**
 * this module provide lowlevel SDL bindings for SDL Event. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

module Event = Sdl_EventObject

exception Sdl_event_exception of string

(**
 * state of processing event.
 *)
type event_state =
| IGNORE                                (** ignore event *)
| ENABLE                                (** enable processing event *)
| QUERY                                 (** inquery current processing state *)

(**
   Push some Event Structure onto the event queue.

   If can't push onto 'the event queue any reason, raise {!Sdl_event_exception} with
   result of {b SDL_GetError()}.

   @param event wish event to push
   @raise Sdl_event_exception if event can't push onto the event queue
*)
external push_event: Event.event -> unit = "sdlcaml_push_event"

(**
 * Pump the event loop, gathering events from the input devices.
 * Often call the need for this function is hidden from the user what
 * since {!poll_event} or {!wait_event} implicitly calls this function.
 *
 * Note: this function can only call in the thread set the video mode.
 *)
external pump_events: unit -> unit = "sdlcaml_pump_events"

(**
 * Polls for currently pending events, if there are any pending
 * events, return events and remove it from queue.
 * If there is no pending events, None is returned from this function.
 *
 * @return if there are any pending events, return Some.
 *)
external poll_event: unit -> Event.event option = "sdlcaml_poll_event"

(**
 * Wait indefinitly for the next avaliable event.
 *
 * @return if there is avaliable event, return Some.
 *)
external wait_event: unit -> Event.event option = "sdlcaml_wait_event"

(**
 * This function allows you to set the state of processing certain
 * events.
 *
 * If {i state} is set to IGNORE, that event {i etype} will be
 * automatically dropped from the event queue.
 * If {i state} is set to ENABLE, that event {i etype} will be
 * processed normaly.
 * If {i state} is set to QUERY, this function will return the current
 * processing state of the specific {i etype}
 *
 * @param etype event type
 * @param state state of the event {i etype}
 * @return If you set QUERY to {i state}, this function will return
 * Some with the current state of the specific {i etype}, but will
 * return None when you don't set QUERY.
 *)
external event_state: etype:Event.event_type ->
  state:event_state -> event_state option = "sdlcaml_event_state"

(**
 * Get the current state of the application.
 *
 * This function returns the current state of application.
 * The value returned is a list of {!app_state}
 *
 * @return list of the current states of the application
 *)
external get_app_state: unit -> Event.app_state list = "sdlcaml_get_app_state"

let _ =
  Callback.register_exception "Sdl_event_exception"
