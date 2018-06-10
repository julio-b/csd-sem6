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
		N_A_dir: in signed (2*N-1 downto 0 );--array_for_N_A_dir_signals( 0 to N-1) ; 
      DIN : in  unsigned(2*N-1 downto 0);
      FULL : out  std_logic;
      EMPTY : out  std_logic;
		PARKFREE : out unsigned(3 downto 0)
		);
end Counterx;

architecture Behavioral of Counterx is
-------------------Declaration of Type------------------------|
type array_for_N_AnB_signals is array (0 to N-1 ) of signed (3 downto 0); 
-------------------Declaration of Signals------------------------|
signal N_A_middle_dir : array_for_N_A_dir_signals( 0 to N-1) ;
signal N_AnB : array_for_N_AnB_signals ;
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
-------------------For_Loop------------------------|
N_Input : for i in 0 to N-1 generate
 --  N_A_middle_dir(i) <= N_A_dir(i) ;
 
 Gate_N_0: 
		if (i =0 ) generate
						begin
						N_AnB(0) <= resize(N_A_dir(0), N_AnB(0)'length + "0000");
						PARKFREE <= PARKTOTAL - PARK_CNT;
						EMPTY <= '1' when PARK_CNT = 0 else '0' ;
						FULL <= '1' when PARK_CNT = PARKTOTAL else '0';
		end generate Gate_N_0 ;
		
		Gate_N_1: 
		if (i =1 ) generate
						begin
						N_AnB(i) <= resize(N_A_dir(0), N_AnB(0)'length) + resize(N_A_dir(i), N_AnB(i)'length);
						PARKFREE <= PARKTOTAL - PARK_CNT;
						EMPTY <= '1' when PARK_CNT = 0 else '0' ;
						FULL <= '1' when PARK_CNT = PARKTOTAL else '0';
		end generate Gate_N_1 ;
		
		Gate_N_1: 
		if (i >1 ) generate
						begin
						N_AnB(i) <= resize(N_A_dir(i-1), N_AnB(i-1)'length) + resize(N_A_dir(i), N_AnB(i)'length);
						PARKFREE <= PARKTOTAL - PARK_CNT;
						EMPTY <= '1' when PARK_CNT = 0 else '0' ;
						FULL <= '1' when PARK_CNT = PARKTOTAL else '0';
		end generate Gate_N_0 ;
		
--	N_AnB(i) <= resize(N_A_dir(0), N_AnB(0)'length) + resize(N_A_dir(i), N_AnB(i)'length);
--	PARKFREE <= PARKTOTAL - PARK_CNT;
--	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
--	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

   --------------Count Process---------------|
	count : process(CLK, N_AnB(i), WE ) is
	begin
		if WE = '1' then
			PARK_CNT <= (others => '0');
		elsif rising_edge(CLK) then
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + N_AnB(i));
		end if;
		
	end process count;
	
end generate N_Input ;
----------------End Of For Loop---------------------|

   Check_signals (  DIN , PARKTOTAL, PARK_CNT); -------procedure---------|
	
   ----------------Register-----------------|
	The_smallest_process_ever :process (CLK) is	
	begin 
		if rising_edge (CLK) then 
			If WE = '1' then 
				PARKTOTAL <= DIN ; 
			end if;
		end if;		
	end process	The_smallest_process_ever ;


end Behavioral;
								
								