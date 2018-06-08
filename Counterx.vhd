
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


use IEEE.NUMERIC_STD.ALL;



entity Counterx is 

Port ( 
		CLK : in  std_logic;
      WE : in  std_logic;		
		A_dir, B_dir : in signed(1 downto 0);
      DIN : in  unsigned(3 downto 0);
      FULL : out  std_logic;
      EMPTY : out  std_logic;
		PARKFREE : out unsigned(3 downto 0)
		);

end Counterx;

architecture Behavioral of Counterx is

signal AnB : signed(3 downto 0);
signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15
begin

AnB <= resize(A_dir, AnB'length) + resize(B_dir, AnB'length);

PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

count : process(CLK, AnB, WE ) is
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
		elsif rising_edge(CLK) then
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + AnB);
		end if;
end process count;


The_smallest_process_ever :process (CLK) is

	begin 
		
		if rising_edge (CLK) then 
			If WE = '1' then 
				PARKTOTAL <= DIN ; 
			end if;
		end if;
end process	The_smallest_process_ever ;



end Behavioral;

