library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.direction_vector.all;

entity Counterx is 
generic ( N : natural:= 2 );

Port ( 
	CLK : in  std_logic;
	WE : in  std_logic;
	DIRECTIONS : direction_vector(0 to N-1);
	DIN : in  unsigned(3 downto 0);
	FULL : out  std_logic;
	EMPTY : out  std_logic;
	PARKFREE : out unsigned(3 downto 0)
	);
end Counterx;

architecture Behavioral of Counterx is
-------------------Declaration of Signals------------------------|
signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15

-------------------Procedure------------------------|
procedure Check_signals(signal DIN, PARKTOTAL, PARK_CNT: in  unsigned(3 downto 0))is
begin
	assert (DIN<16);
	report "DIN > 15" severity error ;
	if (DIN = 0)  then
		report "DIN=0" severity note;
	end if;
	assert(PARKTOTAL <= DIN) ;
	report "PARKTOTAL <= DIN" severity note;
end;

--------------------BEGIN---------------------------|
begin
	--------------Count Process---------------|
	count : process(CLK, WE) is
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
		elsif rising_edge(CLK) then
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + SUM(DIRECTIONS));
		end if;
	end process count;

	----------------Register-----------------|
	The_smallest_process_ever :process (CLK) is
	begin
		if rising_edge (CLK) then
			If WE = '1' then
				PARKTOTAL <= DIN ;
			end if;
		end if;
	end process The_smallest_process_ever ;

	Check_signals (  DIN , PARKTOTAL, PARK_CNT); -------procedure---------|
	PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

end Behavioral;
