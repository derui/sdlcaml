(**
 * this module provide lowlevel SDL bindings for SDL CD-ROM. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * @author derui
 * @since 0.1
 *)

(** opacity type of mapped C to OCaml. *)
type cd

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
   Infomation Structure of {!cd}'s real.
   Real {!SDL_CD} contains {!track} infomations, but this structure
   don't contain it. Call {!track_status} and get track infomation if
   you need track infomations of cd.
*)
type cd_info = {
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
   Return that drive have at least one or more.

   @return true if drive exists one at least.
*)
let has_drive _ = (num_drives ()) > 0

(**
   bindings for {!SDL_CDName}
*)
external name : int -> string = "sdlcaml_cd_name"

(**
   bindings for {!SDL_CDOpen}
*)
external cd_open: int -> cd option = "sdlcaml_cd_open"

(**
   bindings for {!SDL_CDStatus}
*)
external status : cd -> cdstatus = "sdlcaml_cd_status"

(**
   Update CD Structure that the table of contents and
   current play positions.
   Timing of this function calling is new CD-ROM inserted when
   the drive is not in any CD-ROM first.

   @param cd Update target of {!cd}
*)
let update cd = ignore (status cd)

(**
   Return given drive have any CD-ROM in drives or not.

   @param cd CD Infomation Structure for checking
   @return true if Drive have any CD-ROM in it
*)
external in_drive : cd -> bool = "sdlcaml_cd_indrive"

(**
   bindings for {!SDL_CDPlay}
*)
external play : cd:cd -> start:int -> length:int -> bool =
  "sdlcaml_cd_play"

(**
   bindings for {!SDL_CDPlayTracks}
*)
external play_tracks : cd:cd -> track:int -> frame:int ->
  ntracks:int -> nframes:int -> bool = "sdlcaml_cd_play_tracks"

(**
   Bindings for {!SDL_CDPause}
*)
external pause : cd -> bool = "sdlcaml_cd_pause"

(**
   Bindings for {!SDL_CDResume}
*)
external resume : cd -> bool = "sdlcaml_cd_resume"

(**
   Bindings for {!SDL_CDStop}
*)
external stop : cd -> bool = "sdlcaml_cd_stop"

(**
   Bindings for {!SDL_CDEject}
*)
external eject : cd -> bool = "sdlcaml_cd_eject"

(**
   Bindings for {!SDL_CDClose}
*)
external close : cd -> unit = "sdlcaml_cd_close"

(**
   Get {!track} list of given {!cd}.

   @param cd CDROM Drive Infomations
   @return list of track of given cd.
*)
external track_status : cd -> track list = "sdlcaml_cd_track_status"

(**
   Extract infomations from {!cd} to {!cd_info}.

   @param cd CDROM drive infomations
   @return infomations of given cd
*)
external get_info : cd -> cd_info = "sdlcaml_cd_get_info"

(**
   Converting frames to time. Returning times that are minitus,
   second, and frame, are able to use applying to {!msf_to_frame}.

   @param frames target conversion frames, for instance {!cd_info.current_frame}
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
