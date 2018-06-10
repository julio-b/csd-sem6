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
generic ( N : natural:= 5 );
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

signal N_middle_dir : array_for_N_A_dir_signals (0 to N-1 );

begin
	N_Gates :
	for i in 0 to N-1 generate
	begin
		Gate_N_i:
		entity work.Gate_System
		port map (
			CLK => CLK ,
			reset => WE ,
			sensor => DIN(2*i+1 downto 2*i),
			direction => N_middle_dir(i)
		) ;
	end generate N_Gates;

	
	Counterx:
	entity work.Counterx(Behavioral)
	generic map ( N=>N ) 
	port map (
		CLK => CLK,
		WE => WE ,
		DIN => DIN(3 downto 0),
		FULL => FULL,
		EMPTY => EMPTY,
		PARKFREE => PARKFREE,
		N_A_dir => N_middle_dir
	);

end Behavioral;
