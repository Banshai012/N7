with Ada.Text_IO;          use Ada.Text_IO;
with Ada.Float_Text_IO;

procedure Newton is

	Nombre:Float;  -- l'entier naturel
	Precision: Float;   -- le chiffre significatif de Entier
        Appro_p: Float;
        k:Float;
        Appro:Float;            --L'approximation du nombre
begin
        Put("Mettez le nombre que vous voulez");
        Ada.Float_Text_IO.Get(Nombre);
        Appro:=1.0;
        Appro_p:=-1000.0;
        k:=0.0;
        Precision:=0.001;
        while (Appro-Appro_p)>Precision loop
                Appro_p:=Appro;
                k:=k+1.0;
                Appro:=(Appro + Nombre/Appro)/2.0;
        end loop;
        Ada.Float_Text_IO.Put(Appro);
end Newton;
