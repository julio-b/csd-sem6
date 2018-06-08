LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Counterx_bench IS
END Counterx_bench;
 
ARCHITECTURE behavior OF Counterx_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counterx
    PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         A_dir : IN  signed(1 downto 0);
         B_dir : IN  signed(1 downto 0);
         DIN : IN  unsigned(3 downto 0);
         FULL : OUT  std_logic;
         EMPTY : OUT  std_logic;
         PARKFREE : OUT  unsigned(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal WE : std_logic := '0';
   signal A_dir : signed(1 downto 0) := (others => '0');
   signal B_dir : signed(1 downto 0) := (others => '0');
   signal DIN : unsigned(3 downto 0) := (others => '0');

 	--Outputs
   signal FULL : std_logic;
   signal EMPTY : std_logic;
   signal PARKFREE : unsigned(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counterx PORT MAP (
          CLK => CLK,
          WE => WE,
          A_dir => A_dir,
          B_dir => B_dir,
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
		A_dir <= "00"; B_dir <= "00"; wait for CLK_period;
		A_dir <= "01"; B_dir <= "00"; wait for CLK_period;
		A_dir <= "00"; B_dir <= "01"; wait for CLK_period;
		A_dir <= "01"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "01"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "00"; B_dir <= "00"; wait for CLK_period;
		A_dir <= "00"; B_dir <= "00"; wait for CLK_period;
		A_dir <= "11"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "11"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "01"; B_dir <= "01"; wait for CLK_period;
		A_dir <= "01"; B_dir <= "01"; wait for CLK_period;
		A_dir <= "00"; B_dir <= "01"; wait for CLK_period;
		A_dir <= "11"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "11"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "11"; B_dir <= "11"; wait for CLK_period;
		A_dir <= "00"; B_dir <= "00"; wait for CLK_period;
		
		DIN <= "1110";
		WE <= '1';
		wait for CLK_period*4;
		
		wait;
   end process;

END;
