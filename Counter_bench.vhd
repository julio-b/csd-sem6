LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY Counter_bench IS
END Counter_bench;
 
ARCHITECTURE behavior OF Counter_bench IS 
    constant N : natural := 2; -----<<<<<<<

    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Counter
    GENERIC ( N : natural:= 2; H : natural:= 2 );
    PORT(
         CLK : IN  std_logic;
         WE : IN  std_logic;
         DIN : IN  unsigned(2*N-1 downto 0);
         FULL : OUT  std_logic;
         EMPTY : OUT  std_logic;
         PARKFREE : OUT  unsigned(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal WE : std_logic := '0';
   signal DIN : unsigned(2*N-1 downto 0) := (others => '0');

 	--Outputs
   signal FULL : std_logic;
   signal EMPTY : std_logic;
   signal PARKFREE : unsigned(3 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Counter GENERIC MAP (N=>N, H=>25000000) PORT MAP (
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
		type ARGS is array (0 to 35) of unsigned(2*N-1 downto 0);
		variable QQ : ARGS;
		procedure Sequence(variable Q : ARGS := (others => (others => '0'))) is
		begin
			foreachi : for i in 0 to (Q'length - 1) loop
				DIN <= Q(i);
				wait for CLK_period;
			end loop foreachi;
		end procedure;
   begin
		--------------------------------------------
--		--Reset
		DIN <= "0101"; -- 5
		WE <= '1'; wait for CLK_period*2;
		WE <= '0'; wait for CLK_period*2;
--		--input sequence A&B--
		QQ :=(
		"00"&"00",
		"01"&"00",
		"01"&"00",
		"11"&"00",
		"11"&"00",
		"10"&"00",
		"00"&"00", -- 1 in
		"00"&"00",
		"01"&"01",
		"11"&"11",
		"10"&"10",
		"00"&"00", -- 2 in
		"00"&"00",
		"10"&"01",
		"10"&"01",
		"11"&"11",
		"11"&"11",
		"01"&"10",
		"01"&"10",
		"00"&"00", -- 1 out 1 in
		"01"&"01",
		"11"&"01",
		"01"&"01",
		"11"&"11",
		"10"&"11",
		"11"&"10",
		"10"&"00", -- 1 in
		"00"&"00", -- 1 in, full
		others => (others => '0'));Sequence(QQ);

		QQ :=(
		"00"&"00",
		"10"&"10",
		"10"&"10",
		"11"&"11",
		"11"&"11",
		"11"&"01",
		"01"&"01",
		"01"&"01",
		"00"&"00", -- 2 out
		"00"&"10",
		"00"&"10",
		"00"&"11",
		"10"&"11",
		"10"&"01",
		"11"&"01",
		"11"&"00", -- 1 out
		"01"&"00",
		"01"&"10",
		"00"&"10", -- 1 out
		"00"&"11",
		"00"&"11",
		"01"&"01",
		"11"&"01",
		"10"&"00", -- 1 out empty
		"10"&"00",
		"00"&"00", -- 1 in
		others => (others => '0'));Sequence(QQ);

		DIN <= "0011"; -- 3 reset
		WE <= '1'; wait for CLK_period;
		WE <= '0'; wait for CLK_period;
		
		QQ :=(
		"00"&"00",
		"01"&"01",
		"11"&"11",
		"10"&"10",
		"00"&"00", -- 2 in
		"01"&"00",
		"11"&"00",
		"10"&"00",
		"00"&"01", -- 1 in full
		"00"&"11",
		"00"&"10",
		"00"&"00", -- 1 in, assert error
		others => (others => '0'));Sequence(QQ);

		DIN <= "0011"; -- 3 reset
		WE <= '1'; wait for CLK_period;
		WE <= '0'; wait for CLK_period;
		
		QQ :=(
		"00"&"00", --empty
		"10"&"10",
		"10"&"10",
		"11"&"11",
		"11"&"11",
		"01"&"00",
		"01"&"00",
		"00"&"00", --1 out, assert error
		"00"&"00",
		others => (others => '0'));Sequence(QQ);

--		
--		--===================================================--
--		-------------------------------------------------------
--		--===================================================--
--		DIN <= "000011";
--		WE <= '1'; wait for CLK_period*2;
--		WE <= '0'; wait for CLK_period*2;
--		--input sequence A&B&C--
--		QQ :=(
--		"00"&"00"&"00",
--		"10"&"00"&"00",
--		"11"&"00"&"00",
--		"01"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"01"&"01"&"01",
--		"11"&"11"&"11",
--		"10"&"10"&"10",
--		"00"&"00"&"00",
--		"00"&"00"&"00",
--		"01"&"01"&"01",
--		"11"&"11"&"11",
--		"10"&"10"&"10",
--		"00"&"00"&"00",
--		--"XX"&"XX"&"XX",
--		--"ZZ"&"ZZ"&"ZZ",
--		others => (others => '0'));Sequence(QQ);
		
		wait;
   end process;

END;
