----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:14 11/18/2022 
-- Design Name: 
-- Module Name:    MULTIPLICACAOBCD - Behavioral 
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
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MULTIPLICACAOBCD is
    Port ( A : in  STD_LOGIC_VECTOR (15 downto 0);
           B : in  STD_LOGIC_VECTOR (15 downto 0);
           RESULT : out  STD_LOGIC_VECTOR (31 downto 0));
end MULTIPLICACAOBCD;

architecture Behavioral of MULTIPLICACAOBCD is

component MULTIPLICACAO1DIGITO
		port(A, B, Cin :in STD_LOGIC_VECTOR;
				RESULT, Cout: out STD_LOGIC_VECTOR);
	end component;

signal A1, A2, A3, A4, B1, B2, B3, B4:STD_LOGIC_VECTOR (3 downto 0);
signal R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R16, R17:STD_LOGIC_VECTOR (3 downto 0);
signal Cin, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10, C11, C12, C13, C14, C15:STD_LOGIC_VECTOR (3 downto 0);
signal P1, P2, P3, P4:STD_LOGIC_VECTOR (31 downto 0);
signal resulta:unsigned (31 downto 0);
signal D1, D2, D3, D4, D5, D6, D7, D8:unsigned (3 downto 0);
signal D12, D22, D32, D42, D52, D62, D72, D82:unsigned (3 downto 0);
signal D1C, D2C, D3C, D4C, D5C, D6C, D7C:unsigned (3 downto 0):="0000";

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
	
	DIGITO1 : MULTIPLICACAO1DIGITO port map (A1, B1, Cin, R1, C1);
	DIGITO2 : MULTIPLICACAO1DIGITO port map (A1, B2, C1, R2, C2);
	DIGITO3 : MULTIPLICACAO1DIGITO port map (A1, B3, C2, R3, C3);
	DIGITO4 : MULTIPLICACAO1DIGITO port map (A1, B4, C3, R4, C4);
	
	DIGITO5 : MULTIPLICACAO1DIGITO port map (A2, B1, C4, R5, C5);
	DIGITO6 : MULTIPLICACAO1DIGITO port map (A2, B2, C5, R6, C6);
	DIGITO7 : MULTIPLICACAO1DIGITO port map (A2, B3, C6, R7, C7);
	DIGITO8 : MULTIPLICACAO1DIGITO port map (A2, B4, C7, R8, C8);
	
	DIGITO9 : MULTIPLICACAO1DIGITO port map (A3, B1, C8, R9, C9);
	DIGITO10 : MULTIPLICACAO1DIGITO port map (A3, B2, C9, R10, C10);
	DIGITO11 : MULTIPLICACAO1DIGITO port map (A3, B3, C10, R11, C11);
	DIGITO12 : MULTIPLICACAO1DIGITO port map (A3, B4, C11, R12, C12);
	
	DIGITO13 : MULTIPLICACAO1DIGITO port map (A4, B1, C12, R13, C13);
	DIGITO14 : MULTIPLICACAO1DIGITO port map (A4, B2, C13, R14, C14);
	DIGITO15 : MULTIPLICACAO1DIGITO port map (A4, B3, C14, R15, C15);
	DIGITO16 : MULTIPLICACAO1DIGITO port map (A4, B4, C15, R16, R17);
	
	P1 <= "0000000000000000" & R4 & R3 & R2 & R1;
	P2 <= "000000000000" & R8 & R7 & R6 & R5 & "0000";
	P3 <= "00000000" & R12 & R11 & R10 & R9 & "00000000";
	P4 <= R17 & R16 & R15 & R14 & R13 & "000000000000";
	
	resulta <= unsigned(P1) + unsigned(P2) + unsigned(P3) + unsigned(P4);
	
	D1 <= resulta(3) & resulta(2) & resulta(1) & resulta(0);
	D2 <= resulta(7) & resulta(6) & resulta(5) & resulta(4);
	D3 <= resulta(11) & resulta(10) & resulta(9) & resulta(8);
	D4 <= resulta(15) & resulta(14) & resulta(13) & resulta(12);
	D5 <= resulta(19) & resulta(18) & resulta(17) & resulta(16);
	D6 <= resulta(23) & resulta(22) & resulta(21) & resulta(20);
	D7 <= resulta(27) & resulta(26) & resulta(25) & resulta(24);
	D8 <= resulta(31) & resulta(30) & resulta(29) & resulta(28);
	
	CARRY: process(D1, D2, D3, D4, D5, D6, D7, D8) is
	begin
		if D1 > "1001" then
			D12 <= D1 - "1010";
			D1C <= "0001";
		else
			D12 <= D1;
		end if;
		if (D2 + D1C) > "1001" then
			D22 <= D2 + D1C - "1010";
			D2C <= "0001";
		else
			D22 <= D2 + D1C;
		end if;
		if (D3 + D2C) > "1001" then
			D32 <= D3 + D2C - "1010";
			D3C <= "0001";
		else
			D32 <= D3 + D2C;
		end if;
		if (D4 + D3C) > "1001" then
			D42 <= D4 + D3C - "1010";
			D4C <= "0001";
		else
			D42 <= D4 + D3C;
		end if;
		if (D5 + D4C) > "1001" then
			D52 <= D5 + D4C - "1010";
			D5C <= "0001";
		else
			D52 <= D5 + D4C;
		end if;
		if (D6 + D5C) > "1001" then
			D62 <= D6 + D5C - "1010";
			D6C <= "0001";
		else
			D62 <= D6 + D5C;
		end if;
		if (D7 + D6C) > "1001" then
			D72 <= D7 + D6C - "1010";
			D7C <= "0001";
		else
			D72 <= D7 + D6C;
		end if;
		D82 <= D8 + D7C;
	end process;
	
	RESULT <= std_logic_vector(D82 & D72 & D62 & D52 & D42 & D32 & D22 & D12);

end Behavioral;

