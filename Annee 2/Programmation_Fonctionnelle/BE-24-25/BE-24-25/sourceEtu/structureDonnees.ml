(* Pour les tests *)
(* [eq_perm l l'] retourne true ssi [l] et [l']
   sont égales à à permutation près (pour (=)).
   [l'] ne doit pas contenir de doublon. *)
let eq_perm l l' =
  List.length l = List.length l' && List.for_all (fun x -> List.mem x l) l'


module type StructureDonnees =
sig

  (* Type permettant de stocker le dictionnaire *)
  type dico

  (* Dictionnaire vide *)
  val empty : dico

  (* Ajoute un mot et son encodage au dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* deuxième paramètre : le mot *)
  (* troisième paramètre : le dictionnaire *)
  val ajouter : int list -> string -> dico -> dico

  (* Cherche tous les mots associés à un encodage dans un dictionnaire *)
  (* premier parametre : l'encodage du mot *)
  (* second paramètre : le dictionnaire *)
  val chercher : int list -> dico -> string list


  (* Calcule le nombre maximum de mots ayant le même encodage dans un
     dictionnaire *)
  (* paramètre : le dictionnaire *)
  val max_mots_code_identique : dico -> int

  (* Liste tous les mots d'un dictionnaire dont un prefixe de l'encodage est donné en paramètre *)
  (* premier paramètre : le prefixe de l'encodage *)
  (* second paramètre : le dictionnaire *)
  val prefixe : int list -> dico -> string list

end

module ListAssoc : StructureDonnees with type dico = ( int list * string list ) list =
struct
  type dico = ( int list * string list ) list
  let empty = []
  let ajouter liste mot dico =
    let rec ajouter_aux liste mot dico =
      match dico with
      | [] -> []
      | (ln, lm)::dq -> if (List.equal (=) ln liste) then (liste, mot::lm)::dq else (ln, lm)::(ajouter_aux liste mot dq)
    in ajouter_aux liste mot dico
  let chercher liste dico =
    let rec chercher_aux liste dico =
      match dico with
      | [] -> []
      | (ln, lm)::dq -> if (List.equal (=) ln liste) then lm else (ajouter_aux liste mot dq)
    in chercher_aux liste dico
  let max_mots_code_identique dico =
    let rec max_mots_code_identique_aux dico =
      | [] -> 0
      | (ln, lm)::dq -> 
        let taille = max_mots_code_identique_aux dq in
        if ((Liste.length lm) > taille) then Liste.length lm else taille
    in max_mots_code_identique_aux dico
  let prefixe liste dico =
    let rec prefixe_aux liste dico =
      match dico with
      | [] -> []
      | (ln, lm)::dq -> if (List.equal (=) (List.take (List.length liste) ln) liste) then lm@(prefixe_aux liste dq) else (prefixe_aux liste dq)
    in prefixe_aux liste dico
end

module Arbre : StructureDonnees with type dico = Noeud of ( string list * ( int * dico) list ) =
struct
  type dico = Noeud of ( string list * ( int * dico) list )
  let empty = Noeud([], [])
  let ajouter liste mot dico =
    let rec ajouter_aux liste mot dico =
      match (liste, dico) with
      | ([], Noeud(lm, lb)) -> Noeud((mot::lm), lb)
      | (t::q, Noeud(lm, [])) -> Noeud(lm, ([(t, (ajouter_aux q mot Noeud([], [])))]))
      | (t::q, Noeud(lm, (ti, td)::qlb)) -> if (t = ti) then ajouter_aux q mot td else ajouter_aux liste mot Noeud(lm, qlb)
    in ajouter_aux liste mot dico
  let chercher liste dico =
    let rec chercher_aux liste dico =
      match (liste, dico) with
      | ([], Noeud(lm, lb)) -> lm
      | (t::q, Noeud(lm, [])) -> []
      | (t::q, Noeud(lm, (ti, td)::qlb)) -> if (t = ti) then chercher_aux q td else chercher_aux liste Noeud(lm, qlb)
    in chercher_aux liste dico
  let max_mots_code_identique dico =
    let rec max_mots_code_identique_aux dico =
      match dico with
      | Noeud(lm, []) -> List.length lm
      | Noeud(lm, (ti, td)::qlb) ->
        let taille1 = max_mots_code_identique_aux td in
        let taille2 = max_mots_code_identique_aux Noeud(lm, qlb) in
        if (taille1 > taille2) then taille1 else taille2
      in max_mots_code_identique_aux dico
  let prefixe liste dico =
    let prefixe_aux liste dico =
      match (liste, dico) with
      | ([], Noeud(lm, [])) -> lm
      | ([], Noeud(lm, (ti, td)::qlb)) -> (prefixe_aux [] td)@(prefixe_aux [] Noeud(lm, qlb))
      | (t::q, Noeud(lm, [])) -> []
      | (t::q, Noeud(lm, (ti, td)::qlb)) -> if (t = ti) then prefixe_aux q td else prefixe_aux liste Noeud(lm, qlb)
    in prefixe_aux liste dico
end