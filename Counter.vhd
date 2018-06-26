library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.direction_vector.all;

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

signal directions : direction_vector(0 to N-1);
signal clk_led_blinking : std_logic;
signal full_m, empty_m, overflow, underflow : std_logic;

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
	end generate Gates;
	
	Counterx:
	entity work.Counterx(Behavioral)
	generic map ( N=>N ) 
	port map (
		CLK => CLK,
		WE => WE ,
		DIN => DIN(3 downto 0),
		FULL => full_m,
		EMPTY => empty_m,
		PARKFREE => PARKFREE,
		OVERFLOW => overflow,
		UNDERFLOW => underflow,
		DIRECTIONS => directions
	);

	freq_div_unit:
	entity work.freq_div(Behavioral)
	generic map(CLK_INPUT => 50000000, CLK_OUTPUT => 2)  -- 25000000)
	port map(clk_in => CLK, clk_out =>  clk_led_blinking);

	FULL <= full_m when overflow='0' else clk_led_blinking;
	EMPTY <= empty_m when underflow='0' else clk_led_blinking;

end Behavioral;
