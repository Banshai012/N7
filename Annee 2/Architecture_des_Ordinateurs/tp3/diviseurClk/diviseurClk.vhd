library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity diviseurClk is
  -- facteur : ratio entre la fréquence de l'horloge origine à 100 MHz
  --           et celle de l'horloge générée
  --  ex : 100 MHz -> 1Hz : facteur = 100 000 000
  --  ex : 100 MHz -> 1kHz : facteur = 100 000
  generic(facteur : natural);
  port (
        clk   : in std_logic;
        reset : in  std_logic;
        nclk  : out std_logic
       );
end diviseurClk;

architecture behavioural of diviseurClk is

begin

process (clk, reset)
  
  variable compteur : natural := 0;
  
  begin
  
      if(reset = '0') then
      nclk <= '0' after 10ns;
    elsif(rising_edge(clk)) then
      compteur := compteur + 1;
      if(compteur = facteur) then
        nclk <= '1' after 10ns;
        compteur := 0;
      else
        nclk <= '0' after 10ns;
      end if;
    end if;
  
  end process;
	  
end behavioural;
