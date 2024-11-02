open A

let print_substring str start finish =
  let length = finish - start in
  let sub = String.sub str start length in
  print_endline sub

let () =
  let b = { text = "abbac"; current = 0; last = 0 } in
  while 1 = 1 do
    try
      start b;
      print_substring b.text b.last b.current;
      b.last <- b.current
    with Failure msg -> (
      match msg with
      | "lexical error" -> failwith "lexical error"
      | "End_of_file" -> raise End_of_file
      | _ -> raise End_of_file)
  done
