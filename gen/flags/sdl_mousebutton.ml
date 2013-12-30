type t =
    SDL_BUTTON_X2
  | SDL_BUTTON_X1
  | SDL_BUTTON_R
  | SDL_BUTTON_M
  | SDL_BUTTON_L

let button x = 1 lsl (x - 1)

let button_map = [
  (SDL_BUTTON_X2, button 5);
  (SDL_BUTTON_X1, button 4);
  (SDL_BUTTON_R, button 3);
  (SDL_BUTTON_M, button 2);
  (SDL_BUTTON_L, button 1);
]

let to_int = function
  | SDL_BUTTON_X2 -> button 5
  | SDL_BUTTON_X1 -> button 4
  | SDL_BUTTON_R -> button 3
  | SDL_BUTTON_M -> button 2
  | SDL_BUTTON_L -> button 1

let of_int v = List.find (fun x -> (snd x) = v) button_map |> fst

let of_int_list v = List.filter (fun x -> (snd x) land v > 0) button_map |>
                    List.map fst

let to_combined_int values = List.map to_int values |> List.fold_left (fun s v -> s lor v) 0
