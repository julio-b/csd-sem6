LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.direction_vector.all;
 
ENTITY Counterx_bench IS
END Counterx_bench;
 
ARCHITECTURE behavior OF Counterx_bench IS 
    constant N : natural := 2;

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counterx
    GENERIC ( N : natural:= 2 );
    PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         DIRECTIONS : IN direction_vector(0 to N-1);
         DIN : IN  unsigned(3 downto 0);
         FULL : OUT  std_logic;
         EMPTY : OUT  std_logic;
         PARKFREE : OUT  unsigned(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal WE : std_logic := '0';
   signal DIRECTIONS : direction_vector(0 to N-1) := (others => (others =>'0'));
   signal DIN : unsigned(3 downto 0) := (others => '0');

 	--Outputs
   signal FULL : std_logic;
   signal EMPTY : std_logic;
   signal PARKFREE : unsigned(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counterx GENERIC MAP (N=>N) PORT MAP (
          CLK => CLK,
          WE => WE,
          DIRECTIONS => DIRECTIONS,
          DIN => DIN,
          FULL => FULL,
          EMPTY => EMPTY,
          PARKFREE => PARKFREE
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin
		DIN <= "0110"; --6
		WE <= '1';
		wait for CLK_period*4;
		WE <= '0';
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "00"; wait for CLK_period;
		DIRECTIONS(1) <= "01"; DIRECTIONS(0) <= "00"; wait for CLK_period;
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "01"; wait for CLK_period;
		DIRECTIONS(1) <= "01"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "01"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "00"; wait for CLK_period;
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "00"; wait for CLK_period;
		DIRECTIONS(1) <= "11"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "11"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "01"; DIRECTIONS(0) <= "01"; wait for CLK_period;
		DIRECTIONS(1) <= "01"; DIRECTIONS(0) <= "01"; wait for CLK_period;
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "01"; wait for CLK_period;
		DIRECTIONS(1) <= "11"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "11"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "11"; DIRECTIONS(0) <= "11"; wait for CLK_period;
		DIRECTIONS(1) <= "00"; DIRECTIONS(0) <= "00"; wait for CLK_period;
		
		DIN <= "1110";
		WE <= '1';
		wait for CLK_period*4;
		
		wait;
   end process;

END;
