(* Module de la passe de typage *)
(* doit etre conforme a l'interface Passe *)
open Tds
open Exceptions
open Ast
open Type

(* Type d'entree de la passe. *)
type t1 = Ast.AstTds.programme
(* Type de sortie de la passe. *)
type t2 = Ast.AstType.programme


(**************************************************************************************)
(* recuperer_type : info_ast -> typ                                                   *)
(* Parametre info : l'info dont on souhaite le type.                                  *)
(* Verifie que l'info est celle d'une variable ou d'une fonction et retourne          *)
(* le type ou le type de retour de cette derniere.                                    *)
(* Erreur si l'info n'est pas une variable ou une fonction (interne).                 *)
(**************************************************************************************)
let recuperer_type info =
  match info_ast_to_info info with
  | InfoVar(_, t, _, _, _) -> t
  | InfoFun(_, t, _)    -> t
  | InfoIds (_, n, _) -> TID n
  | _ -> failwith "Erreur interne"

(* Vérifie la compatibilité type ET mode de passage *)
let est_compatible_param (type_attendu, est_ref_attendu) (expression_recue, type_recu) =
  if not (Type.est_compatible type_attendu type_recu) then false
  else
    match expression_recue with
    | AstType.Reference _ -> est_ref_attendu (* Si j'envoie une ref, il faut que la fonction attende une ref *)
    | _ -> not est_ref_attendu (* Si j'envoie une valeur, il faut que la fonction n'attende PAS une ref *)

(**************************************************************************************)
(* analyse_type_affectable : AstTds.affectable -> AstType.affectable * typ            *)
(* Parametre a : l'affectable a analyser.                                             *)
(* Verifie que l'affectable est bien utilise et renvoie un affectable de type         *)
(* AstType.affectable, avec son type.                                                 *)
(* Erreur si on essaie de dereferencer une variable qui n'est pas un pointeur.        *)
(**************************************************************************************)
let rec analyse_type_affectable a =
  match a with
  | AstTds.Ident info -> 
      (* L'identifiant est valide, on recupere son type *)
      (AstType.Ident info, recuperer_type info)
  | AstTds.Deref x -> 
      let (na, ta) = analyse_type_affectable x in
      begin
        match ta with
        | Ptr t -> (AstType.Deref na, t) (* On recupere le type pointe. *)
        | _ -> raise (TypeInattendu (ta, Ptr Undefined)) (* On attendait un pointeur. *)
      end

(**************************************************************************************)
(* analyse_type_expression : AstTds.expression -> AstType.expression * typ            *)
(* Parametre e : l'expression a analyser.                                             *)
(* Verifie le bon typage des expressions et tranforme l'expression en une expression  *)
(* de type AstType.expression.                                                        *)
(* Erreur si incompatibilite de types dans les operations ou appels de fonctions.     *)
(**************************************************************************************)
let rec analyse_type_expression e =
  match e with
  | AstTds.AppelFonction (info, el) -> 
    begin
      let l = List.map analyse_type_expression el in
        let (lne, lte) = List.split l in
          match info_ast_to_info info with
          | InfoFun(_, tr, ltp) ->
            let ltpp = List.map (fun (t, _) -> t) ltp in
            (* Verification de la compatibilite des types des parametres *)
            if ((List.length ltp = List.length lne) && (List.for_all2 est_compatible_param ltp l))
            then (AstType.AppelFonction (info, lne), tr)
            else raise (Exceptions.TypesParametresInattendus (lte, ltpp))
          | _ -> failwith "Erreur interne"
    end
  | AstTds.Affectable a ->
    let (na, ta) = analyse_type_affectable a in
    (AstType.Affectable na, ta)
(*
  | AstTds.Ident info -> (AstType.Ident info, recuperer_type info)
*)
  | AstTds.Booleen b -> (AstType.Booleen b, Bool)
  | AstTds.Entier i -> (AstType.Entier i, Int)
  | AstTds.Unaire (u, e2) ->
    let (n, t) = analyse_type_expression e2 in
      if (est_compatible t Rat)
      then
        begin
          match u with
          | AstSyntax.Numerateur -> (AstType.Unaire (AstType.Numerateur, n), Int)
          | AstSyntax.Denominateur -> (AstType.Unaire (AstType.Denominateur, n), Int)
        end
      else raise (TypeInattendu (t, Rat))
  | AstTds.Binaire (op, e2, e3) ->
    begin
      let (ne2, te2) = analyse_type_expression e2 in
        let (ne3, te3) = analyse_type_expression e3 in
          match (op, te2, te3) with
          | (Plus, Int, Int) -> (AstType.Binaire (PlusInt, ne2, ne3), Int)
          | (Plus, Rat, Rat) -> (AstType.Binaire (PlusRat, ne2, ne3), Rat)
          | (Mult, Int, Int) -> (AstType.Binaire (MultInt, ne2, ne3), Int)
          | (Mult, Rat, Rat) -> (AstType.Binaire (MultRat, ne2, ne3), Rat)
          | (Equ, Int, Int) -> (AstType.Binaire (EquInt, ne2, ne3), Bool)
          | (Equ, Bool, Bool) -> (AstType.Binaire (EquBool, ne2, ne3), Bool)
          | (Inf, Int, Int) -> (AstType.Binaire (Inf, ne2, ne3), Bool)
          | (Fraction, Int, Int) -> (AstType.Binaire (Fraction, ne2, ne3), Rat)
          | (Equ, TID(n1), TID(n2)) when n1 = n2 -> (AstType.Binaire (EquTID, ne2, ne3), Bool)
          | _ -> raise (TypeBinaireInattendu (op, te2, te3))
    end
  (* Null n'etant pas un type, la convention de representation sera un pointeur undefined *)
  | AstTds.Null -> (AstType.Null, Ptr Undefined)
  | AstTds.New t -> 
    begin
      match t with
      | Int | Rat | Ptr _ -> (AstType.New t, Ptr(t))
      | _ -> raise (TypeInconnu t)
    end
  | AstTds.Adresse info -> (AstType.Adresse info, Ptr(recuperer_type info))
  | AstTds.TIdent info -> (AstType.TIdent info, recuperer_type info)
  | AstTds.Reference info -> (AstType.Reference info, (recuperer_type info))


(**************************************************************************************)
(* analyse_type_instruction : AstTds.instruction -> AstType.instruction               *)
(* Parametre i : l'instruction a analyser.                                            *)
(* Verifie la bonne utilisation des identifiants et tranforme l'instruction           *)
(* en une instruction de type AstType.instruction.                                    *)
(* Erreur si incompatibilite de type dans les affectations, conditions ou retours.    *)
(**************************************************************************************)
let rec analyse_type_instruction i =
  match i with
  | AstTds.Declaration (t, info, e) ->
    let (ne, te) = analyse_type_expression e in
      if (est_compatible te t) then
        begin
          modifier_type_variable te info;
          AstType.Declaration (info, ne)
        end
      else raise (TypeInattendu (te, t))
  | AstTds.Affectation (a, e) ->
    let (na, ta) = analyse_type_affectable a in
      let (ne, te) = analyse_type_expression e in
        if (est_compatible ta te)
        then AstType.Affectation (na, ne)
        else raise (TypeInattendu (te, ta))
  | AstTds.Affichage e ->
    begin
      let (ne, te) = analyse_type_expression e in
        match te with
        | Int -> AffichageInt ne
        | Rat -> AffichageRat ne
        | Bool -> AffichageBool ne
        | _ -> failwith "Erreur interne"
    end
  | AstTds.Conditionnelle (c, t, e) ->
    let (nc, tc) = analyse_type_expression c in
      let nt = analyse_type_bloc t in
        let ne = analyse_type_bloc e in
          if (est_compatible tc Bool)
          then AstType.Conditionnelle (nc, nt, ne)
          else raise (TypeInattendu (tc, Bool))
  | AstTds.TantQue (c, b) ->
    let (nc, tc) = analyse_type_expression c in
      let nb = analyse_type_bloc b in
        if (est_compatible tc Bool)
        then AstType.TantQue (nc, nb)
        else raise (TypeInattendu (tc, Bool))
  | AstTds.Retour (e, ia) ->
    let (ne, te) = analyse_type_expression e in
      let t = recuperer_type ia in
        if ((est_compatible t te) || (t = Void && te = Ptr Undefined))
        then AstType.Retour (ne, ia)
        else raise (TypeInattendu (te, t))
  | AstTds.Empty -> AstType.Empty
  | AstTds.AppelProcedure (info, el) -> 
    begin
      let l = List.map analyse_type_expression el in
        let (lne, lte) = List.split l in
          match info_ast_to_info info with
          | InfoFun(_, tr, ltp) ->
            let ltpp = List.map (fun (t, _) -> t) ltp in
            (* Verification de la compatibilite des types des parametres et la procedure est bien une procedure. *)
            if (((List.length ltp = List.length lne) && (List.for_all2 est_compatible_param ltp l)) && (est_compatible tr Void))
            then (AstType.AppelProcedure (info, lne))
            else raise (Exceptions.TypesParametresInattendus (lte, ltpp))
          | _ -> failwith "Erreur interne"
    end


(**************************************************************************************)
(* analyse_type_bloc : AstTds.bloc -> AstType.bloc                                    *)
(* Parametre li : liste d'instructions a analyser.                                    *)
(* Verifie la bonne utilisation des identifiants et tranforme le bloc en un bloc      *)
(* de type AstType.bloc.                                                              *)
(* Erreur si mauvaise utilisation des identifiants dans le bloc.                      *)
(**************************************************************************************)
and analyse_type_bloc li =
  List.map analyse_type_instruction li


(**************************************************************************************)
(* analyse_type_fonction : AstTds.fonction -> AstType.fonction                        *)
(* Parametre : la fonction a analyser.                                                *)
(* Verifie la bonne utilisation des identifiants et tranforme la fonction             *)
(* en une fonction de type AstType.fonction.                                          *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyse_type_fonction (AstTds.Fonction(_, info, lp, li)) =
  let nli = analyse_type_bloc li in
    let nlpi = List.map (fun (_, ia, _) -> ia) lp in
    AstType.Fonction(info, nlpi, nli)
  
(**************************************************************************************)
(* analyse_type_enum : AstTds.enum -> AstType.enum                                    *)
(* Parametre e : l'enum a analyser.                                                   *)
(* Verifie la bonne utilisation des identifiants et tranforme l'enum                  *)
(* en un enum de type AstType.enum.                                                   *)
(* Erreur si double declaration d'un identifiant.                                     *)
(**************************************************************************************)
let analyse_type_enum (AstTds.Enum(info, ids)) =
  AstType.Enum(info, ids)

(**************************************************************************************)
(* analyser : AstTds.programme -> AstType.programme                                   *)
(* Parametre : le programme a analyser.                                               *)
(* Verifie la bonne utilisation des identifiants et tranforme le programme            *)
(* en un programme de type AstType.programme.                                         *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyser (AstTds.Programme (enum,fonctions,prog)) =
  let ne = List.map (analyse_type_enum) enum in
    let nf = List.map (analyse_type_fonction) fonctions in
      let nb = analyse_type_bloc prog in
      AstType.Programme (ne, nf, nb)