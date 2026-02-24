(****** Algorithmes combinatoires et listes ********)


(*** Code binaires de Gray ***)

(*CONTRAT
Fonction qui génère un code de Gray
Paramètre n : la taille du code
Resultat : le code sous forme de int list list
*)


let gray_code n =
  let rec rec_gray n =
    match n with
    | 0 -> [[]]
    | k -> let grayl = rec_gray (k - 1) in
      (List.map (fun l -> 0 :: l) grayl) @ (List.map (fun l -> 1 :: l) (List.rev grayl))
  in rec_gray n;;


(* TESTS *)
let%test _ = gray_code 0 = [[]]
let%test _ = gray_code 1 = [[0]; [1]]
let%test _ = gray_code 2=  [[0; 0]; [0; 1]; [1; 1]; [1; 0]]
let%test _ = gray_code 3 = [[0; 0; 0]; [0; 0; 1]; [0; 1; 1]; [0; 1; 0]; [1; 1; 0]; [1; 1; 1]; [1; 0; 1];
 [1; 0; 0]]
 let%test _ = gray_code 4 = [[0; 0; 0; 0]; [0; 0; 0; 1]; [0; 0; 1; 1]; [0; 0; 1; 0]; [0; 1; 1; 0];
  [0; 1; 1; 1]; [0; 1; 0; 1]; [0; 1; 0; 0]; [1; 1; 0; 0]; [1; 1; 0; 1];
  [1; 1; 1; 1]; [1; 1; 1; 0]; [1; 0; 1; 0]; [1; 0; 1; 1]; [1; 0; 0; 1];
  [1; 0; 0; 0]]


(*** Combinaisons d'une liste ***)

(* CONTRAT 
Fonction qui génère toutes les permuations de k-element d'une liste l, tels que k < length(l)
parametre k : le nombre d'element dans les sous-listes
parametre l : la liste sur laquelle on fait des permuations
Resultat : les permutations sous forme de int list list
*)
let combinaison k l =
  let rec rec_combinaison k l =
    match k with
    | 0 -> [[]]
    | n -> 
      match l with
      | [] -> []
      | t::q -> (List.map(fun p -> t::p) (rec_combinaison (k - 1) q))@(rec_combinaison k q)
  in rec_combinaison k l;;


(* TESTS *)
let%test _ = combinaison 1 [1; 2; 3; 4] = [[1]; [2]; [3]; [4]]
let%test _ = combinaison 2 [1; 2; 3; 4] = [[1; 2]; [1; 3]; [1; 4]; [2; 3]; [2; 4]; [3; 4]]
let%test _ = combinaison 4 [1; 2; 3; 4] = [[1; 2; 3; 4]]


(*** Partition d'un entier ***)

(* partition int -> int list list
Fonction qui calcule toutes les partitions possibles d'un entier n
Paramètre n : un entier dont on veut calculer les partitions
Préconditions : n >0
Retour : les partitions de n
*)

let partition n =
  let rec rec_partition n t =
    if t >= n then [[n]]
    else
      match n with
      | 1 -> [[1]]
      | k -> (List.map(fun l -> t::l) (rec_partition (k - t) 1))@(rec_partition k (t+1))
  in (rec_partition n 1);;

partition 4 = [[1; 1; 1; 1]; [1; 1; 2]; [1; 2; 1]; [1; 3]; [2; 1; 1]; [2; 2]; [3; 1]; [4]]Œ

(* TEST - à décommenter pour tester ! *)
(*
let%test _ = partition 1 = [[1]]
let%test _ = partition 2 = [[1;1];[2]]
let%test _ = partition 3 = [[1; 1; 1]; [1; 2]; [3]]
let%test _ = partition 4 = [[1; 1; 1; 1]; [1; 1; 2]; [1; 3]; [2; 2]; [4]]
*)



(*** Permutations d'une liste ***)

(* CONTRAT
Fonction prend en paramètre un élément e et une liste l et qui insére e à toutes les possitions possibles dans l
Pamaètre e : ('a) l'élément à insérer
Paramètre l : ('a list) la liste initiale dans laquelle insérer e
Reesultat : la liste des listes avec toutes les insertions possible de e dans l
*)

let rec insertion e l = failwith "TO DO"

(* TESTS - à décommenter pour tester !  *)
(*
let%test _ = insertion 0 [1;2] = [[0;1;2];[1;0;2];[1;2;0]]
let%test _ = insertion 0 [] = [[0]]
let%test _ = insertion 3 [1;2] = [[3;1;2];[1;3;2];[1;2;3]]
let%test _ = insertion 3 [] = [[3]]
let%test _ = insertion 5 [12;54;0;3;78] =
[[5; 12; 54; 0; 3; 78]; [12; 5; 54; 0; 3; 78]; [12; 54; 5; 0; 3; 78];
 [12; 54; 0; 5; 3; 78]; [12; 54; 0; 3; 5; 78]; [12; 54; 0; 3; 78; 5]]
 let%test _ = insertion 'x' ['a';'b';'c']=
 [['x'; 'a'; 'b'; 'c']; ['a'; 'x'; 'b'; 'c']; ['a'; 'b'; 'x'; 'c'];
  ['a'; 'b'; 'c'; 'x']]
*)

(* CONTRAT
Fonction qui renvoie la liste des permutations d'une liste
Paramètre l : une liste
Résultat : la liste des permutatiions de l (toutes différentes si les élements de l sont différents deux à deux 
*)

let rec permutations l = failwith "TO DO"

(* TESTS - à décommenter pour tester !  *)
(*
let l1 = permutations [1;2;3]
let%test _ = List.length l1 = 6
let%test _ = List.mem [1; 2; 3] l1 
let%test _ = List.mem [2; 1; 3] l1 
let%test _ = List.mem [2; 3; 1] l1 
let%test _ = List.mem [1; 3; 2] l1 
let%test _ = List.mem [3; 1; 2] l1 
let%test _ = List.mem [3; 2; 1] l1 
let%test _ = permutations [] =[[]]
let l2 = permutations ['a';'b']
let%test _ = List.length l2 = 2
let%test _ = List.mem ['a';'b'] l2 
let%test _ = List.mem ['b';'a'] l2 
*)

