
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;


entity Gate_System is
    Port ( 
			  clk : in  std_logic;
           reset : in std_logic;
           sensor : in  unsigned(1 downto 0);
           direction : out  signed(1 downto 0)
			  );
end Gate_System;

architecture Behavioral of Gate_System is

type sensor_state is (s0, s1, s2, s3, s_1, s_2, s_3);
signal current_state, next_state: sensor_state;

begin

state_reg : process(clk, reset) is

	begin
	
		if reset = '1'	then
			current_state <= s0;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
		
	end process state_reg;

next_state_logic : process(current_state, sensor) is

	begin

			next_state <= current_state;
		
			case current_state is
			
			when s0 =>
				
				if sensor = "01" then
					next_state <= s1;
				elsif sensor = "10" then
					next_state <= s_1;
				end if;
				
			when s1 =>
			
				if sensor = "11" then
					next_state <= s2;
				elsif sensor = "00" then
					next_state <= s0;
				elsif sensor = "10" then
					next_state <= s0; -- ? or s_1
				end if;
				
			when s2 =>
			
				if sensor = "10" then
					next_state <= s3;
				elsif sensor = "01" then
					next_state <= s1;
				elsif sensor = "00" then
					next_state <= s0; -- ?
				end if;
				
			when s3 =>
				if sensor = "00" then
					next_state <= s0; -- count +1
				elsif sensor = "11" then
					next_state <= s2;
				elsif sensor = "01" then
					next_state <= s0; -- ?
				end if;
				
			when s_1 =>
				if sensor = "11" then
					next_state <= s_2;
				elsif sensor = "00" then
					next_state <= s0;
				elsif sensor = "01" then
					next_state <= s0; -- ? or s1
				end if;
			
			when s_2 =>
				if sensor = "01" then
					next_state <= s_3;
				elsif sensor = "10" then
					next_state <= s_1;
				elsif sensor = "00" then
					next_state <= s0; -- ?
				end if;
		
			when s_3 =>
				if sensor = "00" then
					next_state <= s0; -- count -1
				elsif sensor = "11" then
					next_state <= s_2;
				elsif sensor = "10" then
					next_state <= s0; -- ?
				end if;
		end case;
	
	end process next_state_logic;

	output_logic : process(current_state, sensor) is
	begin
			direction <= "00";
		case current_state is
		when s3 =>
			if sensor = "00" then
				direction <= "01";
			end if;
		when s_3 =>
			if sensor = "00" then
				direction <= "11";
			end if;
		when others =>
			null;
		end case;
end process output_logic;



end Behavioral;

