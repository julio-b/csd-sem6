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


entity Counter is 
generic ( N : natural:= 2 );
Port ( 
		CLK : in  std_logic;
      WE : in  std_logic;
      DIN : in  unsigned(2*N -1 downto 0);
      FULL : out  std_logic;
      EMPTY : out  std_logic;
		PARKFREE : out unsigned(3 downto 0)
		);
end Counter;

architecture Behavioral of Counter is 
component Gate_System is 
Port (
		clk : in  std_logic;
		reset : in std_logic;
		sensor : in  unsigned(1 downto 0);
		direction : out  signed(1 downto 0)
		);
end component ; 

type array_for_N_sensor_signals is array (0 to N-1 ) of unsigned (1 downto 0);

signal N_i : array_for_N_sensor_signals;
signal N_middle_dir : array_for_N_A_dir_signals (0 to N-1 );

begin
N_Gates :
for i in 0 to N-1 generate 

	begin 
	
	N_i(0) <= DIN((2*N-1) downto (2*N-2));
	N_i(i) <= DIN(N-1 downto 0);
		Gate_N_0: 
		if (i =0 ) generate
						begin
							Gate_N_0: entity work.Gate_System
							port map (
										CLK => CLK ,
										reset => WE ,
										sensor => N_i(0),
										direction => N_middle_dir(0)
										) ;
		
		end generate Gate_N_0 ;

		Gate_N_i: if (i > 0 ) generate
						begin
							Gate_N_0: entity work.Gate_System
							port map (
										CLK => CLK ,
										reset => WE ,
										sensor => N_i(i),
										direction => N_middle_dir(i)
										) ;
		
		end generate Gate_N_i ;
		
		Counterx:
							entity work.Counterx(Behavioral)
							port map (
										CLK => CLK,
										WE => WE ,
										DIN => DIN,
										FULL => FULL,
										EMPTY => EMPTY,
										PARKFREE => PARKFREE,			
										N_A_dir => N_middle_dir(i)
										);

				 
end generate N_Gates;
end Behavioral;