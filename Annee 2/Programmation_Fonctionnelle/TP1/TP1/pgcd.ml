(*  Exercice à rendre **)
(*
  pgcd : int -> int -> int
  calcule le PGCD entre 2 entiers
  a : le premier entier, qui doit être positif
  b : le second entier, qui doit être positif
  renvoie le PGCD entre a et b, inférieur à a et b
*)

let rec pgcd a b =
  if a = 0 || b = 0
    then 0
  else
    let a = abs a and b = abs b in
      if a = b
        then a
      else if a > b
          then pgcd (a-b) b
      else pgcd a (b-a)

(*  TO DO : tests unitaires *)

let%test _ = pgcd 1 1 = 1
let%test _ = pgcd 6 2 = 2
let%test _ = pgcd 16 12 = 4
let%test _ = pgcd 16 (-12) = 4
let%test _ = pgcd (-30) 15 = 15
let%test _ = pgcd (-121) (-77) = 11
let%test _ = pgcd 0 1000 = 0
let%test _ = pgcd 314 0 = 0