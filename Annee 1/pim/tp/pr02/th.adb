with Ada.Text_IO;            use Ada.Text_IO;
with SDA_Exceptions;         use SDA_Exceptions;
with Ada.Unchecked_Deallocation;

package body TH is

	procedure Initialiser2(Th: out T_TH) is
	begin
      for J in 1..Capacite loop
		   T_LCA2.Initialiser(Th(J));
      end loop;
	end Initialiser2;


	procedure Detruire2 (Th : in out T_TH) is
	begin
      for J in 1..Capacite loop
         T_LCA2.Detruire(Th(J));
      end loop;
	end Detruire2;

	procedure Afficher_Debug2 (Th : in T_TH) is
            procedure AfficherD is new T_LCA2.Afficher_Debug(Afficher_Cle, Afficher_Donnee);
	begin
      for J in 1..Capacite loop
         Put(Integer'Image(J-1));
         AfficherD (Th(J));
         New_Line;
      end loop;
	end Afficher_Debug2;


	function Est_Vide2 (Th : T_TH) return Boolean is
   Indice: Boolean;
	begin
      Indice:=True;
      for J in 1..Capacite loop
         Indice:=T_LCA2.Est_Vide(Th(J));
      end loop;
      return(Indice);
	end;


	function Taille2 (Th : in T_TH) return Integer is
   S: Integer;
	begin
      S:=0;
      for J in 1..Capacite loop
         S:=S+T_LCA2.Taille(Th(J));
      end loop;
      return(S);
	end Taille2;


	procedure Enregistrer2 (Th : in out T_TH ; Cle : in T_Cle2 ; Valeur : in T_Valeur2; CleH : in Integer) is
   begin
      T_LCA2.Enregistrer(Th(CleH), Cle, Valeur);
	end Enregistrer2;


	function Cle_Presente2 (Th : in T_TH ; Cle : in T_Cle2; CleH : in Integer) return Boolean is
	begin
      return(T_LCA2.Cle_Presente(Th(CleH), Cle));
	end;


	function La_Valeur2 (Th : in T_TH ; Cle : in T_Cle2; CleH : in Integer) return T_Valeur2 is
	begin
      return(T_LCA2.La_Valeur(Th(CleH), Cle));
	end La_Valeur2;


	procedure Supprimer2 (Th : in out T_TH ; Cle : in T_Cle2; CleH : in Integer) is
	begin
      T_LCA2.Supprimer(Th(CleH), Cle);
	end Supprimer2;


	procedure Pour_Chaque2 (Th : in T_TH) is
            procedure PourChaque is new T_LCA2.Pour_Chaque(Traiter);
	begin
      for J in 1..Capacite loop
         PourChaque(Th(J));
      end loop;
	end Pour_Chaque2;


end TH;