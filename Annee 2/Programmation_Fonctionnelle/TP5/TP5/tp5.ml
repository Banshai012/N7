(* Evaluation des expressions simples *)


(* Module abstrayant les expressions *)
module type ExprSimple =
sig
  type t
  val const : int -> t
  val plus : t -> t -> t
  val mult : t-> t -> t
end

(* Module réalisant l'évaluation d'une expression *)
module EvalSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = c
  let plus e1 e2 = e1 + e2
  let mult e1 e2 = e1 * e2
end


(* Solution 1 pour tester *)
(* A l'aide de foncteur *)

(* Définition des expressions *)
module ExemplesSimples (E:ExprSimple) =
struct
  (* 1+(2*3) *)
  let exemple1  = E.(plus (const 1) (mult (const 2) (const 3)) )
  (* (5+2)*(2*3) *)
  let exemple2 =  E.(mult (plus (const 5) (const 2)) (mult (const 2) (const 3)) )
end

(* Module d'évaluation des exemples *)
module EvalExemples =  ExemplesSimples (EvalSimple)

let%test _ = (EvalExemples.exemple1 = 7)
let%test _ = (EvalExemples.exemple2 = 42)

(* Il écrit le calcul *)
module PrintSimple : ExprSimple with type t = string =
struct
  type t = string
  let const c = string_of_int c
  let plus e1 e2 = "(" ^ e1 ^ " + " ^ e2 ^ ")"
  let mult e1 e2 = "(" ^ e1 ^ " * " ^ e2 ^ ")"
end

(* Module d'évaluation de PrintSimple *)
module EvalPrintSimple =  ExemplesSimples (PrintSimple)

let%test _ = (EvalPrintSimple.exemple1 = "(1 + (2 * 3))")
let%test _ = (EvalPrintSimple.exemple2 = "((5 + 2) * (2 * 3))")

(* Il compte le nombre d'expression dans un calcul *)
module CompteSimple : ExprSimple with type t = int =
struct
  type t = int
  let const c = 0
  let plus e1 e2 = 1 + e1 + e2
  let mult e1 e2 = 1 + e1 + e2
end

(* Module d'évaluation de CompteSimple *)
module EvalCompte =  ExemplesSimples (CompteSimple)

let%test _ = (EvalCompte.exemple1 = 2)
let%test _ = (EvalCompte.exemple2 = 3)

(* Module abstrayant des nouvelles expressions*)
module type ExprVar =
sig
  type t
  val def : string -> t -> t -> t
  val var : string -> t
end

(* Module permettant la fusion des 2 expressions crées au-dessus *)
module type Expr =
sig
  include ExprSimple
  include (ExprVar with type t:=t)
end

(* Il affiche la def et la var *)
module PrintVar : ExprVar with type t = string =
struct
  type t = string
  let def s e1 e2 = "let " ^ s ^ " = " ^ e1 ^ " in " ^ e2
  let var s = s
end

(* Définition des expressions *)
module ExemplesVar (E:ExprVar) =
struct
  let exemple3  = E.(def "x" (var "(1 + 2)") (var "(x * 3)") )
end

(* Module d'évaluation de ExemplesVar *)
module EvalPrintVar =  ExemplesVar (PrintVar)

let%test _ = (EvalPrintVar.exemple3 = "let x = (1 + 2) in (x * 3)")

(* Un module print qui fusionne les 2 Print d'avant *)
module Print : Expr with type t = string =
struct
  include PrintSimple
  include (PrintVar : ExprVar with type t := t)
end

(* Définition des expressions *)
module Exemples (E:Expr) =
struct
  let exemple4  = E.(def "x" ((plus (const 1) (const 2))) ((mult (var "x") (const 3))))
end

(* Module d'évaluation de ExemplesVar *)
module EvalPrint =  Exemples (Print)

let%test _ = (EvalPrint.exemple4 = "let x = (1 + 2) in (x * 3)")
