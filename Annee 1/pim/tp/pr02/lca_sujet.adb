with Ada.Text_IO;           use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with SDA_Exceptions; 		use SDA_Exceptions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with LCA;

procedure LCA_SUJET is

   package LCA_String_Integer is
		new LCA (T_Cle => Unbounded_String, T_Valeur => Integer);
	use LCA_String_Integer;

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

	-- Afficher la Sda.
	procedure Afficher is
		new Afficher_Debug (Afficher_Cle, Afficher_Donnee);
	--

	Cles : constant array (1..7) of Unbounded_String
			:= (To_Unbounded_String("un"), To_Unbounded_String("deux"), To_Unbounded_String("trois"), To_Unbounded_String("quatre"), To_Unbounded_String("cinq"), To_Unbounded_String("quatre-vingt-dix-neuf"), To_Unbounded_String("vingt-et-un"));

    Sda: T_LCA;
begin
    Initialiser (Sda);
    Enregistrer (Sda, Cles(1), 1);
    Enregistrer (Sda, Cles(2), 2);
    Afficher (Sda);
    Detruire (Sda);

end LCA_SUJET;