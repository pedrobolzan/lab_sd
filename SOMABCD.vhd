----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:47:44 11/18/2022 
-- Design Name: 
-- Module Name:    SOMABCD - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SOMABCD is
	 Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           RESULT : out  STD_LOGIC_VECTOR (19 downto 0));
end SOMABCD;

architecture Behavioral of SOMABCD is

component SOMA1DIGITO
		port(A, B, Cin :in STD_LOGIC_VECTOR;
				RESULT, Cout: out STD_LOGIC_VECTOR);
	end component;

signal A1, A2, A3, A4, B1, B2, B3, B4, R1, R2, R3, R4, R5, Cin, C1, C2, C3:STD_LOGIC_VECTOR (3 downto 0);

begin

	A1 <= A(3) & A(2) & A(1) & A(0);
	A2 <= A(7) & A(6) & A(5) & A(4);
	A3 <= A(11) & A(10) & A(9) & A(8);
	A4 <= A(15) & A(14) & A(13) & A(12);
	B1 <= B(3) & B(2) & B(1) & B(0);
	B2 <= B(7) & B(6) & B(5) & B(4);
	B3 <= B(11) & B(10) & B(9) & B(8);
	B4 <= B(15) & B(14) & B(13) & B(12);
	Cin <= "0000";
	
	DIGITO1 : SOMA1DIGITO port map (A1, B1, Cin, R1, C1);
	DIGITO2 : SOMA1DIGITO port map (A2, B2, C1, R2, C2);
	DIGITO3 : SOMA1DIGITO port map (A3, B3, C2, R3, C3);
	DIGITO4 : SOMA1DIGITO port map (A4, B4, C3, R4, R5);
	
	RESULT <= R5 & R4 & R3 & R2 & R1;
	



end Behavioral;

