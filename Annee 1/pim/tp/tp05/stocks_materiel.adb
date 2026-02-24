with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;

-- Auteur: 
-- Gérer un stock de matériel informatique.
--
package body Stocks_Materiel is

    procedure Creer (Stock : out T_Stock) is
    begin
        null;
    end Creer;


    function Nb_Materiels (Stock: in T_Stock) return Integer is
    begin
        return -1;
    end;


    procedure Enregistrer (
            Stock        : in out T_Stock;
            Numero_Serie : in     Integer;
            Nature       : in     T_Nature;
            Annee_Achat  : in     Integer
        ) is
    i:Integer;
    begin
        i:=0;
        while Stock(i).numero/=0 loop
            i:=i+1;
        end loop;
        Stock(i).numero:=(Numero_Serie);
        Stock(i).nature:=(Nature);
        Stock(i).date:=(Annee_Achat);
    end;


end Stocks_Materiel;
