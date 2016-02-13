open Sdlcaml.Std

let%spec "The SDL Log module can log that proirotiy is critical for each category" =
  let categories = [`INPUT;`RENDER;`VIDEO;`AUDIO;`SYSTEM;`ERROR;`APPLICATION] in
  List.iter (fun cat ->
    Log.set_output_function (fun incat inpri mes ->
      incat [@eq cat];
      inpri [@eq `CRITICAL];
      mes [@eq "test1"];
    );

    Log.log_critical cat "test%d" 1 ()
  ) categories

let%spec "The SDL Log module can log that priority as debug for each category" =
  let categories = [`INPUT;`RENDER;`VIDEO;`AUDIO;`SYSTEM;`ERROR;`APPLICATION] in
  List.iter (fun cat ->
    Log.set_output_function (fun incat inpri mes ->
      incat [@eq cat];
      inpri [@eq `DEBUG];
      mes [@eq "test2"]
    );

    Log.set_priority ~category:cat ~priority:`DEBUG ();
    Log.log_debug cat "test%d" 2 ()
  ) categories

let%spec "The SDL Log module can log that priority as info for each category" =
  let categories = [`INPUT;`RENDER;`VIDEO;`AUDIO;`SYSTEM;`ERROR;`APPLICATION] in
  List.iter (fun cat ->
    Log.set_output_function (fun incat inpri mes ->
      incat [@eq cat];
      inpri [@eq `INFO];
      mes [@eq "test2"]
    );

    Log.set_priority ~category:cat ~priority:`INFO ();
    Log.log_info cat "test%d" 2 ()
  ) categories

let%spec "The SDL Log module can log that priority as verbose for each category" =
  let categories = [`INPUT;`RENDER;`VIDEO;`AUDIO;`SYSTEM;`ERROR;`APPLICATION] in
  List.iter (fun cat ->
    Log.set_output_function (fun incat inpri mes ->
      incat [@eq cat];
      inpri [@eq `VERBOSE];
      mes [@eq "test2"];
    );

    Log.set_priority ~category:cat ~priority:`VERBOSE ();
    Log.log_verbose cat "test%d" 2 ()
  ) categories

let%spec "The SDL Log module can log that priority as warn for each category" =
  let categories = [`INPUT;`RENDER;`VIDEO;`AUDIO;`SYSTEM;`ERROR;`APPLICATION] in
  List.iter (fun cat ->
    Log.set_output_function (fun incat inpri mes ->
      incat [@eq cat];
      inpri [@eq `WARN];
      mes [@eq "test2"];
    );

    Log.set_priority ~category:cat ~priority:`WARN ();
    Log.log_warn cat "test%d" 2 ();

    (Log.get_priority cat) [@eq `WARN]

  ) categories
