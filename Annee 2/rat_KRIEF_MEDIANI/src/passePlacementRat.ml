(* Module de la passe de placement memoire *)
(* doit etre conforme a l'interface Passe *)
open Tds
open Ast
open Type

type t1 = Ast.AstType.programme
type t2 = Ast.AstPlacement.programme


(**************************************************************************************)
(* analyse_placement_instruction : AstType.instruction -> int -> string ->            *)
(* AstPlacement.instruction * int                                                     *)
(* Parametre i : l'instruction a analyser.                                            *)
(* Parametre depl : le deplacement courant par rapport au registre.                   *)
(* Parametre reg : le registre courant (SB ou LB).                                    *)
(* Calcule l'adresse relative des variables declarees et transforme l'instruction.    *)
(* Renvoie l'instruction placee et la taille occupee par les variables declarees.     *)
(* Erreur si mauvaise utilisation interne des identifiants.                           *)
(**************************************************************************************)
let rec analyse_placement_instruction i depl reg =
  match i with
  | AstType.Declaration (info, e) ->
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, _, _, _) -> 
        (* Mise a jour de l'adresse de la variable dans l'info_ast *)
        modifier_adresse_variable depl reg info;
        (AstPlacement.Declaration(info, e), getTaille t)
      | _ -> failwith "Erreur interne"
    end
  | AstType.Affectation (a, e) -> (AstPlacement.Affectation (a, e), 0)
  | AstType.AffichageInt e -> (AstPlacement.AffichageInt (e), 0)
  | AstType.AffichageRat e -> (AstPlacement.AffichageRat (e), 0)
  | AstType.AffichageBool e -> (AstPlacement.AffichageBool (e), 0)
  | AstType.Conditionnelle (c, t, e) ->
    (* Analyse des blocs sans modifier le deplacement courant pour la suite du programme *)
    let nt = analyse_placement_bloc t depl reg in
      let ne = analyse_placement_bloc e depl reg in
      (AstPlacement.Conditionnelle (c, nt, ne), 0)
  | AstType.TantQue (c, b) ->
    let nb = analyse_placement_bloc b depl reg in
    (AstPlacement.TantQue (c, nb), 0)
  | AstType.Retour (e, ia) ->
    begin
      match info_ast_to_info ia with
      | InfoFun(_, tr, tp) -> 
        (* Calcul de la taille des parametres pour le nettoyage de la pile *)
        (AstPlacement.Retour (e, getTaille tr, (List.fold_right (fun (t, is_ref) acc -> let taille = if is_ref then 1 else getTaille t in acc + taille) tp 0)), 0)
      | _ -> failwith "Erreur interne"
    end
  | AstType.Empty -> (AstPlacement.Empty, 0)
  | AstType.AppelProcedure (info, el) -> (AstPlacement.AppelProcedure (info, el), 0)


(**************************************************************************************)
(* analyse_placement_bloc : AstType.bloc -> int -> string -> AstPlacement.bloc * int  *)
(* Parametre li : liste d'instructions a analyser.                                    *)
(* Parametre depl : le deplacement initial dans le bloc.                              *)
(* Parametre reg : le registre courant.                                               *)
(* Parcourt les instructions en mettant a jour le deplacement au fur et a mesure      *)
(* des declarations. Renvoie le bloc place et la taille totale allouee par le bloc.   *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
and analyse_placement_bloc li depl reg =
  match li with
  | [] -> ([], 0)
  | t::q -> 
      (* Analyse de l'instruction courante *)
      let (nt, tt) = analyse_placement_instruction t depl reg in
        (* Analyse de la suite avec le deplacement mis a jour *)
        let (nq, tq) = analyse_placement_bloc q (depl + tt) reg in
        (nt::nq, tt + tq)


(**************************************************************************************)
(* analyse_placement_fonction : AstType.fonction -> AstPlacement.fonction             *)
(* Parametre : la fonction a analyser.                                                *)
(* Place les parametres (deplacement negatif par rapport a LB) et les variables       *)
(* locales (deplacement positif par rapport a LB).                                    *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyse_placement_fonction (AstType.Fonction(info, lp, li)) =
  (* Fonction auxilaire pour savoir si les parametres sont des references, donc de taille 1, ou non *)
  let param_types_refs = match info_ast_to_info info with
    | InfoFun(_, _, types) -> types
    | _ -> failwith "Erreur interne : InfoFun attendu"
  in
  (* Fonction auxiliaire pour placer les parametres en remontant depuis LB *)
  let rec placement_variables lvar ltype depl =
    match lvar, ltype with
    | [], [] -> ()
    | ia::q, (t, is_ref)::qt ->
      let taille = if is_ref then 1 else getTaille t in
          (* Calcul du deplacement : LB - taille totale parametres + offset *)
      modifier_adresse_variable (depl - taille) "LB" ia;
      placement_variables q qt (depl - taille)
    | _ -> failwith "Erreur interne"
  in 
    (* Placement des parametres *)
    let _ = placement_variables (List.rev lp) (List.rev param_types_refs) 0 in
      (* Placement du corps de la fonction : les locales commencent a LB + 3 (apres le chainage statique, etc) *)
      let nli = analyse_placement_bloc li 3 "LB" in
      AstPlacement.Fonction(info, lp, nli)
  
(**************************************************************************************)  
(* analyse_placement_enum : AstType.enum -> AstPlacement.enum                        *)
(* Parametre : l'enum a analyser.                                                    *)
(* Transforme l'enum en un enum de type AstPlacement.enum.                           *)
(**************************************************************************************)
let analyse_placement_enum (AstType.Enum(info, ids)) =
  AstPlacement.Enum(info, ids)

(**************************************************************************************)
(* analyser : AstType.programme -> AstPlacement.programme                             *)
(* Parametre : le programme a analyser.                                               *)
(* Lance le placement des fonctions et du bloc principal (sur SB).                    *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyser (AstType.Programme (enum,fonctions, prog)) =
  let ne = List.map (analyse_placement_enum) enum in
    let nf = List.map (analyse_placement_fonction) fonctions in
    (* Le bloc principal commence a l'adresse 0 du registre SB *)
      let nb = analyse_placement_bloc prog 0 "SB" in
      AstPlacement.Programme (ne, nf, nb)