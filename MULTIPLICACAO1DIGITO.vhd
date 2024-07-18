----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:30:08 11/18/2022 
-- Design Name: 
-- Module Name:    MULTIPLICACAO1DIGITO - Behavioral 
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

entity MULTIPLICACAO1DIGITO is
    Port ( A : in  STD_LOGIC_VECTOR (3 downto 0);
           B : in  STD_LOGIC_VECTOR (3 downto 0);
			  Cin : in  STD_LOGIC_VECTOR (3 downto 0);
			  Cout : out  STD_LOGIC_VECTOR (3 downto 0);
           RESULT : out  STD_LOGIC_VECTOR (3 downto 0));
end MULTIPLICACAO1DIGITO;

architecture Behavioral of MULTIPLICACAO1DIGITO is

signal resulta:unsigned (7 downto 0):="00000000";
signal resulta2:unsigned (7 downto 0):="00000000";
--signal couta:unsigned (3 downto 0):="0000";
--signal resulta4:STD_LOGIC_VECTOR (3 downto 0);	

begin

	resulta2 <= (unsigned(A)*unsigned(B)) + unsigned(Cin);
	
	MULTI: process(resulta2) is
	begin
		if resulta2 >= "01010000" then --80
			Cout <= "1000";
			resulta <= resulta2 - "01010000";
		elsif "01000110" <= resulta2 and resulta2 < "01010000" then --70
			Cout <= "0111";
			resulta <= resulta2 - "01000110";
		elsif "00111100" <= resulta2 and resulta2 < "01000110" then --60
			Cout <= "0110";
			resulta <= resulta2 - "00111100";
		elsif "00110010" <= resulta2 and resulta2 < "00111100" then --50
			Cout <= "0101";
			resulta <= resulta2 - "00110010";
		elsif "00101000" <= resulta2 and resulta2 < "00110010" then --40
			Cout <= "0100";
			resulta <= resulta2 - "00101000";
		elsif "00011110" <= resulta2 and resulta2 < "00101000" then --30
			Cout <= "0011";
			resulta <= resulta2 - "00011110";
		elsif "00010100" <= resulta2 and resulta2 < "00011110" then --20
			Cout <= "0010";
			resulta <= resulta2 - "00010100";
		elsif "00001010" <= resulta2 and resulta2 < "00010100" then --10
			Cout <= "0001";
			resulta <= resulta2 - "00001010";
		else
			Cout <= "0000";
			resulta <= resulta2;
		end if;
	end process;
	
	RESULT <= resulta(3) & resulta(2) & resulta(1) & resulta(0);	

end Behavioral;



