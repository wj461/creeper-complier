
 type buffer =
  { text : string
  ; mutable current :
     int
  ; mutable last : int
  }

 let next_char b =
  if
     b.current = String.length b.text then
  raise End_of_file;
  let c =
     b.text.[b.current] in
  b.current <- b.current + 1;
  c

        
let rec state1 b =
  b.last <- b.current
and state2 b =
  try
    match next_char b with
     | '#' -> state1 b
     | 'a' -> state2 b
     | 'b' -> state3 b
     | _ -> failwith "lexical error" 
    with
     | End_of_file -> failwith "End_of_file"
and state3 b =
  try
    match next_char b with
     | 'a' -> state3 b
     | 'b' -> state2 b
     | _ -> failwith "lexical error" 
    with
     | End_of_file -> failwith "End_of_file"
let start = state2