library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Counter is
    Port ( CLK : in  std_logic;
           WE : in  std_logic;
           DIN : in  unsigned(3 downto 0);
           FULL : out  std_logic;
           EMPTY : out  std_logic;
           PARKFREE : out  unsigned(3 downto 0));
end Counter;

architecture Behavioral of Counter is
signal A, B : unsigned(1 downto 0);
signal A_dir, B_dir :signed(1 downto 0);
signal A_rdy, B_rdy, AnB_rdy : std_logic;
signal AnB : signed(3 downto 0);
signal PARKTOTAL: unsigned(3 downto 0); --MA? 15
signal PARK_CNT: unsigned(3 downto 0); --MA? 15

begin
	A <= DIN(3 downto 2);
	B <= DIN(1 downto 0);
	Gate_A:
	entity work.Gate_System(Behavioral)
	port map( clk => CLK,
				 reset => WE,
				 sensor => A,
				 direction => A_dir,
				 ready => A_rdy);
	Gate_B:
	entity work.Gate_System(Behavioral)
	port map( clk => CLK,
				 reset => WE,
				 sensor => B,
				 direction => B_dir,
				 ready => B_rdy);
	AnB <= resize(A_dir, AnB'length) + resize(B_dir, AnB'length);
	AnB_rdy <= A_rdy or B_rdy;
	PARKFREE <= PARKTOTAL - PARK_CNT;
	EMPTY <= '1' when PARK_CNT = 0 else '0' ;
	FULL <= '1' when PARK_CNT = PARKTOTAL else '0';

	count : process(AnB_rdy, WE) is --TODO: fix WE clock
	begin
		if WE = '1' then
			PARKTOTAL <= DIN;  --TODO: fix latch
			PARK_CNT <= (others => '0');
		elsif rising_edge(AnB_rdy) then
			PARK_CNT <= unsigned(signed(std_logic_vector(PARK_CNT)) + AnB);
		end if;
	end process count;

end Behavioral;

