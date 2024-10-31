module Cset = Set.Make (struct
  type t = ichar

  let compare = Stdlib.compare
end)
