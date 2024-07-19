library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity Soma4Digitos is
		Port ( entradaA : in  STD_LOGIC_VECTOR (15 downto 0);
             entradaB : in  STD_LOGIC_VECTOR (15 downto 0);
             soma : out STD_LOGIC_VECTOR (19 downto 0) := (others => '0'));
end Soma4Digitos;

architecture Behavioral of Soma4Digitos is

	component somaDigito
		port(entradaA, entradaB : in STD_LOGIC_VECTOR (3 downto 0);
				carry_in : in STD_LOGIC_VECTOR (3 downto 0);
				carry_out : out STD_LOGIC_VECTOR (3 downto 0);
				soma: out STD_LOGIC_VECTOR (3 downto 0));
	end component;
	
	-- Sinais internos para armazenar os dígitos das entradas, os resultados parciais e os carries
	signal digitoA1, digitoA2, 
			 digitoA3, digitoA4, 
			 digitoB1, digitoB2, 
			 digitoB3, digitoB4, 
			 digitoResult1, digitoResult2, 
			 digitoResult3, digitoResult4, 
			 digitoResult5, carry_in, 
		     carry_out1, carry_out2, 
			 carry_out3 : STD_LOGIC_VECTOR (3 downto 0);

begin
	
	-- Atribuição dos dígitos das entradas A e B a partir dos vetores de entrada
	digitoA1 <= entradaA(3 downto 0);
	digitoA2 <= entradaA(7 downto 4);
	digitoA3 <= entradaA(11 downto 8);
	digitoA4 <= entradaA(15 downto 12);
	digitoB1 <= entradaB(3 downto 0);
	digitoB2 <= entradaB(7 downto 4);
	digitoB3 <= entradaB(11 downto 8);
	digitoB4 <= entradaB(15 downto 12);

	carry_in <= "0000";
	
	-- Instanciações do componente somaDigito para realizar as somas parciais dos dígitos
	somaParcial1 : somaDigito port map (digitoA1, digitoB1, 
												   carry_in, carry_out1,
													digitoResult1);
													
	somaParcial2 : somaDigito port map (digitoA2, digitoB2, 
													carry_out1, carry_out2,
													digitoResult2);
													
	somaParcial3 : somaDigito port map (digitoA3, digitoB3, 
													carry_out2, carry_out3, 
													digitoResult3);
													
	somaParcial4 : somaDigito port map (digitoA4, digitoB4, 
												   carry_out3, digitoResult5, 
													digitoResult4);
	
	-- Concatenação dos resultados parciais e do carry final para formar o resultado da soma total
	soma <= digitoResult5 & digitoResult4 & 
			  digitoResult3 & digitoResult2 & 
			  digitoResult1;

end Behavioral;