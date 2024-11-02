
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
  state1 b
 
and state3 b =
  state1 b
 
and state4 b =
  state1 b
 
let start = state3