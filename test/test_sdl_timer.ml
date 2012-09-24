open Sdlcaml
open OUnit

let test_set_up _ =
  Sdl.init([`TIMER])

let test_tear_up _ =
  Sdl.quit ()


let test_get_tick_timer _ =
  let open Sdl_timer in
  begin
    Thread.delay 1.0;
    let now = Sdl_timer.get_ticks () in
    "tick is over 1000ms " @? (now >= 1000);
  end

let test_delay _ =
  let open Sdl_timer in
  begin
    let prev = get_ticks () in
    begin
      delay 100;
      let now = get_ticks () in
      "compare previous time before delay to time after delay" @?
        ((now - prev) >= 100)
    end
  end

let suite = "timer tests" >:::
  [ "get tick time" >:: (bracket test_set_up test_get_tick_timer
  test_tear_up);
    "delay with SDL" >:: (bracket test_set_up test_delay test_tear_up)
  ]

let _ =
  run_test_tt_main suite
