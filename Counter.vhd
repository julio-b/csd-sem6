library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.direction_vector.all;

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

signal directions : direction_vector(0 to N-1);

begin

	Gates :
	for i in 0 to N-1 generate
	begin
		G_S:
		entity work.Gate_System
		port map (
			CLK => CLK ,
			reset => WE ,
			sensor => DIN(2*i+1 downto 2*i),
			direction => directions(i)
		) ;
	end generate;
	
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
		DIRECTIONS => directions
	);

end Behavioral;
