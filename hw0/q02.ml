let fibo n =
  let rec fibo_cal c fc fc_1 =
    if c = n then
      fc
    else
      fibo_cal (c + 1) fc_1 (fc + fc_1)
  in
  fibo_cal 0 1 1

let () = prerr_int (fibo 10)
