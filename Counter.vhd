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

begin


end Behavioral;

