library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.direction_vector.all;

entity Counterx is 
generic ( N : natural:= 2 );

Port ( 
	CLK : in  std_logic;
	WE : in  std_logic;
	DIRECTIONS : in direction_vector(0 to N-1);
	DIN : in  unsigned(3 downto 0);
	FULL : out  std_logic;
	EMPTY : out  std_logic;
	PARKFREE : out unsigned(3 downto 0)
	);
end Counterx;

architecture Behavioral of Counterx is

signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15

begin
	count : process(CLK, WE) is
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
		elsif rising_edge(CLK) then
			assert(PARK_CNT /= PARKTOTAL or SUM(DIRECTIONS)<=0) report "Vehicle enters a full parking" severity warning;
			assert(PARK_CNT /= 0 or SUM(DIRECTIONS)>=0) report "Vehicle leaves from an empty parking" severity warning;
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + SUM(DIRECTIONS));
			assert(PARK_CNT <= PARKTOTAL) report "Possible park_cnt overflow, please reset" severity warning;
		end if;
	end process count;

	----------------Register-----------------|
	The_smallest_process_ever :process (CLK) is
	begin
		if rising_edge (CLK) then
			If WE = '1' then
				PARKTOTAL <= DIN ;
				assert(DIN<16) report "DIN > 15" severity error;
				assert(DIN/=0) report "DIN == 0" severity error;
			end if;
		end if;
	end process The_smallest_process_ever ;

	PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

end Behavioral;
