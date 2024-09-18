let rec fact n =
  if n = 0 then
    1
  else
    n * fact (n - 1)

let rec nb_bit_pos n =
  if n = 0 then
    0
  else if n land 1 = 1 then
    1 + nb_bit_pos (n lsr 1)
  else
    0 + nb_bit_pos (n lsr 1)

let () = Printf.printf "%d, %d" (nb_bit_pos 45) (fact 5)
