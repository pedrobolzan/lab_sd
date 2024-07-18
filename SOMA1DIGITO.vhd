----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:30:53 11/18/2022 
-- Design Name: 
-- Module Name:    SOMA1DIGITO - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SOMA1DIGITO is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
           Cin : in  STD_LOGIC_VECTOR (3 downto 0);
           Cout : out  STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out  STD_LOGIC_VECTOR (3 downto 0));
end SOMA1DIGITO;

architecture Behavioral of SOMA1DIGITO is

signal resulta:unsigned (3 downto 0):="0000";
signal resulta2:unsigned (3 downto 0):="0000";

begin

	resulta2 <= unsigned(A) + unsigned(B) + unsigned(Cin);
	
	SOMA: process(resulta2) is
	begin
		if resulta2 >= "1010" then
			Cout <= "0001";
			resulta <= resulta2 - "1010";
		else
			Cout <= "0000";
			resulta <= resulta2;
		end if;
	end process;
	RESULT <= std_logic_vector(resulta);

end Behavioral;

