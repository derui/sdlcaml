[%%suite
 open Core.Std
 open Sdlcaml.Std
 module S = Structures
 module E = Structures.Events
 module F = Flags

 let%spec "The SDL event management should be able to push events anywhere to the event queue" =
   let events = [
     E.ControllerAxis({
       E.ControllerAxisEvent.timestamp = 1l;
       which = 1;
       axis = `RIGHTY;
       value = 10;
     });

     E.ControllerButton({
       E.ControllerButtonEvent.timestamp = 1l;
       which = 1;
       button = `A;
       state = F.Sdl_button_state.SDL_PRESSED;
     });

     E.ControllerDevice({
       E.ControllerDeviceEvent.timestamp = 1l;
       event_type = `ADDED;
       which = 32
     });

     E.DollarGesture({
       E.DollarGestureEvent.timestamp = 2l;
       action_type = `RECORD;
       touch_id = 0L;
       gesture_id = 0L;
       num_fingers = 1l;
       error = 0.1;
       x = 1.0;
       y = 2.0;
     });

     E.Drop({
       E.DropEvent.timestamp = 3l;
       file = "test.file";
     });

     E.JoyAxis({
       E.JoyAxisEvent.timestamp = 4l;
       which = 0;
       axis = 1;
       value = 2;
     });

     E.JoyBall({
       E.JoyBallEvent.timestamp = 5l;
       which = 0;
       ball = 0;
       xrel = 1;
       yrel = 2;
     });

     E.JoyButton({
       E.JoyButtonEvent.timestamp = 5l;
       which = 0;
       button = 0;
       state = F.Sdl_button_state.SDL_PRESSED;
     });

     E.JoyDevice({
       E.JoyDeviceEvent.timestamp = 6l;
       action_type = `ADDED;
       which = 4;
     });

     E.JoyHat({
       E.JoyHatEvent.timestamp = 7l;
       which = 0;
       hat = 0;
       value = F.Sdl_hat.SDL_HAT_LEFTUP;
     });

     E.Keyboard({
       E.KeyboardEvent.timestamp = 8l;
       event_type = F.Sdl_event_type.SDL_KEYDOWN;
       window_id = 5l;
       state = F.Sdl_button_state.SDL_PRESSED;
       repeat = true;
       keysym = {
         S.Keysym.scancode = F.Sdl_scancode.SDL_SCANCODE_0;
         sym = F.Sdl_keycode.SDLK_0;
         keymod = [F.Sdl_keymod.KMOD_NONE];
       }
     });

     E.MouseButton({
       E.MouseButtonEvent.timestamp = 9l;
       window_id = 10l;
       which = 0l;
       button = F.Sdl_mousebutton.SDL_BUTTON_L;
       state = F.Sdl_button_state.SDL_PRESSED;
       clicks = 3;
       x = 10;
       y = 12;
     });

     E.MouseMotion({
       E.MouseMotionEvent.timestamp = 11l;
       window_id = 12l;
       which = 0l;
       state = [Flags.Sdl_mousebutton.SDL_BUTTON_L];
       x = 12;
       y = 13;
       xrel = 14;
       yrel = 15;
     });

     E.MouseWheel({
       E.MouseWheelEvent.timestamp = 12l;
       window_id = 13l;
       which = 0l;
       x = 14;
       y = 15;
       direction = F.Sdl_mousewheel.SDL_MOUSEWHEEL_NORMAL;
     });

     E.MultiGesture({
       E.MultiGestureEvent.timestamp = 13l;
       touch_id = 0L;
       delta_theta = 1.0;
       delta_dist = 4.0;
       x = 2.0;
       y = 56.0;
       num_fingers = 1;
     });

     E.Quit({
       E.QuitEvent.timestamp = 14l;
     });

     E.SysWM({
       E.SysWMEvent.timestamp = 15l;
     });

     E.TextEditing({
       E.TextEditingEvent.timestamp = 17l;
       window_id = 18l;
       text = "h";
       start = 12;
       length = 3;
     });

     E.TextInput({
       E.TextInputEvent.timestamp = 17l;
       window_id = 18l;
       text = "inputted"
     });

     E.TouchFinger({
       E.TouchFingerEvent.timestamp = 18l;
       touch_id = 0L;
       finger_id = 1L;
       x = 1.0;
       y = 2.0;
       dx = 3.0;
       dy = 4.0;
       pressure = 5.0;
       motion = `MOTION;
     });

     E.Window({
       E.WindowEvent.timestamp = 19l;
       window_id = 20l;
       event = E.Window_event.HIDDEN;
     })
   ] in
   List.iter ~f:(fun e ->
     let ret = Event.push e in
     ret [@eq Types.Result.Success ()]
   ) events

]
