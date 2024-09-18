let list_1 = List.init 1000001 (fun x -> x)

let rev list =
  let rec aux' result list' =
    match list' with
    | [] -> result
    | first :: rest -> aux' (first :: result) rest
  in
  aux' [] list

let map f list =
  let rec aux' result list' =
    match list' with
    | [] -> result
    | first :: rest -> aux' (f first :: result) rest
  in
  aux' [] list

let print_list list =
  print_string (String.concat " " (List.map string_of_int list));
  print_newline ()

let () = print_list (rev list_1)

let () = print_list (rev (map (fun x -> x * x) list_1))
