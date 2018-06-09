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
		type ARGS is array (0 to 39) of unsigned(3 downto 0);
		variable QQ : ARGS;
		procedure Sequence(variable Q : ARGS := (others => "0000")) is
		begin
			foreachi : for i in 0 to (Q'length - 1) loop
				DIN <= Q(i);
				wait for CLK_period;
			end loop foreachi;
		end procedure;
   begin
		--------------------------------------------
		--Reset
		DIN <= "0110";
		WE <= '1';
		wait for CLK_period*2;
		WE <= '0';
		wait for CLK_period*2;
		--input sequence a&b--
		QQ :=(
		"00"&"00",
		"01"&"01",
		"11"&"11",
		"10"&"10",
		"00"&"00",
		"00"&"00",
		"01"&"01",
		"11"&"11",
		"10"&"10",
		"00"&"00",
		"01"&"01",
		"11"&"11",
		"10"&"10",
		"00"&"00",
		--"XX"&"XX",
		--"ZZ"&"ZZ",
		-- .
		-- ..
		-- ...
		-------------
		--default
		others => "0000");Sequence(QQ);
		
		--===================================================--
		-------------------------------------------------------
		--===================================================--
		
		DIN <= "1110";
		WE <= '1';
		wait for CLK_period*2;
		WE <= '0';
		wait for CLK_period*2;
		
		QQ :=(
		"00"&"00",   --   |  
		"01"&"01",   --   |  
		"01"&"11",   --   |  
		"01"&"01",   --   |  
		"11"&"00",   --   | +
		"11"&"00",   --   |  
		"10"&"00",   --   |  
		"00"&"00",   -- + |  
		"01"&"01",   --   |  
		"11"&"11",   --   |  
		"11"&"10",   --   |  
		"11"&"00",   --   | +
		"00"&"01",   --   |  
		"01"&"11",   --   |  
		"00"&"10",   --   |  
		"01"&"00",   --   | +
		"01"&"00",   --   |  
		"11"&"00",   --   |  
		"11"&"10",   --   |  
		"01"&"11",   --   |  
		"11"&"01",   --   |  
		"10"&"00",   --   | -
		"10"&"01",   --   |  
		"10"&"11",   --   |  
		"00"&"10",   -- + |  
		"00"&"00",   --   | +
		"01"&"01",   --   |  
		"11"&"11",   --   |  
		"10"&"10",   --   |  
		"00"&"00",   -- + | +
		others => "0000");Sequence(QQ);
		
		wait;
   end process;

END;
