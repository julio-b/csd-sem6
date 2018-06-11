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
	PARKFREE : out unsigned(3 downto 0);
	OVERFLOW : out std_logic;
	UNDERFLOW : out std_logic
	);
end Counterx;

architecture Behavioral of Counterx is

signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15
signal overflow_m, underflow_m : std_logic;

impure function "+" (l : unsigned(3 downto 0); r : signed(3 downto 0)) return unsigned is
	variable result : unsigned(3 downto 0);
	variable fixing : unsigned(3 downto 0);
begin
	result := unsigned(signed(std_logic_vector(l)) + r);
	fixing := PARKTOTAL + 1;
	if result > PARKTOTAL then --result in (PARKTOTAL..2^4]
		if  r<0 then
			result := result + fixing;
		else
			result := result - fixing;
		end if;
	end if;
	return result;
end function "+";

begin

	count : process(CLK, WE) is
		variable PARK_CNT_NEW : unsigned(3 downto 0);
		variable overflow_condition, underflow_condition: boolean;
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
			overflow_m <= '0';
			underflow_m <= '0';
		elsif rising_edge(CLK) then
			PARK_CNT_NEW := PARK_CNT + SUM(DIRECTIONS);
			
			overflow_condition := SUM(DIRECTIONS) > 0 and PARK_CNT_NEW < PARK_CNT;
			underflow_condition := SUM(DIRECTIONS) < 0 and PARK_CNT_NEW > PARK_CNT;
			
			if overflow_m='1' and underflow_condition then
				overflow_m <= '0';
			elsif underflow_m='1' and overflow_condition then
				underflow_m <= '0';
			elsif overflow_condition then
				overflow_m <= '1';
				report "Vehicle enters a full parking" severity warning;
			elsif underflow_condition then
				underflow_m <= '1';
				report "Vehicle leaves from an empty parking" severity warning;
			end if;
			
			PARK_CNT <= PARK_CNT_NEW;
		end if;
	end process count;

	PARKTOTAL_register :process (CLK) is
	begin
		if rising_edge (CLK) then
			If WE = '1' then
				PARKTOTAL <= DIN ;
				assert (DIN<16) report "DIN > 15" severity warning;
				assert (DIN/=0) report "DIN == 0" severity error;
			end if;
		end if;
	end process PARKTOTAL_register ;

	PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';
	OVERFLOW <= overflow_m;
	UNDERFLOW <= underflow_m;

end Behavioral;
