
type buffer =
  { text : string
  ; mutable current : int
  ; mutable last : int
  }

let next_char b =
  if b.current = String.length b.text then
    raise End_of_file;
  let c = b.text.[b.current] in
  b.current <- b.current + 1;
  c

let rec state1 b =
  try
    match next_char b with
    | 'a' -> state2 b
  with
    | End_of_file -> state3 b

let rec state2 b = ...
let rec state3 b = ... // end

module Smap = Map.Make (Cset) (* dictionary whose keys are states *)
