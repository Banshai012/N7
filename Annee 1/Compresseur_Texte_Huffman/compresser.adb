with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO;  use Ada.Streams.Stream_IO;
with Ada.Command_Line;       use Ada.Command_Line;
with LCASS; use LCASS;
with LCASI; use LCASI;
with ARBRE; use ARBRE;

procedure Compresser is

   type T_Octet is mod 2**8;

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
		new LCASI.Afficher_Debug (Afficher_Cle, Afficher_Donnee);
	--

   procedure Afficher_Donnee2 (Valeur : in Unbounded_String) is
   begin
      Put(Avec_Guillemets(Valeur));
   end Afficher_Donnee2;

	-- Afficher la Sda.
	procedure Afficher2 is
		new LCASS.Afficher_Debug (Afficher_Cle, Afficher_Donnee2);


   Sda     : LCASI.T_LCA;
   Binaire : LCASS.T_LCA;
   Arbre   : T_Arbre;
   File_Name : Unbounded_String; -- Nom du fichier à lire
   Full_Text, B, C, D, methode: Unbounded_String := To_Unbounded_String(""); -- Texte complet
   Ma_Chaine : String (1 .. 10000) := (others => ' ');
   PileS   : LCASS.T_Pile2;

begin
   
   if Argument_Count < 1 then
      Put_Line("Usage : ./compresser <nom_du_fichier>");
      return;
   elsif Argument_Count=1 then
      File_Name := To_Unbounded_String(Argument(Argument_Count));
   else
      methode:=To_Unbounded_String(Argument(Argument_Count-1));
      File_Name := To_Unbounded_String(Argument(Argument_Count));
   end if;

   declare
      File : Ada.Text_IO.File_Type;
      Line : String (1 .. 10000) := (others => ' '); -- Taille explicite
      Length : Natural;
   begin
      -- Ouvrir le fichier en mode lecture
      Open(File, In_File, To_String(File_Name));

      -- Lire ligne par ligne
      while not End_Of_File(File) loop
         Get_Line(File, Line, Length);
         if Length > Line'Length then
            raise Constraint_Error with "La ligne dépasse la taille maximale autorisée.";
         end if;
         Full_Text := Full_Text & Line(1 .. Length); -- Ajouter la ligne au texte complet
      end loop;

      Close(File);
   exception
      when others =>
         Put_Line("Erreur lors de l'ouverture ou de la lecture du fichier.");
   end;

   LCASI.Initialiser(Sda);
   LCASS.Initialiser(Binaire);
   Initialiser2(Arbre);

   for I in To_String(Full_Text)'Range loop
      if LCASI.Cle_Presente(Sda, To_Unbounded_String(String'(1 => To_String(Full_Text)(I)))) then
         LCASI.Enregistrer(Sda, To_Unbounded_String(String'(1 => To_String(Full_Text)(I))),
                     LCASI.La_Valeur(Sda, To_Unbounded_String(String'(1 => To_String(Full_Text)(I)))) + 1);
      else
         LCASI.Enregistrer(Sda, To_Unbounded_String(String'(1 => To_String(Full_Text)(I))), 1);
      end if;
   end loop;

   LCASI.Enregistrer(Sda, To_Unbounded_String("\$"), 0);
   
   Huffman(Arbre, Sda);

   Bin2(Arbre, Binaire, B);
   if methode/=To_Unbounded_String("-s") then
      Afficher2(Binaire);
      New_Line;
      AfficherArbre (Arbre, 0);
   end if;

   Initialiser5(PileS);
   Enregistrer2(PileS, Binaire);
   Trad_Ascii(PileS);
   Position(PileS);
   Dupliquer(PileS);
   Infixe(Arbre, C);
   Liste(PileS, D);

   declare
      F: Ada.Streams.Stream_IO.File_Type;
      S: Stream_Access;
      Taille_Octet: Integer;
      Octet: T_Octet;
      Bit: Unbounded_String := To_Unbounded_String("");
   begin
      Taille_Octet:=0;
      -- Créer un fichier en écriture
      Create(F, Out_File, To_String(File_Name & ".hff"));

      -- Écrire dans le fichier
      S := Stream(F);

      -- Ecriture des lettres dans le document
      for I in To_String(D)'Range loop
         if To_Unbounded_String(String'(1 => To_String(D)(I)))=To_Unbounded_String(",") then
            Octet:=T_Octet(Integer'Value(To_String(Bit)));
            T_Octet'Write(S, Octet);
            Bit:=To_Unbounded_String("");
         elsif To_Unbounded_String(String'(1 => To_String(D)(I)))=To_Unbounded_String(" ") then
            Null;
         else
            Bit:=Bit&To_Unbounded_String(String'(1 => To_String(D)(I)));
         end if;
      end loop;

      -- Ecriture de l'arbre infixe dans le fichier
      for I in To_String(C)'Range loop
         Bit:=To_Unbounded_String(String'(1 => To_String(C)(I)));
         if Bit=To_Unbounded_String("0") then
            Octet:=(Octet*2) or 0;
         else
            Octet:=(Octet*2) or 1;
         end if;
         Taille_Octet:=Taille_Octet+1;
         if Taille_Octet=8 then
            T_Octet'Write(S, Octet);
            Taille_Octet:=0;
         end if;
      end loop;

      -- Ecriture des codes des caractères

      for I in To_String(Full_Text)'Range loop
         Bit:=To_Unbounded_String(To_String(La_Valeur(Binaire, To_Unbounded_String(String'(1 => To_String(Full_Text)(I))))));
         for J in To_String(Bit)'Range loop
            if To_Unbounded_String(String'(1 => To_String(Bit)(J)))=To_Unbounded_String("0") then
               Octet:=(Octet*2) or 0;
            else
               Octet:=(Octet*2) or 1;
            end if;
            Taille_Octet:=Taille_Octet+1;
            if Taille_Octet=8 then
               T_Octet'Write(S, Octet);
               Taille_Octet:=0;
            end if;
         end loop;
      end loop;

      Bit:=To_Unbounded_String(To_String(La_Valeur(Binaire, To_Unbounded_String("\$"))));
      for J in To_String(Bit)'Range loop
         if To_Unbounded_String(String'(1 => To_String(Bit)(J)))=To_Unbounded_String("0") then
            Octet:=(Octet*2) or 0;
         else
            Octet:=(Octet*2) or 1;
         end if;
         Taille_Octet:=Taille_Octet+1;
         if Taille_Octet=8 then
            T_Octet'Write(S, Octet);
            Taille_Octet:=0;
         end if;
      end loop;

      if Taille_Octet/=0 then
         for I in 1..(8-Taille_Octet) loop
            Octet:=(Octet*2) or 0;
         end loop;
         T_Octet'Write(S, Octet);
      end if;

      -- Fermer le fichier
      Close(F);
      New_Line;
   end;

end Compresser;
