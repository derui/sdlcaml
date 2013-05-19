(**
 * this module provide lowlevel SDL bindings for SDL Mixer. this don't include
 * high level API for user. these functions are often use only inner library.
 *
 * NOTE: these bindings excludes some Mix_Effect* function and Mix_*Hook
 * functions. Because I don't know how to call OCaml function from C
 * with other thread created in C...
 *
 * @author derui
 * @since 0.1
 *)

module S = Sugarpot.Std

(** SDL_Mixer support libraries  *)
type mixerinit = [
  `FLAC
| `MOD
| `MP3
| `OGG
]

(** type of channel. has variants are that  AllChannel as all channel,
    Channel is each channel with channel index which is not signed  *)
type channel = [
  `Channel of int
]

(** status of the fade activity of the channel. *)
type fading =
  NO_FADING
| FADING_OUT
| FADING_IN

(** audio formats. you use each format when calling {!audio_open} or
    from other functions
*)
type audio_format =
  AUDIO_U8
| AUDIO_S8
| AUDIO_U16LSB
| AUDIO_S16LSB
| AUDIO_U16MSB
| AUDIO_S16MSB

(** binding for {b Mix_MusicType}. Each constructor
    are related to each Mix_MusicType member that name is equal.
*)
type music_type =
  MUS_NONE
| MUS_CMD
| MUS_WAV
| MUS_MOD
| MUS_MID
| MUS_OGG
| MUS_MP3
| MUS_MP3_MAD
| MUS_FLAC
| MUS_MODPLUG

(** Covering up Mix_Chunk from OCaml *)
type chunk

(** Covering up Mix_Music from OCaml  *)
type music

(** Return status SDL_mixer is linked.

    @return true if SDL_mixer linked, false if did not linked.
*)
external is_linked: unit -> bool = "sdlcaml_mixer_is_linked"

(**
   Return SDL Mixer version when it compiled.

   @return major, minor, patch versions
*)
external compile_version : unit -> int * int * int =
    "sdlcaml_mixer_compile_version"

(**
   Return SDL Mixer version of linked it.

   @return major, minor, patch versions
*)
external linked_version : unit -> int * int * int =
    "sdlcaml_mixer_linked_version"

(**
   Initialize by loading support as indicated by the flags.
   At least return success if support is already loaded.

   Raise Sdl_mixer_exception if initialize failed.

   @param mixerinit list of SDL_Mixer to want to load libraries
   @return currently initted sample/music loaders
*)
external init : mixerinit list -> mixerinit list = "sdlcaml_mixer_init"

(**
   This function cleans up all dynamically loaded library handles,
   freeing memory. If support is required again it will be initialized
   again, either by {!init} or loading a sample or some music with
   dynamic suport required.
*)
external quit : unit -> unit = "sdlcaml_mixer_quit"

(**
   Initialize the mixer API. This function must be called before using
   other functions in this library.
   Before this function calling, {!Sdl.init} must be called with
   `AUDIO.
   Note: this function call SDL_OpenAudio from inner this.

   @param freq frequency audio. often 44100 or 22050 used.
   @param format one of the {!audio_format}.
   @param channels Number of sounds channels in output
   @param chunk Bytes used per output sample.
   @return Right if success, Left if failed with error string.

*)
external open_audio: freq:int -> format:audio_format -> channels:int
  -> chunk:int -> (unit, string) S.Either.t = "sdlcaml_mixer_open_audio"

(**
   shutdown and cleanup the mixer API.
   After calling this all audio is stopped, the device is closed, and
   the SDL_mixer functions should not be used.
   If you called this, you may not call {!quit} if you wish.
*)
external close: unit -> unit = "sdlcaml_mixer_close_audio"

(**
   Get the actual audio format in use by the opened audio device.
   return None before {!open_audio} called.

   @return tuple contains (frequency, format, channels)
*)
external query_spec: unit -> (int * audio_format * int) option = "sdlcaml_mixer_query_spec"


(* Samples *)

(**
   Get the number of sample chunk decoders available from the
   {!get_chunk_decoder}.

   @return the number of sample chunk decoders available
*)
external get_num_chunk_decoders: unit -> int = "sdlcaml_mixer_get_num_chunk_decoders"

(**
   Get the name of the indexed sample chunk decoder.
   you need to get the number of sample chunk decoders available using
   the {!get_num_chunk_decoders}.

   @param index The index number of sample chunk decoder to get
   @return name of indexed sample chunk decoder.
w*)
external get_chunk_decoder: int -> string = "sdlcaml_mixer_get_chunk_decoder"

(**
   Load file for use as a sample. This can load WAVE, TIFF, RIFF, OGG,
   and VOC files.
   You have to call {!free_chunk} when loaded chunk is no longer needed

   @param file file name to load sample from.
   @return the sample as a chunk. Left if failed
*)
external load_wav: string -> (chunk, string) S.Either.t =
  "sdlcaml_mixer_load_wav"

(**
   Set volume in the given chunk to given volume.
   The volume setting will take effect when the chunk is used on a
   channel,being mixed into the output.

   Note: you are allowed to give {!volume} parameter between 0 and 128.

   @param chunk chunk to set the volume in
   @param volume The volume will set to chunk.
   @return previous volume of given chunk.
*)
external volume_chunk: chunk:chunk -> volume:int -> int = "sdlcaml_mixer_volume_chunk"

(**
   Free the memory used in chunk. Do not use chunk after this with out
   loading a new sample t it.
   Note: It's a bad idea to free a chunk that is still being played.

   @param chunk chunk to free
*)
external free_chunk: chunk -> unit = "sdlcaml_mixer_free_chunk"

(* Channels *)

(**
   Set the number of channels being mixed. If given number of channels
   is less than current it, then the higher channels will be stopped, free,
   and not mixed any longer.
   If you give really high channels to this, maybe this can segfault.

   @param numchans Number of channels to allocate for mixing
   @return number of channels allocated.
*)
external allocate_channels: int -> int = "sdlcaml_mixer_allocate_channels"

(**
   Set the volume to allocated channel. The volume is applied during
   the final mix, along with the sample volume.
   If given AllChannel to channel then all channels are set at once.

   Note: If given UnreservedChannel as channel, this function perform
   to be equal when given AllChannel as channel to this.

   @param channel channel index to set volume
   @param volume The volume to use from 0 to 128
   @return previous volume. If {!channel} is {!AllChannel}, the
   average volume is returned.
*)
external volume: channel:[> channel|`All] -> volume:int -> int = "sdlcaml_mixer_volume"

(**
   Play chunk on channel, or if channel is UnreservedChannel, pick the
   first free unreserved channel.
   See more detail description of Mix_PlayChannel.

   Note: If channel give AllChannel, this function is performed
   as given UnreservedChannel.

   @param channel Channel to play on.
   @param chunk Sample to play
   @param loops Number of loops. -1 is infinite loop.
   @param ticks millisecond limit to play samples. If not given, play forever.
   @return the channel the sample is played on, Left with error string
   if this failed.
*)
external play_channel: channel:[> channel| `Unreserved] -> chunk:chunk -> loops:int ->
  ?ticks:int -> unit ->
    (int, string) S.Either.t = "sdlcaml_mixer_play_channel"

(**
   Play chunk on channel, or if channel is UnreservedChannel, pick the
   first free unreserved channel.
   The channel volume starts at 0 and fades up to full volume over
   {!fade} milliseconds of time.
   See more detail description to Mix_FadeInChannel and
   Mix_FadeInChannelTimed.

   @param channel Channel to play on.
   @param chunk Sample to play
   @param loops Number of loops. -1 is infinite loop.
   @param fade milliseconds of time that the fade-in effect take to go
   silence to full volume.
   @param ticks millisecond limit to play samples. If not given, play forever.
   @return the channel the sample is played on, Left with error string
   if this failed.

*)
external fadein_channel: channel:[> channel | `Unreserved] -> chunk:chunk -> loops:int
  -> fade:int -> ?ticks:int -> unit -> (int, string) S.Either.t
    = "sdlcaml_mixer_fadein_channel_bytecode"
  "sdlcaml_mixer_fadein_channel_native"

(**
   Pause channel, or all playing channel if AllChannel given.

   @param channel channel to pause. AllChannel is to pause for all channel.
*)
external pause: [> channel|`All] -> unit = "sdlcaml_mixer_pause"

(**
   Reverse function of {!pause}.

   @param channel channel to resume. AllChannel is to resume for all channel.
*)
external resume: [> channel | `All] -> unit = "sdlcaml_mixer_resume"

(**
   Halt channel playback, or all channel if AllChannel given.

   @param channel channel to stop playing. AllChannel is to stop for
   all channels
*)
external halt_channel: [> channel| `All] -> unit = "sdlcaml_mixer_halt_channel"

(**
   Halt channel playback, or all channels if AllChannel is given,
   after tick milliseconds.

   @param channel channel to stop playing, AllChannel is to stop for
   all channels
   @param ticks milliseconds until channel(s) halt playback
   @return number of channel to stop playback.
*)
external expire_channel: channel:[> channel| `All] -> ticks:int -> int =
  "sdlcaml_mixer_expire_channel"

(**
   Gradually fade out which channel over fade milliseconds starting
   from now. The channel will be halted after the fade out is
   completed.

   @param channel channel to fade out, AllChannel is to fade out for
   all channels
   @param fade milliseconds of time that the fade-out effect take go
   to silence.
   @return number of channel to fade out
*)
external fadeout_channel: channel:[> channel| `All] -> fade:int -> int = "sdlcaml_mixer_fadeout_channel"

(**
   Get current status of channel. If AllChannel is given, returning
   always false from this function.

   @param channel channel to get status
   @return true if playing, false if not playing.
*)
external playing: channel -> bool = "sdlcaml_mixer_playing"

(**
   Get current paused status of channel. If AllChannel is given, returning
   always false from this function.

   @param channel channel to get current status
   @return true if paused, false if not paused.
*)
external paused: channel -> bool = "sdlcaml_mixer_paused"

(**
   Tells you if which channel is fading in, out, or not.

   @param channel channel to get the fade activity status from.
   @return current fading status, or None if playing or paused that channel
*)
external fadeing_channel: channel -> fading option = "sdlcaml_mixer_fading_channel"

(**
   Get the most recent chunk played on channel. you can apply
   {!free_chunk} to retuned from this.

   @param channel Channel to get current chunk
   @return chunk playing on channel, or None if not allocated or has
   not played any sample yet.
*)
external get_chunk: channel -> chunk option = "sdlcaml_mixer_get_chunk"

(* Groups *)

(**
   Reserve num channels from being used shen playing samples.
   See SDL_mixer reference want to more details.

   @param num number of channels to reserve from default mixing
   @return number of channels reserved
*)
external reserve_channels : int -> int =
  "sdlcaml_mixer_reserve_channels"

(**
   Add given channel to group of given tag.
   See SDL_mixer reference want to more details.

   @param which channel number of channels to assign tag to
   @param tag A group number any positive number (including zero)
   @return true if successful
*)
external group_channel: which:channel -> tag:int -> bool = "sdlcaml_mixer_group_channel"

(**
   Add channels which are between fst to snd that are included from_to
   tuple to group of tag.

   @param from_to First channel number up through last channel number
   @param tag a group number any positive number (including zero)
   @return number of tagged channels on success.
*)
external group_channels: from_to:(channel * channel) -> tag:int -> int
  = "sdlcaml_mixer_group_channels"

(**
   Count the number of channels in group tag.

   @param group number any positive number (including zero)
   @return the number of channels found in the group.
*)
external group_count : int -> int = "sdlcaml_mixer_group_count"

(**
   Find the first avalable channel in group tag.

   @param group number any positive numbers (including zero)
   @return the channel found on success. None if no channels in the
   group are available
*)
external group_available : int -> channel option = "sdlcaml_mixer_group_available"

(**
   binding for {b Mix_GroupOldest}.

   @param tag group number any positive number (including zero)
   @return channel found on success. None if no channel in the group
   are playing or empty
*)
external group_oldest : int -> channel option =
  "sdlcaml_mixer_group_oldest"

(**
   binding for {b Mix_GroupNewer}.

   @param tag group number any positive number (including zero)
   @return channel found on success. None if no channel in the group
   are playing or empty
*)
external group_newer : int -> channel option =
  "sdlcaml_mixer_group_newer"

(**
   binding for {b Mix_FadeOutGroup}.

   @param tag group to fade out. -1 will NOT fade all channels out.
   @param fade milliseconds of time that the fade-out effect should
   take to go to silence.
   @return the number of channels set to fade out.
*)
external fadeout_group: tag:int -> fade:int -> int = "sdlcaml_mixer_fadeout_group"

(**
   binding for {b Mix_HaltGroup}.

   @param tag group number to halt playback.
*)
external halt_group: int -> unit = "sdlcaml_mixer_halt_group"

(* Music *)

(**
   binding for {b Mix_GetNumMusicDecoders}.

   @return the number of music decoders available.
*)
external get_num_music_decoders: unit -> int =
  "sdlcaml_mixer_get_num_music_decoders"

(**
   binding for {b Mix_GetMusicDecoder}.

   @param index index number of music decoder to get.
   @return the name of the indexed music decoder.
*)
external get_music_decoder: int -> string = "sdlcaml_mixer_get_music_decoder"

(**
   binding for {b Mix_LoadMUS}.

   @param file Name of music file to use.
   @return music construct or error string
*)
external load_mus: string -> (music, string) S.Either.t = "sdlcaml_mixer_load_mus"

(**
   binding for {b Mix_FreeMusic}

   @param music music construct returned {!load_mus}
*)
external free_music: music -> unit = "sdlcaml_mixer_free_music"

(**
   binding for {b Mix_PlayMusic}

   @param music music construct return from {!load_mus}
   @param loops number of times to play through the music. -1 is
   forever.
   @return Left if failed with error string.
*)
external play_music: music:music -> loops:int -> (unit, string)
  S.Either.t  = "sdlcaml_mixer_play_music"

(**
   binding for {b Mix_FadeInMusic} and {b Mix_FadeInMusicPos}.

   @param music music construct.
   @param loops number of times to play through the music.
   @param ms millisecond for the fade-in effect to complete.
   @param pos position to play from. default is 0.0 .
   @return Left with error string if failed.
*)
external fadein_music : music:music -> loops:int -> ms:int ->
  ?pos:float -> (unit, string) S.Either.t = "sdlcaml_mixer_fadein_music"


(**
   binding for {b Mix_VolumeMusic}.

   @param volume music volume, from 0 to 128.
   @return previous volume setting.
*)
external volume_music: int -> int = "sdlcaml_mixer_volume_music"

(**
   binding for {b Mix_PauseMusic}.
*)
external pause_music: unit -> unit = "sdlcaml_mixer_pause_music"

(**
   binding for {b Mix_ResumeMusic}
*)
external resume_music: unit -> unit = "sdlcaml_mixer_resume_music"

(**
   binding for {b Mix_RewindMusic}.
*)
external rewind_music: unit -> unit = "sdlcaml_mixer_rewind_music"

(**
   binding for {b Mix_SetMusicPosition}.

   @param position Position to play from
   @return Left with error string if failed.
*)
external set_music_position: float -> (unit, string) S.Either.t
  = "sdlcaml_mixer_set_music_position"

(**
   binding for {b Mix_HaltMusic}.
*)
external halt_music: unit -> unit = "sdlcaml_mixer_halt_music"

(**
   binding for {b Mix_FadeOutMusic}.

   @param ms milliseconds of time that fade-out effect should take to
   go to silence.
   @return true if successful.
*)
external fadeout_music: int -> bool = "sdlcaml_mixer_fadeout_music"

(**
   binding for {b Mix_GetMusicType}.

   @param music The music to get the type of
   @return the type of music.
*)
external get_music_type: music -> music_type = "sdlcaml_mixer_get_music_type"

(**
   binding for {b Mix_PlayingMusic}.

   @return true if music playing
*)
external playing_music: unit -> bool = "sdlcaml_mixer_playing_music"

(**
   binding for {b Mix_PausedMusic}.

   @return true if music paused.
*)
external paused_music: unit -> bool = "sdlcaml_mixer_paused_music"

(**
   binding for {b Mix_FadingMusic}

   @return the fading status.
*)
external fading_music: unit -> fading = "sdlcaml_mixer_fading_music"

(**
   binding for {b Mix_SetPanning}

   @param channel Channel number to register this effect on
   @param left volume for the left channel, range is 0 to 255.
   @param right volume for the right channel, range is 0 to 255.
   @return Left with error string if failed with any reason.
*)
external set_panning: channel:channel -> left:int -> right:int ->
  (unit, string) S.Either.t = "sdlcaml_mixer_set_panning"

(**
   binding for {b Mix_SetDistance}.

   @param channel channel number to register this effect on.
   @param dist Specify the distance from the listener, from 0(near) to
   255(far)
   @return Left with error string if failed with any reason.
*)
external set_distance: channel:channel -> dist:int ->
  (unit, string) S.Either.t = "sdlcaml_mixer_set_distance"

(**
   binding for {b Mix_SetPosition}.

   @param channel Channel number to register this effect on.
   @param angle Direction in relation to forward from 0 to 360
   degrees, not radian.
   @param dist Specify the distance from the listener, from 0(near) to
   255(far)
   @return Left with error string if failed with any reason.
*)
external set_position: channel:channel -> angle:int -> dist:int ->
  (unit, string) S.Either.t = "sdlcaml_mixer_set_position"

(**
   binding for {b Mix_UnregisterAllEffects}.

   @param channel Channel to remove all effects from.
   @return Left with error string if failed.
*)
external unregister_all_effects: channel -> (unit, string) S.Either.t
  = "sdlcaml_mixer_unregister_all_effects"
