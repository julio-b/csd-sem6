LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Counter_bench IS
END Counter_bench;
 
ARCHITECTURE behavior OF Counter_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counter
    PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         DIN : IN  unsigned(3 downto 0);
         FULL : OUT  std_logic;
         EMPTY : OUT  std_logic;
         PARKFREE : OUT  unsigned(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal WE : std_logic := '0';
   signal DIN : unsigned(3 downto 0) := (others => '0');

 	--Outputs
   signal FULL : std_logic;
   signal EMPTY : std_logic;
   signal PARKFREE : unsigned(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counter PORT MAP (
          CLK => CLK,
          WE => WE,
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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
