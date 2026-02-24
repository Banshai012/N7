with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Integer_Text_IO;   use Ada.Integer_Text_IO;
with LCASI; use LCASI;
with LCASS; use LCASS;

package ARBRE is
   
   type T_Arbre is limited private;
   type T_Pile is limited private;
--------------Malo-------------
   type T_Pile_Classic is limited private;
----------------------------------
   procedure Initialiser2 (Arbre : out T_Arbre) with
      Post => Est_Vide2 (Arbre);

   procedure Initialiser3 (Pile : out T_Pile) with
      Post => Est_Vide3 (Pile);

   function Est_Vide2 (Arbre : in T_Arbre) return Boolean;

   function Est_Vide3 (Pile : in T_Pile) return Boolean;

   function Sommet (Pile : in T_Pile) return T_Arbre with
      Pre => not Est_Vide3 (Pile);

   procedure Empiler (Pile : in out T_Pile; Arbre : in T_Arbre);

   procedure Initialiser4 (Pile : in out T_Pile; Taille : in Integer) with
      Pre => Taille > 0 and Est_Vide3 (Pile);

   procedure Debut (Pile: in out T_Pile; Sda : in LCASI.T_LCA);

   procedure Supprimer2 (Pile: in out T_Pile; Arbre: in T_Arbre);

   procedure Min (Pile: in out T_Pile);

   procedure Huffman (Arbre: in out T_Arbre; Sda: in LCASI.T_LCA);

   procedure Bin2 (Arbre: in T_Arbre; Sda: in out LCASS.T_LCA; B: in out Unbounded_String);

   procedure Infixe (Arbre: in T_Arbre; B: in out Unbounded_String);

   procedure AfficherArbre (Arbre: in T_Arbre; B: in Integer);

--------------Malo-----------
   procedure Initialiser5 (Pile : out T_Pile_Classic) with
      Post => Est_Vide4 (Pile);

   function Est_Vide4 (Pile : in T_Pile_Classic) return Boolean;

   function Sommet_Classic (Pile : in T_Pile_Classic) return Unbounded_String with
      Pre => not Est_Vide4 (Pile);

   procedure Empiler_Classic (Pile : in out T_Pile_Classic; Elem : in Unbounded_String);
   procedure Empiler_Memoire (Pile : in out T_Pile; Elem : in T_Arbre);
   procedure Depiler_Classic(Pile : in out T_Pile_Classic);
   procedure Depiler(Pile : in out T_Pile);
   procedure Memorisation(Arbre : in T_Arbre; Memo :out T_Arbre );
   procedure Gauche(Arbre : in out T_Arbre);
   procedure Droite(Arbre : in out T_Arbre);
   procedure Feuille(Arbre: in out T_Arbre; Elem : in Unbounded_String);
   procedure Isoler(Arbre: in T_Arbre; Indice_Lecture: in out Integer;Code : in Unbounded_String;Symbole_Observe: in out Unbounded_String);
   procedure Adroite(Arbre,Branche: in out T_Arbre);
   procedure Agauche(Arbre,Branche: in out T_Arbre);
   procedure Afficher(Arbre:in T_Arbre);

-----------------------------
private

   type T_Cellule;

   type T_Arbre is access T_Cellule;

   type T_Cellule is
      record
         Char   : Unbounded_String;
         Occ    : Integer;
         Droit  : T_Arbre;
         Gauche : T_Arbre;
      end record;

   type T_Cellule2;

   type T_Pile is access T_Cellule2;

   type T_Cellule2 is
      record
         Element : T_Arbre;
         Suivant : T_Pile;
      end record;

------------------Malo-----------------
   type T_Cellule3;
   
   type T_Pile_Classic is access T_Cellule3;
   
   type T_Cellule3 is
        record
           Element : Unbounded_String;
           Suivant : T_Pile_Classic;
      end record;
---------------------------------------

end ARBRE;
