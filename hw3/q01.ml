type ichar = char * int

module Cset = Set.Make (struct
  type t = ichar

  let compare = Stdlib.compare
end)

type regexp =
  | Epsilon
  | Character of ichar
  | Union of regexp * regexp
  | Concat of regexp * regexp
  | Star of regexp

let rec null regexp =
  match regexp with
  | Epsilon -> true
  | Character r -> false
  | Union (r1, r2) -> null r1 || null r2
  | Concat (r1, r2) -> null r1 && null r2
  | Star r -> true

(* q01 *)
let () =
  let a = Character ('a', 0) in
  assert (not (null a));
  assert (null (Star a));
  assert (null (Concat (Epsilon, Star Epsilon)));
  assert (null (Union (Epsilon, a)));
  assert (not (null (Concat (a, Star a))))

let rec first regexp =
  match regexp with
  | Epsilon -> Cset.empty
  | Character r -> Cset.singleton r
  | Union (r1, r2) -> Cset.union (first r1) (first r2)
  | Concat (r1, r2) ->
    if null r1 then
      Cset.union (first r1) (first r2)
    else
      first r1
  | Star r -> first r

let rec last regexp =
  match regexp with
  | Epsilon -> Cset.empty
  | Character r -> Cset.singleton r
  | Union (r1, r2) -> Cset.union (last r1) (last r2)
  | Concat (r1, r2) ->
    if null r2 then
      Cset.union (last r1) (last r2)
    else
      last r2
  | Star r -> last r

(* q02 *)
let () =
  let ca = ('a', 0)
  and cb = ('b', 0) in
  let a = Character ca
  and b = Character cb in
  let ab = Concat (a, b) in
  let eq = Cset.equal in
  assert (eq (first a) (Cset.singleton ca));
  assert (eq (first ab) (Cset.singleton ca));
  assert (eq (first (Star ab)) (Cset.singleton ca));
  assert (eq (last b) (Cset.singleton cb));
  assert (eq (last ab) (Cset.singleton cb));
  assert (Cset.cardinal (first (Union (a, b))) = 2);
  assert (Cset.cardinal (first (Concat (Star a, b))) = 2);
  assert (Cset.cardinal (last (Concat (a, Star b))) = 2)

let rec follow ichar regexp =
  match regexp with
  | Epsilon -> Cset.empty
  | Character r -> Cset.empty
  | Union (r1, r2) -> Cset.union (follow ichar r1) (follow ichar r2)
  | Concat (r1, r2) ->
    if Cset.mem ichar (last r1) then
      Cset.union (Cset.union (follow ichar r1) (follow ichar r2)) (first r2)
    else
      Cset.union (follow ichar r1) (follow ichar r2)
  | Star r ->
    if Cset.mem ichar (last r) then
      Cset.union (follow ichar r) (first r)
    else
      follow ichar r

(* q03 *)
let () =
  let ca = ('a', 0)
  and cb = ('b', 0) in
  let a = Character ca
  and b = Character cb in
  let ab = Concat (a, b) in
  assert (Cset.equal (follow ca ab) (Cset.singleton cb));
  assert (Cset.is_empty (follow cb ab));
  let r = Star (Union (a, b)) in
  assert (Cset.cardinal (follow ca r) = 2);
  assert (Cset.cardinal (follow cb r) = 2);
  let r2 = Star (Concat (a, Star b)) in
  assert (Cset.cardinal (follow cb r2) = 2);
  let r3 = Concat (Star a, b) in
  assert (Cset.cardinal (follow ca r3) = 2)

let next_state regexp q c =
  let q' = ref Cset.empty in
  Cset.iter
    (fun ichar ->
      if c = fst ichar then
        q' := Cset.union (follow ichar regexp) !q')
    q;
  !q'

type state = Cset.t (* a state is a set of characters *)

module Cmap = Map.Make (Char) (* dictionary whose keys are characters *)
module Smap = Map.Make (Cset) (* dictionary whose keys are states *)

type autom =
  { start : state
  ; trans : state Cmap.t Smap.t
        (* state dictionary -> (character dictionary -> state) *)
  }

let eof = ('#', -1)

let make_dfa r =
  let r = Concat (r, Character eof) in
  (* transitions under construction *)
  let trans = ref Smap.empty in
  let rec transitions q =
    if not (Smap.mem q !trans) then (
      let cmap' = ref Cmap.empty in
      Cset.iter
        (fun ichar ->
          if not (Cmap.mem (fst ichar) !cmap') then
            cmap' := Cmap.add (fst ichar) (next_state r q (fst ichar)) !cmap')
        q;
      trans := Smap.add q !cmap' !trans;
      Cmap.iter (fun _ q' -> transitions q') !cmap')
  in

  let q0 = first r in
  transitions q0;
  { start = q0; trans = !trans }

let fprint_state fmt q =
  Cset.iter
    (fun (c, i) ->
      if c = '#' then
        Format.fprintf fmt "# "
      else
        Format.fprintf fmt "%c%i " c i)
    q

let fprint_transition fmt q c q' =
  Format.fprintf
    fmt
    "\"%a\" -> \"%a\" [label=\"%c\"];@\n"
    fprint_state
    q
    fprint_state
    q'
    c

let fprint_autom fmt a =
  Format.fprintf fmt "digraph A {@\n";
  Format.fprintf fmt " @[\"%a\" [ shape = \"rect\"];@\n" fprint_state a.start;
  Smap.iter
    (fun q t -> Cmap.iter (fun c q' -> fprint_transition fmt q c q') t)
    a.trans;
  Format.fprintf fmt "@]@\n}@."

let save_autom file a =
  let ch = open_out file in
  Format.fprintf (Format.formatter_of_out_channel ch) "%a" fprint_autom a;
  close_out ch

(* q04 *)
(* (a|b)*a(a|b) *)
let r =
  Concat
    ( Star (Union (Character ('a', 1), Character ('b', 1)))
    , Concat (Character ('a', 2), Union (Character ('a', 3), Character ('b', 2)))
    )

(* last = -1 current = 0 acbabac

   failwirh ... catch => last = -1 => no token => last != -1 => yes token
   current = 2 last = current --> bab *)

let a = make_dfa r

let () = save_autom "autom.dot" a

(* val recognize : autom -> string -> bool *)
let recognize autom str =
  try
    let q' = ref autom.start in
    String.iter
      (fun c ->
        let cmap' = Smap.find !q' autom.trans in
        try q' := Cmap.find c cmap' with Not_found -> failwith "not work")
      str;
    Cset.mem eof !q'
  with _ -> false

(* q05 *)
let () = assert (recognize a "aa")

let () = assert (recognize a "ab")

let () = assert (recognize a "abababaab")

let () = assert (recognize a "babababab")

let () = assert (recognize a (String.make 1000 'b' ^ "ab"))

let () = assert (not (recognize a ""))

let () = assert (not (recognize a "a"))

let () = assert (not (recognize a "b"))

let () = assert (not (recognize a "ba"))

let () = assert (not (recognize a "aba"))

let () = assert (not (recognize a "abababaaba"))

let r =
  Star
    (Union
       ( Star (Character ('a', 1))
       , Concat
           ( Character ('b', 1)
           , Concat (Star (Character ('a', 2)), Character ('b', 2)) ) ))

let a = make_dfa r

let () = save_autom "autom2.dot" a

let () = assert (recognize a "")

let () = assert (recognize a "bb")

let () = assert (recognize a "aaa")

let () = assert (recognize a "aaabbaaababaaa")

let () = assert (recognize a "bbbbbbbbbbbbbb")

let () = assert (recognize a "bbbbabbbbabbbabbb")

let () = assert (not (recognize a "b"))

let () = assert (not (recognize a "ba"))

let () = assert (not (recognize a "ab"))

let () = assert (not (recognize a "aaabbaaaaabaaa"))

let () = assert (not (recognize a "bbbbbbbbbbbbb"))

let () = assert (not (recognize a "bbbbabbbbabbbabbbb"))

let generate_index start a =
  let index = ref Smap.empty in
  index := Smap.add start 0 !index;
  let index_value = ref 1 in
  Smap.iter
    (fun key _ ->
      index := Smap.add key !index_value !index;
      index_value := !index_value + 1)
    a;
  !index

let generate_match fmt cmp' index_map =
  Cmap.iter
    (fun c q' ->
      let index = Smap.find q' index_map in
      Format.fprintf fmt "    | '%c' -> state%d b\n " c index)
    cmp';

  Format.fprintf fmt "    | _ -> failwith \"lexical error\" "

let generate_state fmt q cmp' index_map first_flag =
  let index = Smap.find q index_map in
  if !first_flag then (
    first_flag := false;
    Format.fprintf fmt "\nlet rec state%d b =\n" index)
  else
    Format.fprintf fmt "\nand state%d b =\n" index;
  if cmp' = Cmap.empty then
    Format.fprintf fmt "  b.last <- b.current"
  else if Cmap.mem '#' cmp' then
    Format.fprintf
      fmt
      "  state%d b\n "
      (Smap.find (Cmap.find '#' cmp') index_map)
  else (
    Format.fprintf fmt "  try\n    match next_char b with\n ";
    generate_match fmt cmp' index_map;
    Format.fprintf
      fmt
      "\n    with\n     | End_of_file -> failwith \"End_of_file\"")

let generate str autom =
  let c =
    "\n\
    \ type buffer =\n\
    \  { text : string\n\
    \  ; mutable current :\n\
    \     int\n\
    \  ; mutable last : int\n\
    \  }\n\n\
    \ let next_char b =\n\
    \  if\n\
    \     b.current = String.length b.text then\n\
    \  raise End_of_file;\n\
    \  let c =\n\
    \     b.text.[b.current] in\n\
    \  b.current <- b.current + 1;\n\
    \  c\n\n\
    \        "
  in
  let index_map = generate_index autom.start autom.trans in
  let ch = open_out str in
  let fmt = Format.formatter_of_out_channel ch in
  let first_flag = ref true in
  Format.fprintf fmt "%s" c;

  Smap.iter
    (fun q' cmp' -> generate_state fmt q' cmp' index_map first_flag)
    autom.trans;

  Format.fprintf fmt "\nlet start = state%d" (Smap.find autom.start index_map);

  close_out ch

let r3 = Concat (Star (Character ('a', 1)), Character ('b', 1))

let a = make_dfa r3

let () = generate "a.ml" a

let r4 =
  Concat
    ( Concat
        ( Union (Character ('b', 1), Epsilon)
        , Star (Concat (Character ('a', 1), Character ('b', 2))) )
    , Union (Character ('a', 2), Epsilon) )

let a = make_dfa r4

let () = generate "a.ml" a
