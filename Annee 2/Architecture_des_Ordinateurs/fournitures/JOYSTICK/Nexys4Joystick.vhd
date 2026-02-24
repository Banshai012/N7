library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity Nexys4Joystick is
  port (
    -- les 16 switchs
    sw : in std_logic_vector (15 downto 0);
    -- les 5 boutons noirs
    btnC, btnU, btnL, btnR, btnD : in std_logic;
    -- horloge
    mclk : in std_logic;
    -- les 16 leds
    led : out std_logic_vector (15 downto 0);
    -- les anodes pour sélectionner les afficheurs 7 segments à utiliser
    an : out std_logic_vector (7 downto 0);
    -- valeur affichée sur les 7 segments (point décimal compris, segment 7)
    seg : out std_logic_vector (7 downto 0);
    -- port pour faire le slave avec le joystick
    miso : in std_logic;
    ss, mosi, sck : out std_logic
  );
end Nexys4Joystick;

architecture synthesis of Nexys4Joystick is

  -- rappel du (des) composant(s)
  -- À COMPLÉTER 

component All7Segments
    Port ( clk : in  std_logic;
           reset : in std_logic;
           e0 : in std_logic_vector (3 downto 0);
           e1 : in std_logic_vector (3 downto 0);
           e2 : in std_logic_vector (3 downto 0);
           e3 : in std_logic_vector (3 downto 0);
           e4 : in std_logic_vector (3 downto 0);
           e5 : in std_logic_vector (3 downto 0);
           e6 : in std_logic_vector (3 downto 0);
           e7 : in std_logic_vector (3 downto 0);
           an : out std_logic_vector (7 downto 0);
           ssg : out std_logic_vector (7 downto 0));
end component;

component diviseurClk
  -- facteur : ratio entre la fréquence de l'horloge origine et celle
  --           de l'horloge générée
  --  ex : 100 MHz -> 1Hz : 100 000 000
  --  ex : 100 MHz -> 1kHz : 100 000
  generic(facteur : natural);
  port (
    clk, reset : in  std_logic;
    nclk       : out std_logic);
end component;

component MasterJoystick
  port ( rst : in std_logic;
         clk : in std_logic;
         en : in std_logic;
         v1 : in std_logic_vector (7 downto 0);
         miso : in std_logic;
         ss   : out std_logic;
         sclk : out std_logic;
         mosi : out std_logic;
         val_X : out std_logic_vector (9 downto 0);
         val_Y : out std_logic_vector (9 downto 0);
         BTN2 : out std_logic;
         BTN1 : out std_logic;
         BTNJoy : out std_logic;
         busy : out std_logic);
end component;

signal clk : std_logic;
signal btn1 : std_logic;
signal btn2 : std_logic;
signal btnjoy : std_logic;
signal x : std_logic_vector (9 downto 0);
signal y : std_logic_vector (9 downto 0);
signal vin : std_logic_vector (7 downto 0);
signal e2 : std_logic_vector (3 downto 0);
signal e6 : std_logic_vector (3 downto 0);

begin

  -- valeurs des sorties (à modifier)

  -- convention afficheur 7 segments 0 => allumé, 1 => éteint
  -- seg <= (others => '1');
  -- aucun afficheur sélectionné
  -- an(7 downto 0) <= (others => '1');
  -- 16 leds éteintes
  led(9 downto 0) <= (others => '0');
  led(14) <= btn2;
  led(13) <= btn1;
  led(12) <= btnjoy;
  led(11) <= sw(5);
  led(10) <= sw(0);

  vin <= "100000" & sw(15) & sw(14);

  -- connexion du (des) composant(s) avec les ports de la carte
  -- À COMPLÉTER 

  D :  diviseurClk
  -- facteur : ratio entre la fréquence de l'horloge origine et celle
  --           de l'horloge générée
  --  ex : 100 MHz -> 1Hz : 100 000 000
  --  ex : 100 MHz -> 1kHz : 100 000
  generic map (100)
  port map ( clk => mclk,
             reset => sw(0),
             nclk => clk
);

  
  M :  MasterJoystick
  port map ( rst => sw(0),
  clk => clk,
  en => sw(5),
  v1 => vin,
  miso => miso,
  ss => ss,
  sclk => sck,
  mosi => mosi,
  val_X => x,
  val_Y => y,
  BTN2 => btn2,
  BTN1 => btn1,
  BTNJoy => btnjoy,
  busy => led(15)
);

e2 <= "00" & x(9 downto 8);
e6 <= "00" & y(9 downto 8);

A : All7Segments
  Port Map ( clk => mclk,
        reset => sw(0),
        e0 => x(3 downto 0),
        e1 => x(7 downto 4),
        e2 => e2,
        e3 => "0000",
        e4 => y(3 downto 0),
        e5 => y(7 downto 4),
        e6 => e6,
        e7 => "0000",
        an => an,
        ssg => seg
);
end synthesis;
