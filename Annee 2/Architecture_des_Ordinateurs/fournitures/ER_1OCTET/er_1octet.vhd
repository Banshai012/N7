library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity er_1octet is
  port ( rst : in std_logic ;
         clk : in std_logic ;
         en : in std_logic ;
         din : in std_logic_vector (7 downto 0) ;
         miso : in std_logic ;
         sclk : out std_logic ;
         mosi : out std_logic ;
         dout : out std_logic_vector (7 downto 0) ;
         busy : out std_logic);
end er_1octet;

architecture behavioral_3 of er_1octet is

    type t_etat is (repos, reception, envoi);
    signal etat : t_etat;

begin

  process(clk, rst)
    variable cpt : natural;
    variable registre : std_logic_vector(7 downto 0);

    begin
    
      if(rst = '0') then

        sclk <= '1';
        mosi <= 'U';
        dout <= (others => 'U');
        busy <= '0';
        cpt := 0;
        registre := (others => 'U');
        etat <= repos;

      elsif(rising_edge(clk)) then
      
        case etat is
          when repos =>
            if (en = '1') then
              busy <= '1';
              sclk <= '0';
              cpt := 7;
              registre := din;
              mosi <= registre(cpt);
              etat <= reception;
            end if;
          when reception =>
            if (cpt = 0) then
              busy <= '0';
              sclk <= '1';
              registre(cpt) := miso;
              dout <= registre;
              etat <= repos;
            else
              sclk <= '1';
              registre(cpt) := miso;
              cpt := cpt - 1;
              etat <= envoi;
            end if;
          when envoi =>
            sclk <= '0';
            mosi <= registre(cpt);
            etat <= reception;
        end case;
      end if;
    
    end process;

end behavioral_3;
