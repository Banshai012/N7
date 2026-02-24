with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCA is

	procedure Free is
		new Ada.Unchecked_Deallocation (T_Cellule, T_LCA);


	procedure Initialiser(Sda: out T_LCA) is
	begin
		Sda:=Null;
	end Initialiser;


	procedure Detruire (Sda : in out T_LCA) is
	begin
		if Sda /= Null then
			Detruire (Sda.all.Suivant);
			Free (Sda);
		else
			Null;
		end if;
	end Detruire;


	procedure Afficher_Debug (Sda : in T_LCA) is
	begin
		if Sda = Null then
			Put ("--E");
		else
			Put ("-->[");
			Afficher_Cle (Sda.all.Cle);
			Put(":");
			Afficher_Donnee (Sda.all.Valeur);
			Put ("]");
			Afficher_Debug (Sda.all.Suivant);
		end if;
	end Afficher_Debug;


	function Est_Vide (Sda : T_LCA) return Boolean is
	begin
		return Sda = Null;
	end;


	function Taille (Sda : in T_LCA) return Integer is
	begin
	if Sda = null then
		return 0;
	else
		return 1 + Taille (Sda.all.Suivant);
	end if;
	end Taille;


	procedure Enregistrer (Sda : in out T_LCA ; Cle : in T_Cle ; Valeur : in T_Valeur) is
	Nouvelle_Cellule: T_LCA;
	begin
	if Sda = Null then
		-- Créer une nouvelle cellule (allcoation puis initialisation)
		Nouvelle_Cellule := new T_Cellule;
		Nouvelle_Cellule.all.Cle := Cle;
		Nouvelle_Cellule.all.Valeur := Valeur;
		Nouvelle_Cellule.all.Suivant := Sda ;

		-- Changer Sda (elle pointe sur la nouvelle cellule)
		Sda := Nouvelle_Cellule;
	elsif Sda.all.Cle = Cle then
		Sda.all.Valeur := Valeur;
	else
		Enregistrer (Sda.all.Suivant, Cle, Valeur);
	end if;
	end Enregistrer;


	function Cle_Presente (Sda : in T_LCA ; Cle : in T_Cle) return Boolean is
	begin
		if Sda = Null then
			return(False);
		elsif Sda.all.Cle = Cle then
			return(True);
		else
			return Cle_Presente(Sda.all.Suivant, Cle);
		end if;
	end;


	function La_Valeur (Sda : in T_LCA ; Cle : in T_Cle) return T_Valeur is
	begin
		if Sda = null then
			raise Cle_Absente_Exception;
		elsif Sda.all.Cle = Cle then
			return(Sda.all.Valeur);
		else
			return La_Valeur(Sda.all.Suivant, Cle);
		end if;
	end La_Valeur;


	procedure Supprimer (Sda : in out T_LCA ; Cle : in T_Cle) is
		A_Detruire: T_LCA;
	begin
		if Sda = null then
			raise Cle_Absente_Exception;
		elsif Sda.all.Cle = Cle then
			A_Detruire:=Sda;
			Sda:=Sda.all.Suivant;
			Free(A_Detruire);
		else
			Supprimer(Sda.all.Suivant, Cle);
		end if;
	end Supprimer;


	procedure Pour_Chaque (Sda : in T_LCA) is
	begin
		if Sda = null then
			null;
		else
			begin
				Traiter(Sda.all.Cle, Sda.all.Valeur);
				Pour_Chaque(Sda.all.Suivant);
			exception
				when others => null;
			end;
		end if;
	end Pour_Chaque;


end LCA;
