(**
   This module provide handling SDL events.

   @author derui
   @since 0.2
*)

val push: Sdlcaml_structures.Events.t -> unit Sdl_types.Result.t
(** [push e] add an event to the event queue *)

val query_state: Sdlcaml_flags.Sdl_event_type.t -> Sdlcaml_flags.Sdl_state.t
(** [query_state etyp] returns the current processing state of the specified event [etyp] *)

val enable: Sdlcaml_flags.Sdl_event_type.t -> bool
(** [enable etyp] enables [etyp] that will be processed normally  *)

val disable: Sdlcaml_flags.Sdl_event_type.t -> bool
(** [enable etyp] disable [etyp] that will automatically dropped from the event queue *)

val flush: Sdlcaml_flags.Sdl_event_type.t list -> unit
(** [flush types] clear specified events [types] from the event queue. *)

val has_event: Sdlcaml_flags.Sdl_event_type.t -> bool
(** [has_event event] return true or false if events matching [event] are present or not. *)

val has_events: Sdlcaml_flags.Sdl_event_type.t list -> bool
(** [has_events events] return true or false if events matching one of event in [events] are present or not. *)

val pump: unit -> unit
(** [pump ()] pumps the event loop.
   Calling this function by user only use [peep] function instead of [polling] or [waiting] function.
   If user use [polling] or [waiting] function, do not need to call this.
*)

val polling: (Sdlcaml_structures.Events.t -> unit) -> unit Sdl_types.Result.t
(** [polling f] poll for currently pending events. [f] is called with pending events, and
   return function if there are none available.
*)

val waiting: (Sdlcaml_structures.Events.t -> unit) -> unit Sdl_types.Result.t
(** [waiting f] wait indefinitely for the next available event. *)

val get: unit -> Sdlcaml_structures.Events.t option Sdl_types.Result.t
(** [get ()] get event from event queue if available. *)
