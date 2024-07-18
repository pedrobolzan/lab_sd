----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:09:14 11/18/2022 
-- Design Name: 
-- Module Name:    multiplicador4Digitos - Behavioral 
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

entity multiplicador4Digitos is
    Port ( entradaA, entradaB : in  std_logic_vector (15 downto 0);
           resultadoMultiplicacao : out  std_logic_vector (31 downto 0));
end multiplicador4Digitos;

architecture Behavioral of multiplicador4Digitos is

component multiplicadorDigito
	port(entradaA, entradaB, carry_in : in std_logic_vector;
		 resultadoMultiplicacao, carry_out : out std_logic_vector);			
end component;

signal digitoA1, digitoA2, digitoA3, 
	   digitoA4, digitoB1, digitoB2, 
	   digitoB3, digitoB4 : std_logic_vector (3 downto 0);

signal resultadoMultParcial1, resultadoMultParcial2, 
	   resultadoMultParcial3, resultadoMultParcial4, 
	   resultadoMultParcial5, resultadoMultParcial6, 
	   resultadoMultParcial7, resultadoMultParcial8, 
	   resultadoMultParcial9, resultadoMultParcial10, 
	   resultadoMultParcial11, resultadoMultParcial12, 
	   resultadoMultParcial13, resultadoMultParcial14, 
	   resultadoMultParcial15, resultadoMultParcial16, 
	   resultadoMultParcial17 : std_logic_vector (3 downto 0);

signal carry_in, carry_out1, carry_out2, carry_out3, 
	   carry_out4, carry_out5, carry_out6, carry_out7, 
	   carry_out8, carry_out9, carry_out10, carry_out11, 
	   carry_out12, carry_out13, carry_out14, carry_out15 : 
	   std_logic_vector (3 downto 0);

signal produtoParcial1, produtoParcial2, 
	   produtoParcial3, produtoParcial4 : 
	   std_logic_vector (31 downto 0);

signal resultadoMultiplicacaoa:unsigned (31 downto 0);

signal digitoResultadoFinal1, digitoResultadoFinal2, 
	   digitoResultadoFinal3, digitoResultadoFinal4, 
	   digitoResultadoFinal5, digitoResultadoFinal6, 
	   digitoResultadoFinal7, digitoResultadoFinal8 : unsigned (3 downto 0);

signal digitoResultadoFinal12, digitoResultadoFinal22, 
	   digitoResultadoFinal32, digitoResultadoFinal42, 
	   digitoResultadoFinal52, digitoResultadoFinal62, 
	   digitoResultadoFinal72, digitoResultadoFinal82 : unsigned (3 downto 0);

signal digitoResultadoFinal1C, digitoResultadoFinal2C, 
	   digitoResultadoFinal3C, digitoResultadoFinal4C, 
	   digitoResultadoFinal5C, digitoResultadoFinal6C, 
	   digitoResultadoFinal7C:unsigned (3 downto 0) := "0000";

begin

	digitoA1 <= entradaA (3 downto 0);
	digitoA2 <= entradaA (7 downto 4);
	digitoA3 <= entradaA (11 downto 8);
	digitoA4 <= entradaA (15 downto 12);

	digitoB1 <= entradaB (3 downto 0);
	digitoB2 <= entradaB (7 downto 4);
	digitoB3 <= entradaB (11 downto 8);
	digitoB4 <= entradaB (15 downto 12);

	carry_in <= "0000";

	-- Multiplication of digit A1 with all B digits
	multiplicacaoParcialDigitoA1ComB1 : multiplicadorDigito port map (digitoA1, digitoB1, 
																	  carry_in, resultadoMultParcial1, 
																	  carry_out1);
	multiplicacaoParcialDigitoA1ComB2 : multiplicadorDigito port map (digitoA1, digitoB2, 
																	  carry_out1, resultadoMultParcial2, 
																	  carry_out2);
	multiplicacaoParcialDigitoA1ComB3 : multiplicadorDigito port map (digitoA1, digitoB3, 
																	  carry_out2, resultadoMultParcial3, 
																	  carry_out3);
	multiplicacaoParcialDigitoA1ComB4 : multiplicadorDigito port map (digitoA1, digitoB4, 
																	  carry_out3, resultadoMultParcial4, 
																	  carry_out4);
	
	-- Multiplication of digit A2 with all B digits
	multiplicacaoParcialDigitoA2ComB1 : multiplicadorDigito port map (digitoA2, digitoB1, 
																	  carry_out4, resultadoMultParcial5, 
																	  carry_out5);
	multiplicacaoParcialDigitoA2ComB2 : multiplicadorDigito port map (digitoA2, digitoB2, 
																	  carry_out5, resultadoMultParcial6, 
																	  carry_out6);
	multiplicacaoParcialDigitoA2ComB3 : multiplicadorDigito port map (digitoA2, digitoB3, 
																	  carry_out6, resultadoMultParcial7, 
																	  carry_out7);
	multiplicacaoParcialDigitoA2ComB4 : multiplicadorDigito port map (digitoA2, digitoB4, 
																	  carry_out7, resultadoMultParcial8, 
																	  carry_out8);
	
	-- Multiplication of digit A3 with all B digits
	multiplicacaoParcialDigitoA3ComB1 : multiplicadorDigito port map (digitoA3, digitoB1, 
																	  carry_out8, resultadoMultParcial9, 
																	  carry_out9);
	multiplicacaoParcialDigitoA3ComB2 : multiplicadorDigito port map (digitoA3, digitoB2, 
																	  carry_out9, resultadoMultParcial10, 
																	  carry_out10);
	multiplicacaoParcialDigitoA3ComB3 : multiplicadorDigito port map (digitoA3, digitoB3, 
																	  carry_out10, resultadoMultParcial11, 
																	  carry_out11);
	multiplicacaoParcialDigitoA3ComB4 : multiplicadorDigito port map (digitoA3, digitoB4, 
																	  carry_out11, resultadoMultParcial12, 
																	  carry_out12);
	
	-- Multiplication of digit A4 with all B digits
	multiplicacaoParcialDigitoA4ComB1 : multiplicadorDigito port map (digitoA4, digitoB1, 
																	  carry_out12, resultadoMultParcial13, 
																	  carry_out13);
	multiplicacaoParcialDigitoA4ComB2 : multiplicadorDigito port map (digitoA4, digitoB2, 
																	  carry_out13, resultadoMultParcial14, 
																	  carry_out14);
	multiplicacaoParcialDigitoA4ComB3 : multiplicadorDigito port map (digitoA4, digitoB3, 
																	  carry_out14, resultadoMultParcial15, 
																	  carry_out15);
	multiplicacaoParcialDigitoA4ComB4 : multiplicadorDigito port map (digitoA4, digitoB4, 
																	  carry_out15, resultadoMultParcial16, 
																	  resultadoMultParcial17);
	
	produtoParcial1 <= "0000000000000000" & resultadoMultParcial4 & 
				       resultadoMultParcial3 & resultadoMultParcial2 & 
					   resultadoMultParcial1;
	produtoParcial2 <= "000000000000" & resultadoMultParcial8 & 
					    resultadoMultParcial7 & resultadoMultParcial6 & 
						resultadoMultParcial5 & "0000";
	produtoParcial3 <= "00000000" & resultadoMultParcial12 & 
					    resultadoMultParcial11 & resultadoMultParcial10 & 
						resultadoMultParcial9 & "00000000";
	produtoParcial4 <= resultadoMultParcial17 & resultadoMultParcial16 & 
					   resultadoMultParcial15 & resultadoMultParcial14 & 
					   resultadoMultParcial13 & "000000000000";
	
	resultadoMultiplicacaoa <= unsigned(produtoParcial1) + unsigned(produtoParcial2) + 
							   unsigned(produtoParcial3) + unsigned(produtoParcial4);
	
	digitoResultadoFinal1 <= resultadoMultiplicacaoa(3 downto 0);
	digitoResultadoFinal2 <= resultadoMultiplicacaoa(7 downto 4);
	digitoResultadoFinal3 <= resultadoMultiplicacaoa(11 downto 8);
	digitoResultadoFinal4 <= resultadoMultiplicacaoa(15 downto 12);
	digitoResultadoFinal5 <= resultadoMultiplicacaoa(19 downto 16);
	digitoResultadoFinal6 <= resultadoMultiplicacaoa(23 downto 20);
	digitoResultadoFinal7 <= resultadoMultiplicacaoa(27 downto 24);
	digitoResultadoFinal8 <= resultadoMultiplicacaoa(31 downto 28);
	
	calculaCarryDigitos: process(digitoResultadoFinal1, digitoResultadoFinal2, 
				   				 digitoResultadoFinal3, digitoResultadoFinal4, 
				   				 digitoResultadoFinal5, digitoResultadoFinal6, 
				   				 digitoResultadoFinal7, digitoResultadoFinal8) is
	begin
		if digitoResultadoFinal1 > "1001" then
			digitoResultadoFinal12 <= digitoResultadoFinal1 - "1010";
			digitoResultadoFinal1C <= "0001";
		else
			digitoResultadoFinal12 <= digitoResultadoFinal1;
		end if;

		if (digitoResultadoFinal2 + digitoResultadoFinal1C) > "1001" then
			digitoResultadoFinal22 <= digitoResultadoFinal2 + digitoResultadoFinal1C - "1010";
			digitoResultadoFinal2C <= "0001";
		else
			digitoResultadoFinal22 <= digitoResultadoFinal2 + digitoResultadoFinal1C;
		end if;

		if (digitoResultadoFinal3 + digitoResultadoFinal2C) > "1001" then
			digitoResultadoFinal32 <= digitoResultadoFinal3 + digitoResultadoFinal2C - "1010";
			digitoResultadoFinal3C <= "0001";
		else
			digitoResultadoFinal32 <= digitoResultadoFinal3 + digitoResultadoFinal2C;
		end if;

		if (digitoResultadoFinal4 + digitoResultadoFinal3C) > "1001" then
			digitoResultadoFinal42 <= digitoResultadoFinal4 + digitoResultadoFinal3C - "1010";
			digitoResultadoFinal4C <= "0001";
		else
			digitoResultadoFinal42 <= digitoResultadoFinal4 + digitoResultadoFinal3C;
		end if;

		if (digitoResultadoFinal5 + digitoResultadoFinal4C) > "1001" then
			digitoResultadoFinal52 <= digitoResultadoFinal5 + digitoResultadoFinal4C - "1010";
			digitoResultadoFinal5C <= "0001";
		else
			digitoResultadoFinal52 <= digitoResultadoFinal5 + digitoResultadoFinal4C;
		end if;

		if (digitoResultadoFinal6 + digitoResultadoFinal5C) > "1001" then
			digitoResultadoFinal62 <= digitoResultadoFinal6 + digitoResultadoFinal5C - "1010";
			digitoResultadoFinal6C <= "0001";
		else
			digitoResultadoFinal62 <= digitoResultadoFinal6 + digitoResultadoFinal5C;
		end if;

		if (digitoResultadoFinal7 + digitoResultadoFinal6C) > "1001" then
			digitoResultadoFinal72 <= digitoResultadoFinal7 + digitoResultadoFinal6C - "1010";
			digitoResultadoFinal7C <= "0001";
		else
			digitoResultadoFinal72 <= digitoResultadoFinal7 + digitoResultadoFinal6C;
		end if;

		digitoResultadoFinal82 <= digitoResultadoFinal8 + digitoResultadoFinal7C;
	end process;
	
	resultadoMultiplicacao <= std_logic_vector(digitoResultadoFinal82 & digitoResultadoFinal72 & 
											   digitoResultadoFinal62 & digitoResultadoFinal52 & 
											   digitoResultadoFinal42 & digitoResultadoFinal32 & 
											   digitoResultadoFinal22 & digitoResultadoFinal12);

end Behavioral;

