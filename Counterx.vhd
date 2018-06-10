library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package array_for_N_A_dir_signals is
  Subtype dir_signals        is signed(1 downto 0);
  Type    array_for_N_A_dir_signals        is array (natural range <>) of dir_signals;
end package;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use array_for_N_A_dir_signals.all;

entity Counterx is 
generic ( N : natural:= 2 );

Port ( 
	CLK : in  std_logic;
	WE : in  std_logic;
	N_A_dir: array_for_N_A_dir_signals( 0 to N-1);
	DIN : in  unsigned(3 downto 0);
	FULL : out  std_logic;
	EMPTY : out  std_logic;
	PARKFREE : out unsigned(3 downto 0)
	);
end Counterx;

architecture Behavioral of Counterx is
-------------------Declaration of Signals------------------------|
signal N_AnB : unsigned(3 downto 0);
signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15
-------------------Procedure------------------------|
procedure Check_signals (
								
								signal DIN : in  unsigned(3 downto 0);
								signal PARKTOTAL: in unsigned(3 downto 0);
								signal PARK_CNT: in unsigned(3 downto 0)								
                       	)is
begin 							
			assert (DIN<16) ;		
			report "DIN > 15" severity error ;
						
			if (DIN = 0)  then		
			  report "DIN=0" severity note;
			end if; 
						
			assert(PARKTOTAL <= DIN) ;
			report "PARKTOTAL <= DIN" severity note;			
end;
								
begin
	sum_N: process(N_A_dir)
		variable tSUM: signed(3 downto 0);
	begin
		tSUM := (others => '0');
		for i in N_A_dir'length loop
			tSUM := tSUM + resize(N_A_dir(i), tSUM'length);
		end loop;
		N_AnB <= tSUM;
	end process sum_N;

   --------------Count Process---------------|
	count : process(CLK, N_AnB, WE ) is
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
		elsif rising_edge(CLK) then
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + N_AnB);
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
	end process	The_smallest_process_ever ;

	Check_signals (  DIN , PARKTOTAL, PARK_CNT); -------procedure---------|
	PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

end Behavioral;
