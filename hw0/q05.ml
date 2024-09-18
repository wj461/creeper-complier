let rec square_sum list =
  match list with
  | [] -> 0
  | first :: rest -> (first * first) + square_sum rest

let square_sum_not_rec lst =
  lst |> List.map (fun x -> x * x) |> List.fold_left ( + ) 0

let find_opt value list =
  let rec aux i list' =
    match list' with
    | [] -> None
    | first :: rest ->
      if first = value then
        Some i
      else
        aux (i + 1) rest
  in
  aux 0 list

let find_opt_not_rec value list =
  List.find_index (fun value' -> value = value') list

let print_option opt =
  match opt with
  | None -> print_endline "None"
  | Some value -> print_endline (string_of_int value)

let () =
  print_string "(a) ";
  print_int (square_sum [ 1; 2; 3; 4; 5 ]);
  print_newline ()

let () =
  print_string "(a-2) ";
  print_int (square_sum_not_rec [ 1; 2; 3; 4; 5 ]);
  print_newline ()

let () =
  print_string "(b) ";
  print_option (find_opt 4 [ 1; 2; 3; 4; 5 ])

let () =
  print_string "(b-2) ";
  print_option (find_opt_not_rec 4 [ 1; 2; 3; 4; 5 ])
