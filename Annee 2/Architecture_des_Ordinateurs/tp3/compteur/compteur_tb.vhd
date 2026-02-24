library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity compteur_tb is
end compteur_tb;

architecture Behavioral of compteur_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component compteur is
        Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           cpt : out STD_LOGIC_VECTOR(3 downto 0);
           retenue : out STD_LOGIC);
    end component;
    
    -- Inputs
    signal clk : STD_LOGIC;
    signal reset : STD_LOGIC;

    -- Outputs
    signal cpt : STD_LOGIC_VECTOR(3 downto 0);
    signal retenue : STD_LOGIC;

    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT : compteur Port Map(
        clk => clk,
        reset => reset,
        cpt => cpt,
        retenue => retenue
        );
    
    -- Clock process
    clk_process : process  
    begin  
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;	
    end process;
    
    -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      reset <= '0';
      wait for 100 ns;	
      
      -- release reset
      reset <= '1';
      
      -- insert stimulus

      wait;
   end process;

end Behavioral;
