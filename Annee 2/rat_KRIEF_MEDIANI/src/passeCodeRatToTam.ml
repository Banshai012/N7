(* Module de la passe de generation de code TAM *)
(* doit etre conforme a l'interface Passe *)
open Tds
open Ast
open Type
open Code
open Tam

type t1 = AstPlacement.programme
type t2 = string


(**************************************************************************************)
(* get_type_affectable : AstPlacement.affectable -> Type.typ                          *)
(* Parametre a : l'affectable dont on cherche le type.                                *)
(* Fonction auxiliaire qui parcourt l'affectable (y compris les dereferencements)     *)
(* pour retrouver le type de la valeur ciblee. Necessaire pour determiner la taille   *)
(* a lire ou ecrire (via getTaille) lors de l'acces a un pointeur.                    *)
(* Erreur si l'affectable n'est pas correctement type (ex: dereferencement d'un       *)
(* non-pointeur), bien que cela devrait etre detecte par la passe de typage.          *)
(**************************************************************************************)
let rec get_type_affectable a =
  match a with
  | AstType.Ident info ->
    begin
      match info_ast_to_info info with
      | InfoVar (_,t, _, _, _) -> t
      | _ -> failwith "Erreur interne"
    end
  | AstType.Deref x ->
    match get_type_affectable x with
    | Ptr typ_ptr -> typ_ptr
    | _ -> failwith "Erreur interne"


(**************************************************************************************)
(* analyse_code_affectable_lecture : AstPlacement.affectable -> string                *)
(* Parametre a : l'affectable a analyser en lecture.                                  *)
(* Genere le code TAM pour charger la valeur d'un affectable (variable ou pointeur)   *)
(* au sommet de la pile.                                                              *)
(* Erreur si l'affectable n'est pas une variable accessible.                          *)
(**************************************************************************************)
let rec analyse_code_affectable_lecture a =
  match a with
  | AstType.Ident info -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg, false) -> (load (getTaille t) depl reg)
      | InfoVar (_, t, depl, reg, true) -> (load 1 depl reg) ^ (loadi (getTaille t))
      | _ -> failwith "Erreur interne"
    end
  | AstType.Deref x ->
    let t = get_type_affectable x in
      (analyse_code_affectable_lecture x) ^ (loadi (getTaille t))


(**************************************************************************************)
(* analyse_code_affectable_ecriture : AstPlacement.affectable -> string               *)
(* Parametre a : l'affectable a analyser en ecriture.                                 *)
(* Genere le code TAM pour stocker la valeur au sommet de la pile vers l'adresse      *)
(* de l'affectable.                                                                   *)
(* Erreur si l'affectable n'est pas une variable accessible.                          *)
(**************************************************************************************)
let analyse_code_affectable_ecriture a =
  match a with
  | AstType.Ident info -> 
    begin
      match info_ast_to_info info with
      | InfoVar (_, t, depl, reg, false) -> (store (getTaille t) depl reg)
      | InfoVar (_, t, depl, reg, true) -> (load 1 depl reg) ^ (storei (getTaille t))
      | _ -> failwith "Erreur interne"
    end
  | AstType.Deref x ->
    let t = get_type_affectable x in
      (analyse_code_affectable_lecture x) ^ (storei (getTaille t))


(**************************************************************************************)
(* analyse_code_expression : AstPlacement.expression -> string                        *)
(* Parametre e : l'expression a analyser.                                             *)
(* Genere le code TAM correspondant a l'evaluation de l'expression. Le resultat       *)
(* sera place au sommet de la pile.                                                   *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let rec analyse_code_expression e =
  match e with
  | AstType.AppelFonction (info, le) ->
    begin
      match info_ast_to_info info with
      | InfoFun(s, _, _) ->
        (* Evaluation des arguments de la gauche vers la droite puis appel *)
        (List.fold_right (fun e acc -> (analyse_code_expression e) ^ acc) le "") ^ (call "SB" (label s))
      | _ -> failwith "Erreur interne"
    end
  | AstType.Affectable a -> analyse_code_affectable_lecture a
  | AstType.Booleen b -> 
    if b
    then (loadl_int 1)
    else (loadl_int 0)
  | AstType.Entier i -> (loadl_int i)
  | AstType.Unaire (u, e2) -> (analyse_code_expression e2) ^ (if u = Numerateur then (pop 0 1) else (pop 1 1))
  | AstType.Binaire (b, e2, e3) ->
    begin
      (analyse_code_expression e2) ^ (analyse_code_expression e3) ^ (
        match b with
        | PlusInt -> subr (label "IAdd") 
        | PlusRat -> (call "SB" (label "radd")) ^ (call "SB" (label "norm"))
        | MultInt -> subr (label "IMul")
        | MultRat -> (call "SB" (label "rmul")) ^ (call "SB" (label "norm"))
        | EquInt -> subr (label "IEq")
        | EquBool -> subr (label "IEq")
        | Inf -> subr (label "ILss")
        | Fraction -> ""
        | EquTID -> subr (label "IEq")
      )
    end
  (* Arbitrairement, Null est 0. *)
  | AstType.Null -> loadl_int 0
  (* On alloue un emplacement memoire de taille getTaille t. *)
  | AstType.New t -> (loadl_int (getTaille t)) ^ (subr "MAlloc")
  | AstType.Adresse info ->
    begin
      match info_ast_to_info info with
      (* On se place a l'adresse memoire de la variable. *)
      | InfoVar (_, _, depl, reg, _) -> (loada depl reg)
      | _ -> failwith "Erreur interne"
    end
  | AstType.TIdent info ->
    begin
      match info_ast_to_info info with
      | InfoIds (_, _, pos) -> (loadl_int pos)
      | _ -> failwith "Erreur interne"
    end
  | AstType.Reference info ->
    begin
      match info_ast_to_info info with
      | InfoVar (_, _, depl, reg, is_ref) ->
        if is_ref then
          load 1 depl reg
        else
          loada depl reg
      | _ -> failwith "Erreur interne"
    end


(**************************************************************************************)
(* analyse_code_instruction : AstPlacement.instruction -> string                      *)
(* Parametre i : l'instruction a analyser.                                            *)
(* Genere le code TAM correspondant a l'execution de l'instruction (gestion de pile,  *)
(* sauts, etiquettes, appels systemes).                                               *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let rec analyse_code_instruction i =
  match i with
  | AstPlacement.Declaration (info, e) -> 
    begin
      match info_ast_to_info info with
      | InfoVar(_, t, depl, reg, _) -> 
        (* Allocation sur la pile, evaluation de l'expression, stockage *)
        (push (getTaille t)) ^ (analyse_code_expression e) ^ (store (getTaille t) depl reg)
      | _ ->  failwith "Erreur interne"
    end
  | AstPlacement.Affectation (a, e) -> (analyse_code_expression e) ^ (analyse_code_affectable_ecriture a)
  | AstPlacement.AffichageInt e -> (analyse_code_expression e) ^ (subr (label "IOut"))
  | AstPlacement.AffichageRat e -> (analyse_code_expression e) ^ (call "SB" (label "rout"))
  | AstPlacement.AffichageBool e -> (analyse_code_expression e) ^ (subr (label "BOut"))
  | AstPlacement.Conditionnelle (c, t, e) ->
    let sinon = getEtiquette () in 
      let finsi = getEtiquette () in
      (* Code : expression condition, saut si faux, bloc Then, saut fin, etiquette Sinon, bloc Else, etiquette Fin *)
      (analyse_code_expression c) ^ (jumpif 0 (label sinon)) ^ (analyse_code_bloc t) ^ (jump (label finsi)) ^ (label sinon) ^ (analyse_code_bloc e) ^ (label finsi)
  | AstPlacement.TantQue (c, b) ->
    let tantque = getEtiquette () in
      let fintantque = getEtiquette () in
      (label tantque) ^ (analyse_code_expression c) ^ (jumpif 0 (label fintantque)) ^ (analyse_code_bloc b) ^ (jump (label tantque)) ^ (label fintantque)
  | AstPlacement.Retour (e, tailleRet, tailleParam) -> (analyse_code_expression e) ^ (return tailleRet tailleParam)
  | AstPlacement.Empty -> ""
  | AstPlacement.AppelProcedure (info, le) ->
    begin
      match info_ast_to_info info with
      | InfoFun(s, _, _) ->
        (* Evaluation des arguments de la gauche vers la droite puis appel *)
        (List.fold_right (fun e acc -> (analyse_code_expression e) ^ acc) le "") ^ (call "SB" (label s))
      | _ -> failwith "Erreur interne"
    end


(**************************************************************************************)
(* analyse_code_bloc : AstPlacement.bloc -> string                                    *)
(* Parametre li : liste d'instructions a analyser avec la taille totale des locales.  *)
(* Genere le code pour toutes les instructions du bloc et nettoie la pile (pop)       *)
(* des variables locales a la fin.                                                    *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
and analyse_code_bloc (li, taille) =
  (List.fold_right(fun i acc -> (analyse_code_instruction i) ^ acc) li "") ^ (pop 0 taille)


(**************************************************************************************)
(* analyse_code_fonction : AstPlacement.fonction -> string                            *)
(* Parametre : la fonction a analyser.                                                *)
(* Genere l'etiquette de la fonction, le code de son corps, et l'instruction de fin.  *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyse_code_fonction (AstPlacement.Fonction(info, _, bloc)) =
  match info_ast_to_info info with
  | InfoFun(n, _, _) -> (label n) ^ (analyse_code_bloc bloc) ^ halt
  | _ -> failwith "Erreur interne"


(**************************************************************************************)
(* analyser : AstPlacement.programme -> string                                        *)
(* Parametre : le programme a analyser.                                               *)
(* Genere l'entete TAM, le code des fonctions, le code du main, et termine par halt.  *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyser (AstPlacement.Programme (_,fonctions, prog)) =
  getEntete() ^ (List.fold_right(fun i acc -> (analyse_code_fonction i) ^ acc) fonctions "") ^ (label "main") ^ (analyse_code_bloc prog) ^ halt