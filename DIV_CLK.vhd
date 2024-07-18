----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:24:59 10/07/2022 
-- Design Name: 
-- Module Name:    DIVISORCLOCK - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity DIVISORCLOCK is
    Port ( CLK50: in  STD_LOGIC;
           CLK : out  STD_LOGIC);
end DIVISORCLOCK;

architecture Behavioral of DIVISORCLOCK is

	
	signal CLKATUAL : STD_LOGIC;

begin
	GENERATECLK : process (CLK50)
	variable CONTADOR : INTEGER := 0;
	begin			
		if rising_edge(CLK50) then
			if CONTADOR = 175000000 then
				CLKATUAL <= not CLKATUAL;
				CONTADOR := 0;
				
			else
				CONTADOR := CONTADOR + 1;
			end if;
		end if;
	end process GENERATECLK;
	
	CLK <= CLKATUAL;

end Behavioral;

