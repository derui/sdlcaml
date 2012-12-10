CAMLprim value sdlcaml_mixer_is_linked(value unit) {
  CAMLparam1(unit);
  CAMLreturn(Val_false);
}

CAMLprim value sdlcaml_mixer_compile_version(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_mixer is not available");
}

CAMLprim value sdlcaml_mixer_linked_version(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_linked_version: SDL_mixer is not available");
}

CAMLprim value sdlcaml_mixer_init(value mixerinit) {
  CAMLparam1(mixerinit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_quit(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_open_audio(value freq, value format, value channels,
                                        value chunk) {
  CAMLparam4(freq, format, channels, chunk);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_close_audio(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_query_spec(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_num_chunk_decoders(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_chunk_decoder(value chunk) {
  CAMLparam1(chunk);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_load_wav(value file) {
  CAMLparam1(file);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_volume_chunk(value chunk, value volume) {
  CAMLparam1(chunk);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_free_chunk(value chunk) {
  CAMLparam1(chunk);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_allocate_channels(value numchans) {
  CAMLparam1(numchans);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_volume(value channel, value volume) {
  CAMLparam2(channel, volume);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_play_channel(value channel, value chunk, value loops, value tick, value unit) {
  CAMLparam5(channel, chunk, loops, tick, unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadein_channel_native(value channel, value chunk, value loops,
                                            value fade, value tick, value unit) {
  CAMLparam5(channel, chunk, loops, fade, tick);
  CAMLxparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadein_channel_bytecode(value *argv, int argn) {
  return sdlcaml_mixer_fadein_channel_native(argv[0], argv[1], argv[2],
                                             argv[3], argv[4], argv[5]);
}

CAMLprim value sdlcaml_mixer_pause(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_resume(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_halt_channel(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_expire_channel(value channel, value fade) {
  CAMLparam2(channel, fade);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadeout_channel(value channel, value fade) {
  CAMLparam2(channel, fade);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_playing(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_paused(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fading_channel(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_chunk(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_reserve_channels(value numchuns) {
  CAMLparam1(numchuns);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_channel(value which, value tag) {
  CAMLparam2(which, tag);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_channels(value from_to, value tag) {
  CAMLparam2(from_to, tag);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_count(value tag) {
  CAMLparam1(tag);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_available(value group) {
  CAMLparam1(group);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_oldest(value group) {
  CAMLparam1(group);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_group_newer(value group) {
  CAMLparam1(group);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadeout_group(value group, value fade) {
  CAMLparam2(group, fade);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_halt_group(value group) {
  CAMLparam1(group);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_num_music_decoders(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_music_decoder(value index) {
  CAMLparam1(index);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_load_mus(value file) {
  CAMLparam1(file);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_free_music(value music) {
  CAMLparam1(music);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_play_music(value music, value loops) {
  CAMLparam2(music, loops);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadein_music(value music, value loops,
                                          value ms, value pos) {
  CAMLparam4(music, loops, ms, pos);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_volume_music(value volume) {
  CAMLparam1(volume);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_pause_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_resume_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_rewind_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_set_music_position(value pos) {
  CAMLparam1(pos);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_halt_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fadeout_music(value ms) {
  CAMLparam1(ms);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_get_music_type(value music) {
  CAMLparam1(music);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_playing_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_paused_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_fading_music(value unit) {
  CAMLparam1(unit);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_set_panning(value channel, value left, value right) {
  CAMLparam3(channel, left, right);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_set_distance(value channel, value dist) {
  CAMLparam2(channel, dist);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_set_position(value channel, value angle, value dist) {
  CAMLparam3(channel, angle, dist);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}

CAMLprim value sdlcaml_mixer_unregister_all_effects(value channel) {
  CAMLparam1(channel);
  caml_failwith("sdlcaml_mixer_compile_version: SDL_image is not available");
}
