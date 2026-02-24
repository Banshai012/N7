type typ = Bool | Int | Rat | Ptr of typ | Void | TID of string | Undefined

let rec string_of_type t = 
  match t with
  | Bool ->  "Bool"
  | Int  ->  "Int"
  | Rat  ->  "Rat"
  | Ptr(typ) -> "Pointeur de " ^ (string_of_type typ)
  | Void -> "Void"
  | TID(n) -> "TID " ^ n
  | Undefined -> "Undefined"

let rec est_compatible t1 t2 =
  match t1, t2 with
  | Bool, Bool -> true
  | Int, Int -> true
  | Rat, Rat -> true 
  | Ptr(type1), Ptr(type2) -> (est_compatible type1 type2)
  | type1, Ptr(type2) -> (est_compatible type1 type2)
  | Void, Void -> true
  | TID(n1), TID(n2) when n1 = n2 -> true
  | _ -> false 

let%test _ = est_compatible Bool Bool
let%test _ = est_compatible Int Int
let%test _ = est_compatible Rat Rat
let%test _ = not (est_compatible Int Bool)
let%test _ = not (est_compatible Bool Int)
let%test _ = not (est_compatible Int Rat)
let%test _ = not (est_compatible Rat Int)
let%test _ = not (est_compatible Bool Rat)
let%test _ = not (est_compatible Rat Bool)
let%test _ = not (est_compatible Undefined Int)
let%test _ = not (est_compatible Int Undefined)
let%test _ = not (est_compatible Rat Undefined)
let%test _ = not (est_compatible Bool Undefined)
let%test _ = not (est_compatible Undefined Int)
let%test _ = not (est_compatible Undefined Rat)
let%test _ = not (est_compatible Undefined Bool)
let%test _ = est_compatible (Ptr Int) (Ptr Int)
let%test _ = not (est_compatible (Ptr Int) (Ptr Bool))
let%test _ = not (est_compatible (Ptr Rat) (Ptr Int))
let%test _ = est_compatible (Ptr (Ptr Bool)) (Ptr (Ptr Bool))
let%test _ = not (est_compatible (Ptr (Ptr Bool)) (Ptr (Ptr Int)))

let est_compatible_list lt1 lt2 =
  try
    List.for_all2 est_compatible lt1 lt2
  with Invalid_argument _ -> false

let%test _ = est_compatible_list [] []
let%test _ = est_compatible_list [Int ; Rat] [Int ; Rat]
let%test _ = est_compatible_list [Bool ; Rat ; Bool] [Bool ; Rat ; Bool]
let%test _ = not (est_compatible_list [Int] [Int ; Rat])
let%test _ = not (est_compatible_list [Int] [Rat ; Int])
let%test _ = not (est_compatible_list [Int ; Rat] [Rat ; Int])
let%test _ = not (est_compatible_list [Bool ; Rat ; Bool] [Bool ; Rat ; Bool ; Int])

let getTaille t =
  match t with
  | Int -> 1
  | Bool -> 1
  | Rat -> 2
  | Ptr _ -> 1
  | Void -> 0
  | TID _ -> 1
  | Undefined -> 0
  
let%test _ = getTaille Int = 1
let%test _ = getTaille Bool = 1
let%test _ = getTaille Rat = 2
let%test _ = getTaille (Ptr (Rat)) = 1
let%test _ = getTaille (Ptr (Int)) = 1
let%test _ = getTaille Void = 0
