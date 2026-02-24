-- fichier à écraser avec le fichier généré par ISE (New Source)

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MasterJoystick is
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
end MasterJoystick;

architecture behavior of MasterJoystick is

  component er_1octet is
    port ( rst : in std_logic ;
          clk : in std_logic ;
          en : in std_logic ;
          din : in std_logic_vector (7 downto 0) ;
          miso : in std_logic ;
          sclk : out std_logic ;
          mosi : out std_logic ;
          dout : out std_logic_vector (7 downto 0) ;
          busy : out std_logic);
  end component;

  type t_etat is (warmup, echange, attente);
  signal etat : t_etat;

  signal en_er : std_logic;
  signal din_er : std_logic_vector (7 downto 0);
  signal dout_er : std_logic_vector (7 downto 0);
  signal busy_er : std_logic;

begin
  ER11 : er_1octet Port Map(
    rst => rst,
    clk => clk,
    en => en_er,
    din => din_er,
    miso => miso,
    sclk => sclk,
    mosi => mosi,
    dout => dout_er,
    busy => busy_er
  );

  process (clk, rst)
  
  variable tps_warm : natural := 0;
  variable tps_echange : natural := 0;
  variable tps_attente : natural := 0;
  variable numero : natural := 0;
  variable reg_v1 : std_logic_vector(7 downto 0);
  variable reg_X1 : std_logic_vector(7 downto 0);
  variable reg_X2 : std_logic_vector(7 downto 0);
  variable reg_Y1 : std_logic_vector(7 downto 0);
  variable reg_Y2 : std_logic_vector(7 downto 0);
  variable reg_BTN : std_logic_vector(7 downto 0);

  -- essayer de le faire sans compteur. Pour passer de attente à échange, on active en_er. On le désactive dans échange, mais on met une condition de sortie sur busy = 0 et en_er = 0

  begin
    if (rst = '0') then      
      ss <= '1';
      en_er <= '0';
      busy <= '0';
      val_x <= (others => 'U');
      val_y <= (others => 'U');
      BTN2 <= 'U';
      BTN1 <= 'U';
      BTNJoy <= 'U';
      tps_warm := 0;
      tps_echange := 0;
      tps_attente := 0;
      numero := 0;
      etat <= warmup;

    elsif (rising_edge(clk)) then
      case etat is
        when warmup =>
          if (en = '1') then
            ss <= '0';
            busy <= '1';
            reg_v1 := v1;
            etat <= attente;
          end if;

        when attente =>
        if (tps_warm >= 30) then
          case( numero ) is
          
            when 0 =>
              en_er <= '1';
              din_er <= reg_v1;
              numero := (numero + 1) mod 5;
              etat <= echange;

            when others =>
              din_er <= (others => 'U');
              if (tps_attente >= 20) then
                en_er <= '1';
                tps_attente := 0;
                numero := (numero + 1) mod 5;
                etat <= echange;
              end if ;
          
          end case ;
          tps_attente := tps_attente + 1;
        end if ;
        tps_warm := tps_warm + 1;

        when echange =>
          en_er <= '0';
          if (busy_er = '0' and en_er = '0') then
            case( numero ) is
            
              when 1 =>
                reg_X1 := dout_er;
                etat <= attente;
                
              when 2 =>
                reg_X2 := dout_er;
                etat <= attente;
                Val_X <= reg_X2(1 downto 0) & reg_X1;

              when 3 =>
                reg_Y1 := dout_er;
                etat <= attente;
                
              when 4 =>
                reg_Y2 := dout_er;
                etat <= attente;
                Val_Y <= reg_Y2(1 downto 0) & reg_Y1;

              when others =>
                reg_BTN := dout_er;
                BTN2 <= reg_BTN(2);
                BTN1 <= reg_BTN(1);
                BTNJoy <= reg_BTN(0);
                busy <= '0';
                ss <= '1';
                tps_warm := 0;
                etat <= warmup;
            
            end case ;
          end if ;
      end case ;
    end if ;
      

  end process;

end behavior;
