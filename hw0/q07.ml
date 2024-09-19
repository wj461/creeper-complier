type 'a seq =
  | Elt of 'a
  | Seq of 'a seq * 'a seq

let ( @@ ) x y = Seq (x, y)

let rec hd sq =
  match sq with
  | Elt x -> x
  | Seq (sq_1, sq_2) -> hd sq_1

let rec tl sq =
  match sq with
  | Elt x -> sq
  | Seq (sq_1, sq_2) -> (
    match sq_1 with
    | Elt x' -> sq_2
    | Seq (sq_1_1, sq_1_2) -> tl sq_1 @@ sq_2)

let rec mem value sq =
  match sq with
  | Elt x' -> x' = value
  | Seq (sq_1, sq_2) -> mem value sq_1 || mem value sq_2

let rec rev sq =
  match sq with
  | Elt x' -> Elt x'
  | Seq (sq_1, sq_2) -> rev sq_2 @@ rev sq_1

let rec map f sq =
  match sq with
  | Elt x' -> Elt (f x')
  | Seq (sq_1, sq_2) -> map f sq_1 @@ map f sq_2

let rec fold_left f init sq =
  match sq with
  | Elt x' -> f init x'
  | Seq (sq_1, sq_2) -> fold_left f (fold_left f init sq_1) sq_2

let rec fold_right f sq init =
  match sq with
  | Elt x' -> f x' init
  | Seq (sq_1, sq_2) -> fold_right f sq_1 (fold_right f sq_2 init)

let rec print_seq sq =
  match sq with
  | Elt x -> Printf.printf "%d " x
  | Seq (sq_1, sq_2) ->
    print_seq sq_1;
    print_seq sq_2

let print_list list =
  print_string (String.concat " " (List.map string_of_int list));
  print_newline ()

let test = Seq (Elt 1, Seq (Elt 2, Elt 3))

let test_2 = Seq (Seq (Elt 2, Elt 3), Seq (Elt 2, Elt 3))

let test_3 =
  Seq (Seq (Seq (Elt 1, Elt 2), Elt 3), Seq (Seq (Elt 4, Elt 5), Elt 6))

(* let () = print_seq (map (fun x -> x * x) test_3) *)

let () =
  print_seq test_3;
  print_newline ();
  print_int (fold_left (fun x y -> x - y) 0 test_3);
  print_newline ();
  print_int (fold_right (fun x y -> y - x) test_3 0)

(* let () = Printf.printf "%b" (mem 5 test_3) *)
