library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Counter is 
Port ( 
		CLK : in  std_logic;
      WE : in  std_logic;
      DIN : in  unsigned(3 downto 0);
      FULL : out  std_logic;
      EMPTY : out  std_logic;
		PARKFREE : out unsigned(3 downto 0)
		);
end Counter;

architecture Behavioral of Counter is 

	signal A, B : unsigned(1 downto 0);
	signal A_middle_dir, B_middle_dir :signed(1 downto 0);

begin

	A <= DIN(3 downto 2);
	B <= DIN(1 downto 0);

	Gate_A:
	entity work.Gate_System(Behavioral)
	port map( 
				 clk => CLK,
				 reset => WE,
				 sensor => A,
				 direction => A_middle_dir
				);

	Gate_B:
	entity work.Gate_System(Behavioral)
	port map( 
				 clk => CLK,
				 reset => WE,
				 sensor => B,
				 direction => B_middle_dir
				);

	Counterx:
	entity work.Counterx(Behavioral)
	port map (
				 CLK => CLK,
				 WE => WE ,
				 DIN => DIN,
				 FULL => FULL,
				 EMPTY => EMPTY,
				 PARKFREE => PARKFREE,
				 A_dir => A_middle_dir,
				 B_dir => B_middle_dir
				 );

end Behavioral;