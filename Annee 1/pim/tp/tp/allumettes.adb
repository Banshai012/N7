with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Alea;

--------------------------------------------------------------------------------
--  Auteur   : Benjamin Krief
--  Objectif : Jeu des 13 Allumettes
--------------------------------------------------------------------------------

procedure Allumettes is

        package Alea_1_3 is
                new Alea (1, 3);
	use Alea_1_3;
        
        Level: String:="a";
        Starter: String:="a";
        Grid: Integer;
        Number: Integer;

begin

        Put("Niveau de l'ordinateur (n)aif, (d)istrait, (r)apide ou (e)xpert ? "); --obtenir niveau ordinateur
        Get(Level);
        Skip_Line;
        case Level(1) is
                when 'N'|'n' => Put_Line("Mon niveau est naif");
                when 'D'|'d' => Put_Line("Mon niveau est distrait");
                when 'R'|'r' => Put_Line("Mon niveau est rapide");
                when others => Put_Line("Mon niveau est expert");
        end case;

        Put("Est-ce que vous commencez (o/n) ? "); --obtenir qui commence
        Get(Starter);
        Skip_Line;

        Grid:=13;

        while Grid>0 loop
                for I in 1..3 loop --affichage du nombre d'allumettes
                        for J in 1..Grid loop
                                Put("| ");
                                if J mod 5 = 0 then
                                        Put("  ");
                                end if;
                        end loop;
                        Put_Line("");
                end loop;
                if Starter="O" or Starter="o" then
                        Put("Combien d'allumettes prenez-vous ? ");
                        Get(Number);
                        Skip_Line;
                        while not(Number<=Grid and Number<=3 and Number>=1) loop --cas où le joueur veut tricher
                                if Number>Grid then 
                                        Put("Arbitre : Il reste seulement ");
                                        Put(Grid,1);
                                        Put_Line(" allumettes.");
                                        Put("Combien d'allumettes prenez-vous ? ");
                                        Get(Number);
                                        Skip_Line;
                                elsif Number>3 then
                                        Put_Line("Arbitre : Il est interdit de prendre plus de 3 allumettes.");
                                        Put("Combien d'allumettes prenez-vous ? ");
                                        Get(Number);
                                        Skip_Line;
                                else
                                        Put_Line("Arbitre : Il faut prendre au moins une allumette.");
                                        Put("Combien d'allumettes prenez-vous ? ");
                                        Get(Number);
                                        Skip_Line;
                                end if;
                        end loop;
                        Starter:="n"; --on changer l'indicateur de tour
                else
                        case Level(1) is --action en fonction du niveau du robot
                                when 'N'|'n' => 
                                        if Grid>2 then --il n'y a aucun problème dans ce cas
                                                Get_Random_Number(Number);
                                        else
                                                Number:=3;
                                                while Number>Grid loop --l'ordinateur est censé savoir combien d'allumettes il y a. Je n'ai aucun moyen de changer la fonction random en cours de route, je suis contraint de créer un while.
                                                        Get_Random_Number(Number);
                                                end loop;
                                        end if;
                                when 'D'|'d' =>
                                        Get_Random_Number(Number);
                                        while Number > Grid loop
                                                Put("Je prends ");
                                                Put(Number,1);
                                                Put_Line(" allumettes.");
                                                Put("Arbitre : Il reste seulement ");
                                                Put(Grid,1);
                                                Put_Line(" allumettes.");
                                                Get_Random_Number(Number);
                                        end loop;
                                when 'R'|'r' =>
                                        if Grid > 2 then
                                                Number:=3;
                                        else
                                                Number:=Grid;
                                        end if;
                                when others =>
                                        if Grid /= 1 then
                                                if Grid mod 4 = 1 then
                                                        Get_Random_Number(Number);
                                                else
                                                        Number:=1;
                                                        while (Grid-Number) mod 4 /= 1 loop
                                                                Number:=Number+1;
                                                        end loop;
                                                end if;
                                        else
                                                Number:=1;
                                        end if;
                        end case;
                        Starter:="o";
                        Put("Je prends ");
                        Put(Number,1);
                        Put_Line(" allumettes.");
                end if;
                Grid:=Grid-Number;
        end loop;                                 

        if Starter="o" then
                Put("Vous avez gagné");
        else
                Put("J'ai gagné.");
        end if;

end Allumettes;