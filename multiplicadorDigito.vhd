library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Declaração da entidade multiplicador1Digito
entity multiplicador1Digito is
    Port ( entradaA, entradaB, carry_in : in std_logic_vector (3 downto 0);
		   carry_out, resultadoFinal : out std_logic_vector (3 downto 0));
end multiplicador1Digito;

architecture Behavioral of multiplicador1Digito is

	-- Sinal para armazenar o resultado parcial da multiplicação mais adição do carry_in
	signal resultadoParcial: unsigned (7 downto 0) := "00000000";
	-- Sinal auxiliar para armazenar o resultado da operação
	signal aux : unsigned (7 downto 0) := "00000000" ;

begin
	
	-- Multiplicação das entradas convertidas para 
	-- unsigned e adição do carry_in também convertido para unsigned
	aux <= (unsigned(entradaA) * unsigned(entradaB)) + unsigned(carry_in);
	
	-- Ajusta o resultado da multiplicação e adição do carry_in com base em faixas de valores
	-- Determina o carry_out e ajusta o resultadoParcial com base no valor de aux
	-- O processo inicia sempre que há uma mudança no sinal aux
	calculaCarry: process(aux) is
	begin
		-- Verifica se aux é maior ou igual a 80 (em binário "01010000")
		-- Se verdadeiro, ajusta carry_out para 8 (em binário "1000") e subtrai 80 
		if aux >= "01010000" then
			carry_out <= "1000";
			resultadoParcial <= aux - "01010000";

		-- Verifica se aux está entre 70 (inclusive) e 80 (exclusive)
		elsif "01000110" <= aux and aux < "01010000" then
			carry_out <= "0111";
			resultadoParcial <= aux - "01000110";

		-- Continua a verificação em faixas decrescentes de 10 em 10 até 10
		elsif "00111100" <= aux and aux < "01000110" then
			carry_out <= "0110";
			resultadoParcial <= aux - "00111100";

		elsif "00110010" <= aux and aux < "00111100" then
			carry_out <= "0101";
			resultadoParcial <= aux - "00110010";

		elsif "00101000" <= aux and aux < "00110010" then
			carry_out <= "0100";
			resultadoParcial <= aux - "00101000";

		elsif "00011110" <= aux and aux < "00101000" then
			carry_out <= "0011";
			resultadoParcial <= aux - "00011110";

		elsif "00010100" <= aux and aux < "00011110" then
			carry_out <= "0010";
			resultadoParcial <= aux - "00010100";

		elsif "00001010" <= aux and aux < "00010100" then
			carry_out <= "0001";
			resultadoParcial <= aux - "00001010";

		-- Se aux é menor que 10, não há carry_out e resultadoParcial é igual a aux
		else
			carry_out <= "0000";
			resultadoParcial <= aux;
		end if;
	end process;
	
	-- Atribui os 4 bits menos significativos de resultadoParcial ao resultadoFinal, 
	-- convertendo para std_logic_vector
	resultadoFinal <= std_logic_vector(resultadoParcial(3 downto 0));	
	
	end Behavioral;

