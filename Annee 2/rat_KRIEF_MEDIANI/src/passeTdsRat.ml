(* Module de la passe de gestion des identifiants, *)
(* doit etre conforme a l'interface Passe. *)
open Tds
open Exceptions
open Ast

(* Type d'entree de la passe. *)
type t1 = Ast.AstSyntax.programme
(* Type de sortie de la passe. *)
type t2 = Ast.AstTds.programme

(**************************************************************************************)
(* analyse_tds_affectable_lecture : tds -> AstSyntax.affectable -> AstTds.affectable  *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre a : l'affectable a analyser.                                             *)
(* Verifie la bonne utilisation d'un affectable et transforme l'affectable en une     *)
(* expression de type AstTds.affectable. Utilise lorsque l'affectable est vu en       *)
(* lecture.                                                                           *)
(* Erreur si mauvaise utilisation des identifiants                                    *)
(**************************************************************************************)
let rec analyse_tds_affectable_lecture tds a =
  match a with
  (* L'affectable est designe par son nom *)
  | AstSyntax.Ident n ->
    begin
      match Tds.chercherGlobalement tds n with
      (* L'affectable n'a pas encore ete declare. *)
      | None    -> raise (Exceptions.IdentifiantNonDeclare n)
      (* On trouve l'affectable, on peut alors lire sa valeur. *)
      | Some i  -> (AstTds.Ident i)
    end
  | AstSyntax.Deref x -> AstTds.Deref (analyse_tds_affectable_lecture tds x)


(**************************************************************************************)
(* analyse_tds_affectable_ecriture : tds -> AstSyntax.affectable -> AstTds.affectable *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre a : l'affectable a analyser.                                             *)
(* Verifie la bonne utilisation d'un affectable et transforme l'affectable en une     *)
(* expression de type AstTds.affectable. Utilise lorsque l'affectable est vu en       *)
(* ecriture.                                                                          *)
(* Erreur si mauvaise utilisation des identifiants                                    *)
(**************************************************************************************)
let rec analyse_tds_affectable_ecriture tds a =
  match a with
  | AstSyntax.Ident n ->
    begin
      match chercherGlobalement tds n with
      | None      -> raise (IdentifiantNonDeclare n)
      (* L'identifiant est trouve dans la tds globale, on recupere l'info associee. *)
      | Some info ->
        begin
          match info_ast_to_info info with
          (* On ne peut ecrire que sur des variables. *)
          | InfoVar _ -> AstTds.Ident info
          |  _        -> raise (MauvaiseUtilisationIdentifiant n)
        end
    end
  | AstSyntax.Deref x -> AstTds.Deref (analyse_tds_affectable_ecriture tds x)


(**************************************************************************************)
(* analyse_tds_expression : tds -> AstSyntax.expression -> AstTds.expression          *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre e : l'expression a analyser.                                             *)
(* Verifie la bonne utilisation des identifiants et tranforme l'expression            *)
(* en une expression de type AstTds.expression.                                       *)
(* Erreur si mauvaise utilisation des identifiants                                    *)
(**************************************************************************************)
let rec analyse_tds_expression tds e =
  match e with
  | AstSyntax.AppelFonction (s, el) -> 
    begin
      (* La fonction a t'elle deja ete declaree ? *)
      match Tds.chercherGlobalement tds s with
      | None    -> raise (Exceptions.IdentifiantNonDeclare s)
      | Some i  ->
        begin
            match Tds.info_ast_to_info i with
            (* Si c'est bien une fonction que l'on appel, on continue. *)
            | Tds.InfoFun (_, _, _) ->
              (* On analyse chaque expression dans l'appel de la fonction. *)
              let ael = List.map (analyse_tds_expression tds) el in
              AstTds.AppelFonction (i, ael)
            (* On essaie d'appeler quelque chose d'autre qu'une fonction. *)
            | _ -> raise (Exceptions.MauvaiseUtilisationIdentifiant s)
        end
    end
  | AstSyntax.Affectable a ->
    (* L'affectable est analyse. *)
    begin
      match a with
      | AstSyntax.Ident _ ->
        begin
          match analyse_tds_affectable_lecture tds a with
            | AstTds.Ident i ->
              begin
                match info_ast_to_info i with
                (* On propage les variables. *)
                | Tds.InfoVar _         -> (AstTds.Affectable (AstTds.Ident i))
                (* On transforme les constantes en expression Entier. *)
                | Tds.InfoConst (_, v)  -> (AstTds.Entier v)
                | Tds.InfoFun (n, _, _) -> raise(MauvaiseUtilisationIdentifiant n)
                | _ -> failwith "Erreur interne"
              end
            | AstTds.Deref _ -> failwith "Erreur interne"
        end
      | AstSyntax.Deref _ -> (AstTds.Affectable (analyse_tds_affectable_lecture tds a))

    end
(*
  | AstSyntax.Ident (s) ->
    begin
      match Tds.chercherGlobalement tds s with
      | None -> raise (Exceptions.IdentifiantNonDeclare s)
      | Some i ->
        begin
          match Tds.info_ast_to_info i with
          | Tds.InfoVar _         -> AstTds.Ident i
          | Tds.InfoConst (_, v)  -> AstTds.Entier v
          | Tds.InfoFun _         -> raise (Exceptions.MauvaiseUtilisationIdentifiant s)
        end
    end
*)
  | AstSyntax.Entier i            -> AstTds.Entier i
  | AstSyntax.Booleen b           -> AstTds.Booleen b
  | AstSyntax.Unaire (u, e2)      -> AstTds.Unaire (u, (analyse_tds_expression tds e2))
  | AstSyntax.Binaire (b, e2, e3) -> AstTds.Binaire (b, (analyse_tds_expression tds e2), (analyse_tds_expression tds e3))
  | AstSyntax.Null -> AstTds.Null
  | AstSyntax.New t -> AstTds.New t
  | AstSyntax.Adresse n ->
    begin
      match Tds.chercherGlobalement tds n with
      (* L'ident n'a pas encore ete declare. *)
      | None    -> raise (Exceptions.IdentifiantNonDeclare n)
      (* On trouve l'ident, on peut alors lire sa valeur. *)
      | Some i  -> AstTds.Adresse (i)
    end
  | AstSyntax.TIdent n ->
    begin
      match Tds.chercherGlobalement tds n with
      (* L'ident n'a pas encore ete declare. *)
      | None    -> raise (Exceptions.IdentifiantNonDeclare n)
      (* On trouve l'ident, on peut alors lire sa valeur. *)
      | Some i  -> AstTds.TIdent (i)
    end
  | AstSyntax.Reference n ->
    begin
      match Tds.chercherGlobalement tds n with
      (* L'ident n'a pas encore ete declare. *)
      | None    -> raise (Exceptions.IdentifiantNonDeclare n)
      (* On trouve l'ident, on peut alors lire sa valeur. *)
      | Some i  -> AstTds.Reference (i)
    end


(**************************************************************************************)
(* analyse_tds_instruction : tds -> info_ast option -> AstSyntax.instruction ->       *)
(*                           AstTds.instruction                                       *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre oia : None si l'instruction i est dans le bloc principal,                *)
(*                 Some ia, ia est l'information associee a la fonction dans          *)
(*                 laquelle est i sinon.                                              *)
(* Parametre i : l'instruction a analyser.                                            *)
(* Verifie la bonne utilisation des identifiants et tranforme l'instruction en une    *)
(* instruction de type AstTds.instruction.                                            *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let rec analyse_tds_instruction tds oia i =
  match i with
  | AstSyntax.Declaration (t, n, e) ->
    begin
      match chercherLocalement tds n with
      | None ->
          (* L'identifiant n'a donc pas ete declare dans le bloc courant. *)
          (* Verification de la bonne utilisation des identifiants dans l'expression *)
          (* et obtention de l'expression transformee *)
          let ne = analyse_tds_expression tds e in
            (* Creation de l'information associee a l'identfiant *)
            let info = InfoVar (n,Undefined, 0, "", false) in
              (* Creation du pointeur sur l'information *)
              let ia = info_to_info_ast info in
              (* Ajout de l'information (pointeur) dans la tds *)
              ajouter tds n ia;
              (* Renvoie de la nouvelle declaration ou le nom a ete remplace par l'information
              et l'expression remplacee par l'expression issue de l'analyse *)
              AstTds.Declaration (t, ia, ne)
      | Some _ -> raise (DoubleDeclaration n)
    end
  | AstSyntax.Affectation (a, e) ->
    (* On analyse l'affectable. *)
    let na = analyse_tds_affectable_ecriture tds a in
      let ne = analyse_tds_expression tds e in
        AstTds.Affectation (na, ne)
(*
  | AstSyntax.Affectation (n,e) ->
    begin
      match chercherGlobalement tds n with
      | None      -> raise (IdentifiantNonDeclare n)
      | Some info ->
        (* L'identifiant est trouve dans la tds globale,
        il a donc deja ete declare. L'information associee est recuperee. *)
        begin
          match info_ast_to_info info with
          | InfoVar _ ->
            (* Verification de la bonne utilisation des identifiants dans l'expression *)
            (* et obtention de l'expression transformee *)
            let ne = analyse_tds_expression tds e in
              (* Renvoie de la nouvelle affectation ou le nom a ete remplace par l'information
                et l'expression remplacee par l'expression issue de l'analyse *)
              AstTds.Affectation (info, ne)
          |  _ -> raise (MauvaiseUtilisationIdentifiant n)
        end
    end
*)
  | AstSyntax.Constante (n,v) ->
    begin
      match chercherLocalement tds n with
      | None ->
        (* L'identifiant n'est pas trouve dans la tds locale,
            il n'a donc pas ete declare dans le bloc courant *)
        (* Ajout dans la tds de la constante *)
        ajouter tds n (info_to_info_ast (InfoConst (n,v)));
        (* Suppression du noeud de declaration des constantes devenu inutile *)
        AstTds.Empty
      | Some _ -> raise (DoubleDeclaration n)
    end
  | AstSyntax.Affichage e ->
    (* Verification de la bonne utilisation des identifiants dans l'expression *)
    (* et obtention de l'expression transformee *)
    let ne = analyse_tds_expression tds e in
      (* Renvoie du nouvel affichage ou l'expression remplacee par l'expression issue de l'analyse *)
      AstTds.Affichage (ne)
  | AstSyntax.Conditionnelle (c,t,e) ->
    (* Analyse de la condition *)
    let nc = analyse_tds_expression tds c in
      (* Analyse du bloc then *)
      let tast = analyse_tds_bloc tds oia t in
        (* Analyse du bloc else *)
        let east = analyse_tds_bloc tds oia e in
        (* Renvoie la nouvelle structure de la conditionnelle *)
        AstTds.Conditionnelle (nc, tast, east)
  | AstSyntax.TantQue (c,b) ->
    (* Analyse de la condition *)
    let nc = analyse_tds_expression tds c in
      (* Analyse du bloc *)
      let bast = analyse_tds_bloc tds oia b in
      (* Renvoie la nouvelle structure de la boucle *)
      AstTds.TantQue (nc, bast)
  | AstSyntax.Retour (e) ->
    begin
      (* On recupere l'information associee a la fonction a laquelle le return est associee *)
      match oia with
      (* Il n'y a pas d'information -> l'instruction est dans le bloc principal : erreur *)
      | None -> raise RetourDansMain
      (* Il y a une information -> l'instruction est dans une fonction *)
      | Some ia ->
      (* Analyse de l'expression *)
      let ne = analyse_tds_expression tds e in
      AstTds.Retour (ne,ia)
    end
  | AstSyntax.AppelProcedure (s, el) ->
    begin
      (* La procedure a t'elle deja ete declaree ? *)
      match Tds.chercherGlobalement tds s with
      | None    -> raise (Exceptions.IdentifiantNonDeclare s)
      | Some i  ->
        begin
            match Tds.info_ast_to_info i with
            (* Si c'est bien une fonction que l'on appel, on continue. *)
            | Tds.InfoFun (_, _, _) ->
              (* On analyse chaque expression dans l'appel de la fonction. *)
              let ael = List.map (analyse_tds_expression tds) el in
              AstTds.AppelProcedure (i, ael)
            (* On essaie d'appeler quelque chose d'autre qu'une fonction. *)
            | _ -> raise (Exceptions.MauvaiseUtilisationIdentifiant s)
        end
    end


(**************************************************************************************)
(* analyse_tds_bloc : tds -> info_ast option -> AstSyntax.bloc -> AstTds.bloc         *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre oia : None si le bloc li est dans le programme principal,                *)
(*                 Some ia, ou ia est l'information associae a la fonction dans li.   *)
(* Parametre li : liste d'instructions a analyser.                                    *)
(* Verifie la bonne utilisation des identifiants et tranforme le bloc en un bloc de   *)
(* type AstTds.bloc.                                                                  *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
and analyse_tds_bloc tds oia li =
  (* Entree dans un nouveau bloc, donc creation d'une nouvelle tds locale
  pointant sur la table du bloc parent. *)
  let tdsbloc = creerTDSFille tds in
  (* Analyse des instructions du bloc avec la tds du nouveau bloc.
     Cette tds est modifiee par effet de bord *)
   let nli = List.map (analyse_tds_instruction tdsbloc oia) li in nli


(**************************************************************************************)
(* analyse_tds_parametre : tds -> typ -> String -> typ * info_ast                     *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre t : le type de la variable.                                              *)
(* Parametre n : le nom de la variable.                                               *)
(* Fonction auxiliaire pour ajouter a la tds courante une variable, qui retourne      *)
(* un couple type de la variable et info_ast.                                         *)
(* Erreur si double declaration d'un identifiant.                                     *)
(**************************************************************************************)
let analyse_tds_parametre tds (t, n, r) =
  match chercherLocalement tds n with
  | Some _ -> raise (Exceptions.DoubleDeclaration n)
  | None ->
    (* On creer une reference vers l'info, un info_ast. *)
    let ia = info_to_info_ast (InfoVar(n, t, 0, "", r)) in
    (* On l'ajoute a la tds donnee. *)
    ajouter tds n ia; (t, ia, r)


(**************************************************************************************)
(* analyse_tds_fonction : tds -> AstSyntax.fonction -> AstTds.fonction                *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre f : la fonction a analyser.                                              *)
(* Verifie la bonne utilisation des identifiants et tranforme la fonction             *)
(* en une fonction de type AstTds.fonction.                                           *)
(* Erreur si double declaration d'un identifiant.                                     *)
(**************************************************************************************)
let analyse_tds_fonction maintds (AstSyntax.Fonction(t,n,lp,li))  =
  match chercherGlobalement maintds n with
  | Some _ -> raise (Exceptions.DoubleDeclaration n)
  | None ->
    (* On cree une tds pour la fonction. *)
    let tdsFille = creerTDSFille maintds in
    (* On recupere la liste des types, la liste des noms et la liste des refs des variables. *)
      let lt = List.map (fun (t, _, _) -> t) lp in
      let lr = List.map (fun (_, _, r) -> r) lp in
      let ltr = List.map2 (fun t r -> (t, r)) lt lr in
      (* On transforme les informations en info_ast. *)
        let infoAst = info_to_info_ast (Tds.InfoFun(n, t, ltr)) in
        (* On analyse toutes les variables de la tds de la fonction, puis on les ajoute
        a la tds mere. *)
          let nlp = List.map (analyse_tds_parametre tdsFille) lp in
          ajouter maintds n infoAst;
          (* On analyse les instructions du bloc de la fonction. *)
            let nli = analyse_tds_bloc tdsFille (Some infoAst) li in
            AstTds.Fonction(t, infoAst, nlp, nli)


(**************************************************************************************)
(* analyse_tds_enum : tds -> AstSyntax.enum -> AstTds.enum                            *)
(* Parametre tds : la table des symboles courante.                                    *)
(* Parametre e : l'enum a analyser.                                                   *)
(* Verifie la bonne utilisation des identifiants et tranforme l'enum                  *)
(* en un enum de type AstTds.enum.                                                    *)
(* Erreur si double declaration d'un identifiant.                                     *)
(**************************************************************************************)
let analyse_tds_enum maintds (AstSyntax.Enum(n, ids)) =
  match chercherGlobalement maintds n with
  | Some _ -> raise (Exceptions.DoubleDeclaration n)
  | None ->
    let nn = info_to_info_ast (Tds.InfoEnum(n, ids)) in
      ajouter maintds n nn;
      let rec ajouter_valeurs liste_ids compteur =
        match liste_ids with
        | [] -> []
        | id :: suite ->
            let info_id = info_to_info_ast (Tds.InfoIds(id, n, compteur)) in
              ajouter maintds id info_id;
              info_id::(ajouter_valeurs suite (compteur + 1)) in
            let nids = ajouter_valeurs ids 0 in AstTds.Enum (nn, nids)

(**************************************************************************************)
(* analyser : AstSyntax.programme -> AstTds.programme                                 *)
(* Parametre : le programme a analyser.                                               *)
(* Verifie la bonne utilisation des identifiants et tranforme le programme            *)
(* en un programme de type AstTds.programme.                                          *)
(* Erreur si mauvaise utilisation des identifiants.                                   *)
(**************************************************************************************)
let analyser (AstSyntax.Programme (enum,fonctions,prog)) =
  (* Creation de la tds mere. *)
  let tds = creerTDSMere () in
  (* Analyse des enums *)
  let ne = List.map (analyse_tds_enum tds) enum in
    (* Analyse des fonctions. *)
    let nf = List.map (analyse_tds_fonction tds) fonctions in
      (* Analyse du bloc programme. *)
      let nb = analyse_tds_bloc tds None prog in
      AstTds.Programme (ne,nf,nb)
