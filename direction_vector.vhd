library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

package direction_vector is
	Subtype direction is signed(1 downto 0);
	Type direction_vector is array (natural range <>) of direction;
	
	function SUM (signal dv : in direction_vector) return signed;

end direction_vector;

package body direction_vector is

	function SUM  (signal dv : in direction_vector) return signed is
		variable sum : signed(3 downto 0);
	begin
		sum := (others => '0');
		for i in 0 to (dv'length - 1) loop
			sum := sum + (resize(dv(i),sum'length));
		end loop;
		return sum; 
	end function SUM;
 
end direction_vector;
