with LCA;
-- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (LCA).
generic
	type T_Cle2 is private;
	type T_Valeur2 is private;
   Capacite: Integer;

package TH is

	type T_TH is limited private;

	-- Initialiser une Th.  La Th est de taille 11.
	procedure Initialiser2 (Th: out T_TH) with
		Post => Taille2(Th)=0;


	-- Détruire une Sda.  Elle ne devra plus être utilisée.
	procedure Detruire2 (Th : in out T_TH);


	-- Est-ce qu'une Sda est vide ?
	function Est_Vide2 (Th : in T_TH) return Boolean;


	-- Obtenir le nombre d'éléments d'une Sda. 
	function Taille2 (Th : in T_TH) return Integer with
		Post => Taille2'Result >= 0
			and (Taille2'Result = 0) = Est_Vide2 (Th);


	-- Enregistrer une valeur associée à une Clé dans une Sda.
	-- Si la clé est déjà présente dans la Sda, sa valeur est changée.
	procedure Enregistrer2 (Th : in out T_TH ; Cle : in T_Cle2 ; Valeur : in T_Valeur2; CleH : in Integer) with
		Post => Cle_Presente2 (Th, Cle, CleH) and (La_Valeur2 (Th, Cle, CleH) = Valeur)   -- valeur insérée
				and (not (Cle_Presente2 (Th, Cle, CleH)'Old) or Taille2 (Th) = Taille2 (Th)'Old)
				and (Cle_Presente2 (Th, Cle, CleH)'Old or Taille2 (Th) = Taille2 (Th)'Old + 1);

	-- Supprimer la valeur associée à une Clé dans une Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la Sda
	procedure Supprimer2 (Th : in out T_TH ; Cle : in T_Cle2; CleH : in Integer) with
		Post =>  Taille2 (Th) = Taille2 (Th)'Old - 1 -- un élément de moins
			and not Cle_Presente2 (Th, Cle, CleH);         -- la clé a été supprimée


	-- Savoir si une Clé est présente dans une Sda.
	function Cle_Presente2 (Th : in T_TH ; Cle : in T_Cle2; CleH : in Integer) return Boolean;


	-- Obtenir la valeur associée à une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans l'Sda
	function La_Valeur2 (Th : in T_TH ; Cle : in T_Cle2; CleH : in Integer) return T_Valeur2;


	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter (Cle : in T_Cle2; Valeur: in T_Valeur2);
	procedure Pour_Chaque2 (Th : in T_TH);


	-- Afficher la Sda en révélant sa structure interne.
	-- Voici un exemple d'affichage.
	-- -->["un" : 1]-->["deux" : 2]-->["trois" : 3]-->["quatre" : 4]--E
	generic
		with procedure Afficher_Cle (Cle : in T_Cle2);
		with procedure Afficher_Donnee (Valeur : in T_Valeur2);
	procedure Afficher_Debug2 (Th : in T_TH);


private

   package T_LCA2 is
      new LCA(T_Cle => T_Cle2, T_Valeur => T_Valeur2);
   use T_LCA2;

   type T_TH is array (1..Capacite) of T_LCA;

end TH;
