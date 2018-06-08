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
		procedure sensor_value(constant q : unsigned(1 downto 0) := (others => '0')) is
		begin
			sensor <= q;
			wait for clk_period;
		end procedure;
		procedure Sequence(constant q0, q1, q2, q3, q4, q5, q6, q7, q8, q9 : unsigned(1 downto 0) := (others => '0')) is
		begin
			sensor_value(q0); sensor_value(q1); sensor_value(q2); sensor_value(q3); sensor_value(q4);
			sensor_value(q5); sensor_value(q6); sensor_value(q7); sensor_value(q8); sensor_value(q9);
		end procedure;
   begin		
		reset <= '1';
		sensor <= "00";
		wait for clk_period;
		reset <= '0';
		wait for clk_period;
		Sequence("00", "01", "11", "10", "11", "11", "10", "11", "10", "00");
		Sequence("00", "10", "11", "10", "11", "01", "01", "00", "00", "00");
		Sequence("00", "01", "10", "10", "10", "00", "10", "11", "01", "00");
		Sequence("00", "11", "11", "01", "11", "00", "01", "11", "10", "00");
		--Sequence("00", "00", "00", "00", "00", "00", "00", "00", "00", "00");
		--Sequence("00", "00", "00", "00", "00", "00", "00", "00", "00", "00");
      wait;
   end process;

END;
