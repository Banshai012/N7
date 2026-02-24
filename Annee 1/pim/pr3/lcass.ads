with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
-- Définition de structures de données associatives sous forme d'une liste
-- chaînée associative (LCA).
package LCASS is

	type T_LCA is limited private;
   type T_Pile2 is limited private;

	-- Initialiser une Sda.  La Sda est vide.
	procedure Initialiser(Sda: out T_LCA) with
		Post => Est_Vide (Sda);

	-- Détruire une Sda.  Elle ne devra plus être utilisée.
	procedure Detruire (Sda : in out T_LCA);

	-- Est-ce qu'une Sda est vide ?
	function Est_Vide (Sda : in T_LCA) return Boolean;

	-- Obtenir le nombre d'éléments d'une Sda. 
	function Taille (Sda : in T_LCA) return Integer with
		Post => Taille'Result >= 0
			and (Taille'Result = 0) = Est_Vide (Sda);

	-- Enregistrer une valeur associée à une Clé dans une Sda.
	-- Si la clé est déjà présente dans la Sda, sa valeur est changée.
	procedure Enregistrer (Sda : in out T_LCA ; Cle : in Unbounded_String ; Valeur : in Unbounded_String) with
		Post => Cle_Presente (Sda, Cle) and (La_Valeur (Sda, Cle) = Valeur)   -- valeur insérée
				and (not (Cle_Presente (Sda, Cle)'Old) or Taille (Sda) = Taille (Sda)'Old)
				and (Cle_Presente (Sda, Cle)'Old or Taille (Sda) = Taille (Sda)'Old + 1);

	-- Supprimer la valeur associée à une Clé dans une Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans la Sda
	procedure Supprimer (Sda : in out T_LCA ; Cle : in Unbounded_String) with
		Post =>  Taille (Sda) = Taille (Sda)'Old - 1 -- un élément de moins
			and not Cle_Presente (Sda, Cle);         -- la clé a été supprimée

	-- Savoir si une Clé est présente dans une Sda.
	function Cle_Presente (Sda : in T_LCA ; Cle : in Unbounded_String) return Boolean;

	-- Obtenir la valeur associée à une Cle dans la Sda.
	-- Exception : Cle_Absente_Exception si Clé n'est pas utilisée dans l'Sda
	function La_Valeur (Sda : in T_LCA ; Cle : in Unbounded_String) return Unbounded_String;

	-- Appliquer un traitement (Traiter) pour chaque couple d'une Sda.
	generic
		with procedure Traiter (Cle : in Unbounded_String; Valeur: in Unbounded_String);
	procedure Pour_Chaque (Sda : in T_LCA);

	-- Afficher la Sda en révélant sa structure interne.
	-- Voici un exemple d'affichage.
	-- -->["un" : 1]-->["deux" : 2]-->["trois" : 3]-->["quatre" : 4]--E
	generic
		with procedure Afficher_Cle (Cle : in Unbounded_String);
		with procedure Afficher_Donnee (Valeur : in Unbounded_String);
	procedure Afficher_Debug (Sda : in T_LCA);

   procedure Initialiser5 (Pile : out T_Pile2);

   procedure Empiler2 (Pile : in out T_Pile2; B: in Unbounded_String);

   procedure Enregistrer2 (Pile: in out T_Pile2; Sda: in T_LCA);

   procedure Trad_Ascii (Pile: in out T_Pile2);

   procedure Position (Pile: in out T_Pile2);

   procedure Dupliquer (Pile: in out T_Pile2);

   procedure Liste (Pile : in T_Pile2; B: in out Unbounded_String);

   procedure Afficher3 (Pile : in T_Pile2);

private

	type T_Cellule;

	type T_LCA is access T_Cellule;

	type T_Cellule is
		record
			Cle: Unbounded_String;
			Valeur: Unbounded_String;
			Suivant: T_LCA;
		end record;

   type T_Cellule2;

   type T_Pile2 is access T_Cellule2;

   type T_Cellule2 is
      record
         Element: Unbounded_String;
         Suivant: T_Pile2;
      end record;

end LCASS;
