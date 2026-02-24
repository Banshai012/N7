with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with TH;

procedure TH_SUJET is

   package TH_String_Integer is
		new TH (T_Cle2 => Unbounded_String, T_Valeur2 => Integer, Capacite => 11);
	use TH_String_Integer;

	-- Retourner une chaîne avec des guillemets autour de S
	function Avec_Guillemets (S: Unbounded_String) return String is
	begin
		return '"' & To_String (S) & '"';
	end;

   procedure Afficher_Cle (Cle : in Unbounded_String) is
   begin
      Put(Avec_Guillemets(Cle));
   end Afficher_Cle;

   procedure Afficher_Donnee (Valeur : in Integer) is
   begin
      Put(Valeur, 1);
   end Afficher_Donnee;

	-- Afficher la Th.
	procedure Afficher is
		new Afficher_Debug2 (Afficher_Cle, Afficher_Donnee);
	--

	Cles : constant array (1..7) of Unbounded_String
			:= (To_Unbounded_String("un"), To_Unbounded_String("deux"), To_Unbounded_String("trois"), To_Unbounded_String("quatre"), To_Unbounded_String("cinq"), To_Unbounded_String("quatre-vingt-dix-neuf"), To_Unbounded_String("vingt-et-un"));

    Th: T_TH;
    a: Integer;
begin
   Initialiser2 (Th);
   for J in 1..7 loop
      a:=(length(Cles(J)) mod 11 ) + 1;
      Enregistrer2 (Th, Cles(J), J, (length(Cles(J)) mod 11 ) + 1);
   end loop;
   Afficher (Th);
   Detruire2 (Th);

end TH_SUJET;