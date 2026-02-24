library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity diviseurClk_tb is
end diviseurClk_tb;

architecture Behavioral of diviseurClk_tb is

    -- Component Declaration for the Unit Under Test (UUT)
  component diviseurClk generic(facteur : natural);
  port (
        clk   : in std_logic;
        reset : in  std_logic;
        nclk  : out std_logic
       );
  end component;

    -- Inputs
    signal clk : STD_LOGIC;
    signal reset : STD_LOGIC;

    -- Outputs
    signal nclk  : std_logic;
    
    -- Clock period definition
    CONSTANT clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    UUT : diviseurClk
       GENERIC MAP(10)
       PORT MAP(
       clk => clk,
       reset => reset,
       nclk => nclk
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
