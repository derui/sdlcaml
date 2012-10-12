(**
 * this module provide lowlevel SDL bindings for SDL CD-ROM. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(** opacity type of mapped C to OCaml. *)
type sdlcd

type track_type =
| AUDIO_TRACK
| DATA_TRACK

(** mapped of CDstatus. *)
type cdstatus =
| TRAYEMPTY
| STOPPED
| PLAYING
| PAUSED
| ERROR

(**
   Infomation Structure of {!sdlcd}'s real.
   Real {!SDL_CD} contains {!track} infomations, but this structure
   don't contain it. Call {!track_status} and get track infomation if
   you need track infomations of sdlcd.
*)
type sdlcd_info = {
  id:int;
  status:cdstatus;
  numtracks:int;
  current_track:int;
  current_frame:int;
}

(** CD Track infomation structure binding.
    You want to get this, use {!track_status} then.
*)
type track = {
  id:int;                               (** track number  *)
  track_type:track_type;                (** type of track  *)
  length:int;                           (** length, in frames, of
                                            this track  *)
  offset:int;                           (** offset  *)
}

(**
   Return the number of CD-ROM drives on the system
*)
external num_drives : unit -> int = "sdlcaml_cd_num_drives"

(**
   bindings for {!SDL_CDName}
*)
external name : int -> string = "sdlcaml_cd_name"

(**
   bindings for {!SDL_CDOpen}
*)
external cd_open: int -> sdlcd option = "sdlcaml_cd_open"

(**
   bindings for {!SDL_CDStatus}
*)
external status : sdlcd -> cdstatus = "sdlcaml_cd_status"

(**
   bindings for {!SDL_CDPlay}
*)
external play : cd:sdlcd -> start:int -> length:int -> bool =
  "sdlcaml_cd_play"

(**
   bindings for {!SDL_CDPlayTracks}
*)
external play_tracks : cd:sdlcd -> track:int -> frame:int ->
  ntracks:int -> nframes:int -> bool = "sdlcaml_cd_play_tracks"

(**
   Bindings for {!SDL_CDPause}
*)
external pause : sdlcd -> bool = "sdlcaml_cd_pause"

(**
   Bindings for {!SDL_CDResume}
*)
external resume : sdlcd -> bool = "sdlcaml_cd_resume"

(**
   Bindings for {!SDL_CDStop}
*)
external stop : sdlcd -> bool = "sdlcaml_cd_stop"

(**
   Bindings for {!SDL_CDEject}
*)
external eject : sdlcd -> bool = "sdlcaml_cd_eject"

(**
   Bindings for {!SDL_CDClose}
*)
external close : sdlcd -> unit = "sdlcaml_cd_close"

(**
   Get {!track} list of given {!sdlcd}.

   @param sdlcd CDROM Drive Infomations
   @return list of track of given sdlcd.
   @see sdcd, track
*)
external track_status : sdlcd -> track list = "sdlcaml_cd_track_status"

(**
   Extract infomations from {!sdlcd} to {!sdlcd_info}.

   @param sdlcd CDROM drive infomations
   @return infomations of given sdlcd
   @see sdlcd, sdlcd_info
*)
external get_info : sdlcd -> sdlcd_info = "sdlcaml_cd_get_info"

(**
   Converting frames to time. Returning times that are minitus,
   second, and frame, are able to use applying to {!msf_to_frame}.

   @param frames target conversion frames, for instance {!sdlcd_info.current_frame}
   @return the tuple contains minutes, seconds, and frame
*)
external frame_to_msf : int -> int * int * int = "sdlcaml_cd_frame_to_msf"

(**
   Convert time to frames. See details {!frame_to_msf}

   @param minutes minutes get from {!frame_to_msf}
   @param seconds seconds get from {!frame_to_msf}
   @param frames frames get from {!frame_to_msf}
   @return frame converted from given time.
*)
external msf_to_frame : minutes:int -> seconds:int -> frames:int -> int
  = "sdlcaml_cd_msf_to_frame"
