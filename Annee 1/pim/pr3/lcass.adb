with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body LCASS is

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
         Null;
		else
			Put ("'");
			Afficher_Cle (Sda.all.Cle);
			Put("' --> ");
			Afficher_Donnee (Sda.all.Valeur);
         New_Line;
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


	procedure Enregistrer (Sda : in out T_LCA ; Cle : in Unbounded_String ; Valeur : in Unbounded_String) is
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


	function Cle_Presente (Sda : in T_LCA ; Cle : in Unbounded_String) return Boolean is
	begin
		if Sda = Null then
			return(False);
		elsif Sda.all.Cle = Cle then
			return(True);
		else
			return Cle_Presente(Sda.all.Suivant, Cle);
		end if;
	end;


	function La_Valeur (Sda : in T_LCA ; Cle : in Unbounded_String) return Unbounded_String is
	begin
		if Sda = null then
			raise Cle_Absente_Exception;
		elsif Sda.all.Cle = Cle then
			return(Sda.all.Valeur);
		else
			return La_Valeur(Sda.all.Suivant, Cle);
		end if;
	end La_Valeur;


	procedure Supprimer (Sda : in out T_LCA ; Cle : in Unbounded_String) is
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

   procedure Free4 is
		new Ada.Unchecked_Deallocation (T_Cellule2, T_Pile2);

	procedure Initialiser5 (Pile : out T_Pile2) is
	begin
		Pile := Null;
	end Initialiser5;

	procedure Empiler2 (Pile : in out T_Pile2; B : in Unbounded_String) is
		Nouvelle_Cellule: T_Pile2;
	begin
		-- Créer une nouvelle cellule (allocation puis initialisation)
		Nouvelle_Cellule := new T_Cellule2;
		Nouvelle_Cellule.all.Element := B;
		Nouvelle_Cellule.all.Suivant := Pile;

		-- Changer Pile (elle pointe sur la nouvelle cellule)
		Pile := Nouvelle_Cellule;
	end Empiler2;

   procedure Enregistrer2 (Pile: in out T_Pile2; Sda: in T_LCA) is
   begin
      if Sda.all.Suivant/=Null then
         Enregistrer2 (Pile, Sda.all.Suivant);
      else
         Null;
      end if;
      Empiler2 (Pile, Sda.all.Cle);
   end Enregistrer2;

   procedure Trad_Ascii (Pile: in out T_Pile2) is
   begin
      if Pile/=Null then
         if Pile.all.Element/=To_Unbounded_String("\$") then
            Pile.all.Element:=To_Unbounded_String(Integer'Image(Character'Pos(To_String(Pile.all.Element)(1))));
         else
            Pile.all.Element:=To_Unbounded_String("-1");
         end if;
         Trad_Ascii (Pile.all.Suivant);
      else
         Null;
      end if;
   end Trad_Ascii;

   procedure Position (Pile: in out T_Pile2) is
      C, P: T_Pile2;
      I: Integer;
   begin
      I:=0;
      C:=Pile;
      if Pile.all.Element=To_Unbounded_String("-1") then
         Pile:=Pile.all.Suivant;
      else
         while C.all.Element/=To_Unbounded_String("-1") loop
            I:=I+1;
            P:=C;
            C:=C.all.Suivant;
         end loop;
         P.all.Suivant:=C.all.Suivant;
      end if;
      Free4 (C);
      Empiler2 (Pile, To_Unbounded_String(Integer'Image(I)));
   end Position;

   procedure Dupliquer (Pile: in out T_Pile2) is
      
   begin
      if Pile.all.Suivant/=Null then
         Dupliquer (Pile.all.Suivant);
      else
         Empiler2 (Pile, Pile.all.Element);
      end if;
   end Dupliquer;

	procedure Liste (Pile : in T_Pile2; B: in out Unbounded_String) is

		-- Afficher les éléments de la pile. Le premier affiché est le fond de
		-- pile, le dernier le sommet, ils sont séparés par des virgules.
		procedure Liste_Elements (Pile : in T_Pile2; B: in out Unbounded_String) is
		begin
			if Pile = Null then
				Null;
			elsif Pile.all.Suivant = Null then
				B:=B&To_String (Pile.all.Element);
			else 
            B:=B&To_String (Pile.all.Element);
            B:=B&",";
				Liste_Elements (Pile.all.Suivant, B);
			end if;
		end Liste_Elements;
	begin
		Liste_Elements (Pile, B);
      B:=B&",";
	end Liste;

	procedure Afficher3 (Pile : in T_Pile2) is

		-- Afficher les éléments de la pile. Le premier affiché est le fond de
		-- pile, le dernier le sommet, ils sont séparés par des virgules.
		procedure Afficher_Elements (Pile : in T_Pile2) is
		begin
			if Pile = Null then
				Null;
			elsif Pile.all.Suivant = Null then
				Put(To_String (Pile.all.Element));
			else 
            Put(To_String (Pile.all.Element));
            Put (",");
				Afficher_Elements (Pile.all.Suivant);
			end if;
		end Afficher_Elements;

	begin
		Put ('[');
		Afficher_Elements (Pile);
		Put (']');
	end Afficher3;

end LCASS;
