with Ada.Text_IO;            use Ada.Text_IO;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
with Ada.Streams.Stream_IO;  use Ada.Streams.Stream_IO;
with Ada.Command_Line;       use Ada.Command_Line;
with LCASS; use LCASS;
with LCASI; use LCASI;
with ARBRE; use ARBRE;


procedure Decompresser is

        type T_Octet is mod 2 ** 8;	-- sur 8 bits
	for T_Octet'Size use 8;
        S         : Stream_Access;
	Octet,Bit     : T_Octet;
        Nom_Fichier,Present,Precedent, Extension, Full_Text,Code,Structure, Symbole_Observe,Texte:Unbounded_String;
        Longueur,Compteur,Index, Position_Fin,c,Indice_Lecture,NBsymbole:Integer;
        Fichier_hff:Ada.Streams.Stream_IO.File_Type; 
        Fichier_d : Ada.Text_IO.File_Type;
        Stockage: T_Pile_Classic;
        type Tableau is array (1 .. 256) of Character;
        Symbole,Symbole0 : Tableau:= (others => ' ');
        Arbre: T_Arbre;
        Indice_symbole,Indice_structure:Integer:=1;


        procedure Traduction(Binaire:in out Unbounded_String) is
        Size:Integer:=To_String(Binaire)'Length;
        Nombre:Integer:=0;
        begin
               for i in 1..Size loop
                       if To_String(Binaire)(i)='1' then
                                Nombre:=Nombre+2**(Size-i);
                        end if;
               end loop;
               Binaire:=To_Unbounded_String(Integer'Image(Nombre));
       end Traduction;                  
       

        procedure Dev_Arbre(Arbre : in out T_Arbre;Structure:in Unbounded_String;Symbole:in Tableau;Indice_symbole,Indice_structure:in out Integer) is
        ArbreG,ArbreD:T_Arbre;
        begin
                if To_String(Structure)(Indice_structure)='0' then
                        Initialiser2(ArbreG);
                        Indice_structure:=Indice_structure+1;
                        Dev_Arbre(ArbreG,Structure,Symbole,Indice_symbole,Indice_structure);
                        Initialiser2(ArbreD);
                        Indice_structure:=Indice_structure+1;
                        Dev_Arbre(ArbreD,Structure,Symbole,Indice_symbole,Indice_structure);
                        Agauche(Arbre,ArbreG);
                        Adroite(Arbre,ArbreD);
                else
                        Feuille(Arbre,To_Unbounded_String(Symbole(Indice_symbole)'Image));
                        Indice_symbole:=Indice_symbole+1;
                end if;

        
        end Dev_Arbre;

       
begin
        If Argument_Count>0 then
                Nom_Fichier := To_Unbounded_String(Ada.Command_Line.Argument(1));
                Longueur:= To_String(Nom_Fichier)'Length;
	        Extension := To_Unbounded_String(To_String(Nom_Fichier)(Longueur-3 .. Longueur));
	        Nom_Fichier:= To_Unbounded_String(To_String(Nom_Fichier)(1..Longueur-4));
	        If To_String(Extension) = ".hff" then
                        --Création ou Ouverture du fichier        
                        Ada.Text_IO.Create (Fichier_d, Ada.Text_IO.Out_File, To_String(Nom_Fichier&".hff.d"));
                        --Récolte des informations
                        Open (Fichier_hff, In_File, To_String(Nom_Fichier)&".hff" );
                        
                        S := Stream(Fichier_hff);
	                while not End_Of_File(Fichier_hff) loop
		                Octet := T_Octet'Input(S);
                                for N in 1..8 loop
		                        Bit := Octet / 128;
                                        Full_Text:=Full_Text&Integer'Image(Integer(Bit));
		                        Octet := Octet * 2;
	                        end loop;

	                end loop;

	                Compteur := 2;
                        Index :=0;
                        Initialiser5(Stockage);
                        Present:=To_Unbounded_String(" ");
	                --Récolter les symboles
                        while To_String(Present)/=To_String(Precedent) loop
                                Precedent:=Present;
                                Present:=To_Unbounded_String("");
                                for i in 1..8 loop
                                        Present:=Present&To_String(Full_Text)(Compteur);
                                        Compteur:=Compteur+2;
                                end loop;
                                Traduction(Present);

                                Empiler_Classic(Stockage,Present);
                                Index:=Index+1;
                        end loop;


                        --Remplir Symbole
	                for i in  1 .. Index-1 loop 
		                Symbole0(Index-i):=Character'Val(Integer'Value(To_String(Sommet_Classic(Stockage))));
                                Depiler_Classic(Stockage);
	                end loop;
                       Position_Fin:=Integer'Value(To_String(Sommet_Classic(Stockage)))+1;
                        --Mise en ordre de symbole
                        c:=0;
                        for i in 1..Index-1 loop
                                if i=Position_Fin then
                                        Symbole(i):=('$');
                                        Symbole(i+1):=Symbole0(i);
                                        c:=1;
                                else
                                        Symbole(i+c):=Symbole0(i);
                                end if;
                        end loop;


                        --Récolter la structure de l'arbre
                        NBsymbole:=0;
	                while NBsymbole<Index-1 loop
                                if To_String(Full_Text)(Compteur)='1' then
                                        NBsymbole:=NBsymbole+1;
                                end if;
		                Structure := Structure&To_String(Full_Text)(Compteur);
		                Compteur := Compteur+2;
                        end loop;

                        --Récolter le code
                        while Compteur< To_String(Full_Text)'Length+1 loop
		                Code := Code&To_String(Full_Text)(Compteur);
		                Compteur := Compteur+2;
                        end loop;
                        --Traitement de la fin du fichier

                        Initialiser2(Arbre);
                        Dev_Arbre(Arbre,Structure,Symbole,Indice_symbole,Indice_structure);

                        AfficherArbre(Arbre,0);
                        new_Line;
                        Indice_Lecture:=1;
                        while To_String(Symbole_Observe)/="'$'" loop
                                Isoler(Arbre,Indice_Lecture,Code,Symbole_Observe);
                                if To_String(Symbole_Observe)/="'$'" then
                                   Texte:=Texte&To_String(Symbole_Observe)(2);
                                end if;
                         end loop;
                         Put(Fichier_d, To_String(Texte));
                         Close(Fichier_d);
                                
                Else
                        Put("Le fichier donné n'a pas la bonne extension");
                end if;

        End if;        
end Decompresser;
