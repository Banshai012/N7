with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Integer_Text_IO;  use Ada.Integer_Text_IO;
with Ada.Float_Text_IO;    use Ada.Float_Text_IO;

procedure Puissance is

    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : L'exposant est positif.
    --
    function Puissance_Positive_Iteratif (Nombre: in Float ; Exposant : in Integer) return Float with
        pre => Exposant >= 0
    is
    begin
        return -1.0;
    end Puissance_Positive_Iteratif;


    procedure Tester_Puissance_Positive_Iteratif is
    begin
        pragma Assert (Puissance_Positive_Iteratif(5.0, 2) = 25.0);
        pragma Assert (Puissance_Positive_Iteratif(1.2, 2) = 1.44);
        pragma Assert (Puissance_Positive_Iteratif(50.3, 0) = 1.0);
        pragma Assert (Puissance_Positive_Iteratif(2.0, 3) = 8.0);
        pragma Assert (Puissance_Positive_Iteratif(-1.0, 10000) = 1.0);
        pragma Assert (Puissance_Positive_Iteratif(-1.0, 10001) = -1.0);
    end Tester_Puissance_Positive_Iteratif;


    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : TODO
    function Puissance_Iteratif (Nombre: in Float ; Exposant : in Integer) return Float with
        pre => true -- TODO corriger
    is
    begin
        return -1.0;
    end Puissance_Iteratif;


    procedure Tester_Puissance_Iteratif is
    begin
        pragma Assert (Puissance_Iteratif(5.0, 2) = 25.0);
        pragma Assert (Puissance_Iteratif(1.2, 2) = 1.44);
        pragma Assert (Puissance_Iteratif(50.3, 0) = 1.0);
        pragma Assert (Puissance_Iteratif(2.0, 3) = 8.0);
        pragma Assert (Puissance_Iteratif(4.0, -1) = 0.25);
        pragma Assert (Puissance_Iteratif(-1.0, -3) = -1.0);
        pragma Assert (Puissance_Iteratif(2.0, -3) = 0.125);
        pragma Assert (Puissance_Iteratif(-1.0, 10000) = 1.0);
        pragma Assert (Puissance_Iteratif(-1.0, 10001) = -1.0);
    end Tester_Puissance_Iteratif;



    -- Retourne Nombre à la puissance Exposant : Nombre ** Exposant (sans
    -- utiliser **).
    --
    -- Paramètres :
    --    Nombre: le nombre à élever à la puissance
    --    Exposant: l'exposant
    --
    -- Précondition : TODO
    function Puissance_Recursif (Nombre: in Float ; Exposant : in Integer) return Float with
        pre => true -- TODO corriger
    is
    begin
        return -1.0;
    end Puissance_Recursif;


    procedure Tester_Puissance_Recursif is
    begin
        pragma Assert (Puissance_Recursif(5.0, 2) = 25.0);
        pragma Assert (Puissance_Recursif(1.2, 2) = 1.44);
        pragma Assert (Puissance_Recursif(50.3, 0) = 1.0);
        pragma Assert (Puissance_Recursif(2.0, 3) = 8.0);
        pragma Assert (Puissance_Recursif(4.0, -1) = 0.25);
        pragma Assert (Puissance_Recursif(-1.0, -3) = -1.0);
        pragma Assert (Puissance_Recursif(2.0, -3) = 0.125);
        pragma Assert (Puissance_Recursif(-1.0, 10000) = 1.0);
        pragma Assert (Puissance_Recursif(-1.0, 10001) = -1.0);
    end Tester_Puissance_Recursif;




    Le_Nombre: Float;        -- le nombre lu au clavier
    L_Exposant: Integer;     -- l'exposant lu au clavier
begin
    Tester_Puissance_Positive_Iteratif;
    Tester_Puissance_Iteratif;
    Tester_Puissance_Recursif;

    -- Demander le réel
    Put ("Nombre réel : ");
    Get (Le_Nombre);

    -- Demander l'exposant
    Put ("Exposant : ");
    Get (L_Exposant);

    -- Afficher la puissance en version itérative et récusive (si possible)
    -- TODO : à corriger...
    Put ("Puissance (itérative) : ");
    Put (Puissance_Iteratif (Le_Nombre, L_Exposant), Fore => 0, Exp => 0,  Aft => 4);
    Put ("Puissance (récursive) : ");
    Put (Puissance_Recursif (Le_Nombre, L_Exposant), Fore => 0, Exp => 0,  Aft => 4);
    New_Line;

end Puissance;
