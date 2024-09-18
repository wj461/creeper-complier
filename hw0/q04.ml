let array = [ 11; 2; 5; 6; 7; 1; 3 ]

let merge_test = [ 1; 2; 5; 1; 3; 7; 9 ]

let split list =
  let size = List.length list / 2 in
  let rec split_at n list_s =
    if n <= 0 then
      ([], list_s)
    else
      match list_s with
      | [] -> ([], [])
      | x :: xs ->
        let first, rest = split_at (n - 1) xs in
        (x :: first, rest)
  in
  split_at size list

let first_element list =
  match list with
  | [] -> failwith "Empty list"
  | f :: list_rest -> f

let rest_element list =
  match list with
  | [] -> failwith "Empty list"
  | f :: list_rest -> list_rest

let merge l1 l2 =
  let rec aux merge_list l1' l2' =
    if l1' = [] then
      merge_list @ l2'
    else if l2' = [] then
      merge_list @ l1'
    else if first_element l1' < first_element l2' then
      aux (merge_list @ [ first_element l1' ]) (rest_element l1') l2'
    else
      aux (merge_list @ [ first_element l2' ]) l1' (rest_element l2')
  in
  aux [] l1 l2

let rec sort list =
  if List.length list <= 1 then
    list
  else
    let array_1, array_2 = split list in
    merge (sort array_1) (sort array_2)

let print_list list =
  print_string (String.concat " " (List.map string_of_int list));
  print_newline ()

let () =
  let array_1, array_2 = split array in
  print_string "(a) ";
  print_newline ();
  print_list array_1;
  print_list array_2

let () =
  let array_1, array_2 = split merge_test in
  print_string "(b) ";
  print_newline ();
  print_list (merge array_1 array_2)

let () =
  print_string "(c) ";
  print_newline ();
  print_list (sort array)
