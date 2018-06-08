LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Gate_System_bench IS
END Gate_System_bench;
 
ARCHITECTURE behavior OF Gate_System_bench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Gate_System
    PORT(
         clk : IN  std_logic;
         reset : IN std_logic;
         sensor : IN  unsigned(1 downto 0);
         direction : OUT  signed(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
	signal reset : std_logic := '0';
   signal sensor : unsigned(1 downto 0) := (others => '0');

 	--Outputs
   signal direction : signed(1 downto 0);
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Gate_System PORT MAP (
          clk => clk,
			 reset => reset,
          sensor => sensor,
          direction => direction
        );

   -- Clock process definitions
   clk_process :process
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
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
