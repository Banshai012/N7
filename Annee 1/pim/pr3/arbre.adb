with Ada.Text_IO; use Ada.Text_IO;
with Ada.Unchecked_Deallocation;

package body ARBRE is

	procedure Free2 is
		new Ada.Unchecked_Deallocation (T_Cellule, T_Arbre);

   procedure Free3 is
		new Ada.Unchecked_Deallocation (T_Cellule2, T_Pile);

   procedure Initialiser2 (Arbre : out T_Arbre) is
   begin
      Arbre:=new T_Cellule'(To_Unbounded_String(""), 0, Null, Null);
   end Initialiser2;

	procedure Initialiser3 (Pile : out T_Pile) is
	begin
		Pile := Null;
	end Initialiser3;

   function Est_Vide2 (Arbre : in T_Arbre) return Boolean is
	begin
		return Arbre = Null;
	end Est_Vide2;

   function Est_Vide3 (Pile : in T_Pile) return Boolean is
	begin
		return Pile = Null;
	end Est_Vide3;

	function Sommet (Pile : in T_Pile) return T_Arbre is
	begin
		   return Pile.all.Element;
	end Sommet;

	procedure Empiler (Pile : in out T_Pile; Arbre : in T_Arbre) is
		Nouvelle_Cellule: T_Pile;
	begin
		-- Créer une nouvelle cellule (allocation puis initialisation)
		Nouvelle_Cellule := new T_Cellule2;
		Nouvelle_Cellule.all.Element := Arbre;
		Nouvelle_Cellule.all.Suivant := Pile;

		-- Changer Pile (elle pointe sur la nouvelle cellule)
		Pile := Nouvelle_Cellule;
	end Empiler;

   procedure Initialiser4 (Pile : in out T_Pile; Taille : in Integer) is
      A : T_Arbre;
   begin
      for J in 1..Taille loop
         Initialiser2 (A);
         Empiler (Pile, A);
      end loop;
   end Initialiser4;

	procedure Debut (Pile: in out T_Pile; Sda : in LCASI.T_LCA) is
	begin
		if Pile/=Null then
			Debut(Pile.all.Suivant, LCASI.Suivant(Sda));
			Pile.all.Element.Char:=LCASI.Cle(Sda);
			Pile.all.Element.Occ:=LCASI.Valeur(Sda);
		else
			Null;
		end if;
	end Debut;

	procedure Supprimer2 (Pile: in out T_Pile; Arbre: in T_Arbre) is
		A_Detruire: T_Pile;
	begin
		if Pile=Null then
			Null;
		elsif Pile.all.Element=Arbre then
			A_Detruire:=Pile;
			Pile:=Pile.all.Suivant;
			Free2 (A_Detruire.all.Element);
			Free3 (A_Detruire);
		else
			Supprimer2 (Pile.all.Suivant, Arbre);
		end if;
	end Supprimer2;

	procedure Min (Pile: in out T_Pile) is
	C1,C2,b1,b2 : T_Pile;
	Arbre,P,P2 : T_Arbre;
	begin
	Initialiser2 (Arbre);
	Initialiser2 (P);
	Initialiser2 (P2);
	b1:=Pile;
	C1:=Pile;
	while C1/=Null loop
		if b1.all.Element.Occ>C1.all.Element.Occ then
			b1:=C1;
		end if;
		C1:=C1.all.Suivant;
	end loop;
	P.all.Char:=b1.all.Element.all.Char;
	P.all.Occ:=b1.all.Element.all.Occ;
	P.all.Gauche:=b1.all.Element.all.Gauche;
	P.all.Droit:=b1.all.Element.all.Droit;
	Arbre.all.Occ:=b1.all.Element.Occ;
	Arbre.all.Gauche:=P;

	Supprimer2 (Pile, b1.all.Element);

	b2:=Pile;
	C2:=Pile;
	while C2/=Null loop
		if b2.all.Element.Occ>C2.all.Element.Occ then
			b2:=C2;
		end if;
		C2:=C2.all.Suivant;
	end loop;

	P2.all.Char:=b2.all.Element.all.Char;
	P2.all.Occ:=b2.all.Element.all.Occ;
	P2.all.Gauche:=b2.all.Element.all.Gauche;
	P2.all.Droit:=b2.all.Element.all.Droit;
	Arbre.all.Occ:=Arbre.all.Occ+b2.all.Element.Occ;
	Arbre.all.Droit:=P2;
	Supprimer2 (Pile, b2.all.Element);
	Empiler (Pile, Arbre);
	end Min;

	procedure Huffman (Arbre: in out T_Arbre; Sda: in LCASI.T_LCA) is
		Pile: T_Pile;
	begin
		Initialiser3 (Pile);
		Initialiser4 (Pile, LCASI.Taille(Sda));
		Debut(Pile, Sda);
		while Pile.all.Suivant/=Null loop
			Min(Pile);
		end loop;
		Arbre:=Pile.all.Element;
	end Huffman;

	procedure Bin2 (Arbre: in T_Arbre; Sda: in out LCASS.T_LCA; B: in out Unbounded_String) is
	A: constant Unbounded_String:= B;
	begin
		if Arbre.all.Char=To_Unbounded_String("") then
			B:=B & "0";
			Bin2 (Arbre.all.Gauche, Sda, B);
			B:=A;
			B:=B & "1";
			Bin2 (Arbre.all.Droit, Sda, B);
		else
			LCASS.Enregistrer(Sda, Arbre.Char, B);
		end if;
	end Bin2;

	procedure Infixe (Arbre: in T_Arbre; B: in out Unbounded_String) is
	begin
		if Arbre.all.Char/=To_Unbounded_String("") then
			B:=B & "1";
		else
			B:=B & "0";
			Infixe(Arbre.all.Gauche, B);
			Infixe(Arbre.all.Droit, B);
		end if;
	end Infixe;

	procedure AfficherArbre (Arbre: in T_Arbre; B: in Integer) is
		A: Integer;
	begin
		A:=B+1;
		if Arbre.all.Char/=To_Unbounded_String("") then
         Put("(");
			Put(Arbre.all.Occ,0);
			Put(") '");
			Put(To_String(Arbre.all.Char));
         Put("'");
		else
			Put("(");
			Put(Arbre.all.Occ,0);
			Put(")");
			New_Line;
			if B/=0 then
				for J in 1..B loop
					Put("|");
					for I in 1..6 loop
						Put(" ");
					end loop;
				end loop;
			end if;
			Put("\");
			Put("--");
			Put("0");
			Put("--");
			AfficherArbre (Arbre.all.Gauche, A);
			New_Line;
			if B/=0 then
				for J in 1..B loop
					Put("|");
					for I in 1..6 loop
						Put(" ");
					end loop;
				end loop;
			end if;
			Put("\");
			Put("--");
			Put("1");
			Put("--");
			AfficherArbre (Arbre.all.Droit, A);
		end if;
	end AfficherArbre;

--------------Malo----------------------------
        procedure Initialiser5 (Pile : out T_Pile_Classic) is
        begin
                Pile := Null;
        end Initialiser5;

   		function Est_Vide4 (Pile : in T_Pile_Classic) return Boolean is
        begin
                return Pile = Null;
        end Est_Vide4;

        function Sommet_Classic (Pile : in T_Pile_Classic) return Unbounded_String is
        begin
                   return Pile.all.Element;
        end Sommet_Classic;

        procedure Empiler_Classic (Pile : in out T_Pile_Classic; Elem : in Unbounded_String) is
                Nouvelle_Cellule: T_Pile_Classic;
        begin
                -- Créer une nouvelle cellule (allocation puis initialisatio    n)
                Nouvelle_Cellule := new T_Cellule3;
                Nouvelle_Cellule.all.Element := Elem;
                Nouvelle_Cellule.all.Suivant := Pile;

                -- Changer Pile (elle pointe sur la nouvelle cellule)
                Pile := Nouvelle_Cellule;
        end Empiler_Classic;
       
       procedure Empiler_Memoire (Pile : in out T_Pile; Elem : in T_Arbre) is
                Nouvelle_Cellule: T_Pile;
                Copie: constant T_Arbre :=Elem;
        begin
                -- Créer une nouvelle cellule (allocation puis initialisatio        n)
                Nouvelle_Cellule := new T_Cellule2;
                Nouvelle_Cellule.all.Element := Copie;
                Nouvelle_Cellule.all.Suivant := Pile;

                -- Changer Pile (elle pointe sur la nouvelle cellule)
                Pile := Nouvelle_Cellule;
        end Empiler_Memoire;

        procedure Depiler_Classic(Pile : in out T_Pile_Classic) is
        begin
                Pile:=Pile.all.Suivant;
        end Depiler_Classic;
        
        procedure Depiler(Pile : in out T_Pile) is
        begin
                Pile:=Pile.all.Suivant;
        end Depiler;

        procedure Memorisation(Arbre : in T_Arbre; Memo :out T_Arbre ) is
        begin
                Memo:=Arbre;
        end Memorisation;

        procedure Gauche(Arbre : in out T_Arbre) is
        begin
                Arbre:=Arbre.all.Gauche;
        end Gauche;
        
        procedure Droite(Arbre : in out T_Arbre) is
        begin
                Arbre:=Arbre.all.Droit;
        end Droite;

        procedure Feuille(Arbre: in out T_Arbre; Elem : in Unbounded_String) is
        begin
                Arbre.all.Char := Elem;
        end Feuille;


        procedure Isoler(Arbre: in T_Arbre; Indice_Lecture: in out Integer;Code : in Unbounded_String;Symbole_Observe:in out Unbounded_String) is
        Parcours: T_Arbre;
        Bit_Courant : Character := To_String(Code)(Indice_Lecture);
        begin
                Parcours:=Arbre;

                while Parcours.all.Gauche/=Null and Parcours.all.Droit/=Null loop
                        if Bit_Courant='0' then
                                Parcours:=Parcours.all.Gauche;
                        else
                                Parcours:=Parcours.all.Droit;
                        end if;
                        Indice_Lecture:=Indice_Lecture+1;
                        Bit_Courant:=To_String(Code)(Indice_Lecture);
                end loop;
                Symbole_Observe:=Parcours.all.Char;
        end Isoler;
        
        
        procedure Adroite(Arbre,Branche: in out T_Arbre) is
        begin       
                Arbre.all.Droit:=Branche;
        end Adroite;

        procedure Agauche(Arbre,Branche: in out T_Arbre) is
        begin        
                Arbre.all.Gauche:=Branche;
        end Agauche;
        procedure Afficher(Arbre:in T_Arbre) is
        begin
                Put(To_String(Arbre.all.Char));
        end Afficher;

----------------------------------------------

end ARBRE;
