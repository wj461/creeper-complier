let revert_string s =
  let rec revert new_string old_string =
    if old_string = "" then
      new_string
    else
      revert
        (new_string ^ String.sub old_string (String.length old_string - 1) 1)
        (String.sub old_string 0 (String.length old_string - 1))
  in
  revert "" s

let palindrome s =
  if revert_string s = s then
    true
  else
    false

let () =
  print_string "(a) ";
  print_string (string_of_bool (palindrome "ABCBA"));
  print_newline ()

let compare m1 m2 =
  let m1_len = String.length m1 in
  let m2_len = String.length m2 in
  if m1_len < m2_len then
    true
  else if m1_len > m2_len then
    false
  else
    let rec compare_string m1_string m2_string =
      let m1_first = String.get m1_string 0 in
      let m2_first = String.get m2_string 0 in
      if m1_string = "" then
        false
      else if m1_first < m2_first then
        true
      else if m1_first > m2_first then
        false
      else
        compare_string
          (String.sub m1_string 1 (String.length m1_string - 1))
          (String.sub m2_string 1 (String.length m2_string - 1))
    in
    compare_string m1 m2

let () =
  print_string "(b) ";
  print_string (string_of_bool (compare "abc" "abd"));
  print_newline ()

let rec factor m1 m2 =
  if String.length m2 < String.length m1 then
    false
  else if m1 = String.sub m2 0 (String.length m1) then
    true
  else
    factor m1 (String.sub m2 1 (String.length m2 - 1))

let () =
  print_string "(c) ";
  print_string (string_of_bool (factor "ac" "aaaaaaacfffffffff"))
