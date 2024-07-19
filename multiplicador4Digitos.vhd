library IEEE;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

-- Declaração da entidade multiplicador4Digitos
entity multiplicador4Digitos is
    -- Portas de entrada e saída
    Port ( entradaA, entradaB : in  std_logic_vector (15 downto 0); 
           saida : out  std_logic_vector (31 downto 0)); 
end multiplicador4Digitos;

-- Arquitetura comportamental do multiplicador4Digitos
architecture Behavioral of multiplicador4Digitos is

	 -- Declaração do componente multiplicador1Digito
    component multiplicador1Digito
        port(entradaA, entradaB, carry_in : in std_logic_vector; 
            resultadoFinal, carry_out : out std_logic_vector); 
    end component;

    -- Sinais para armazenar os dígitos das entradas A e B
    signal digitoA1, digitoA2, digitoA3, 
        digitoA4, digitoB1, digitoB2, 
        digitoB3, digitoB4 : std_logic_vector (3 downto 0); 
		  
	 -- Sinais para armazenar os resultados parciais da multiplicação
    signal resultadoMultParcial1, resultadoMultParcial2, 
        resultadoMultParcial3, resultadoMultParcial4, 
        resultadoMultParcial5, resultadoMultParcial6, 
        resultadoMultParcial7, resultadoMultParcial8, 
        resultadoMultParcial9, resultadoMultParcial10, 
		resultadoMultParcial11, resultadoMultParcial12, 
        resultadoMultParcial13, resultadoMultParcial14, 
        resultadoMultParcial15, resultadoMultParcial16, 
        resultadoMultParcial17 : std_logic_vector (3 downto 0); 
		  
	-- Sinais para os valores de carry entre as etapas de multiplicação
	signal carry_in, carry_out1, carry_out2, carry_out3, 
			carry_out4, carry_out5, carry_out6, carry_out7, 
			carry_out8, carry_out9, carry_out10, carry_out11, 
			carry_out12, carry_out13, carry_out14, carry_out15 : 
			std_logic_vector (3 downto 0); 
			
	-- Sinais para armazenar os produtos parciais da multiplicação
	signal produtoParcial1, produtoParcial2, 
			produtoParcial3, produtoParcial4 : 
			std_logic_vector (31 downto 0);
	
	-- Sinal para armazenar o resultado da multiplicação sem considerar os carries
	signal resultadoMultiplicacaoSemCarry:unsigned (31 downto 0); 
	
	-- Sinais para os dígitos do resultado da multiplicação
	signal digitoResultado1, digitoResultado2, 
			digitoResultado3, digitoResultado4, 
			digitoResultado5, digitoResultado6, 
			digitoResultado7, digitoResultado8 : unsigned (3 downto 0); 
			
	-- Sinais para os dígitos do resultado final da multiplicação, após ajustes de carry
	signal digitoResultadoFinal1, digitoResultadoFinal2, 
			digitoResultadoFinal3, digitoResultadoFinal4, 
			digitoResultadoFinal5, digitoResultadoFinal6, 
			digitoResultadoFinal7, digitoResultadoFinal8 : unsigned (3 downto 0);
			
	-- Sinais para os valores de carry entre os dígitos do resultado
	signal carryDigito1, carryDigito2, 
			carryDigito3, carryDigito4, 
			carryDigito5, carryDigito6, 
			carryDigito7 : unsigned (3 downto 0) := "0000"; 
			
begin

	-- Atribui cada conjunto de 4 bits da entradaA a cada digitoA
	digitoA1 <= entradaA (3 downto 0);
	digitoA2 <= entradaA (7 downto 4);
	digitoA3 <= entradaA (11 downto 8);
	digitoA4 <= entradaA (15 downto 12);
	
	-- Atribui cada conjunto de 4 bits da entradaB a cada digitoB
	digitoB1 <= entradaB (3 downto 0);
	digitoB2 <= entradaB (7 downto 4);
	digitoB3 <= entradaB (11 downto 8);
	digitoB4 <= entradaB (15 downto 12);
	
	-- Inicializa o sinal carry_in com um vetor de 4 bits com todos os bits em 0
	carry_in <= "0000";

	-- Grupo de multiplicações parciais entre o dígito A1 e todos os dígitos de B (B1, B2, B3, B4)
   -- Cada multiplicação passa o carry_out da anterior como carry_in para a próxima
	multiplicacaoParcialDigitoA1ComB1 : multiplicador1Digito port map (digitoA1, digitoB1, 
																	  carry_in, resultadoMultParcial1, 
																	  carry_out1);
   multiplicacaoParcialDigitoA1ComB2 : multiplicador1Digito port map (digitoA1, digitoB2, 
																	  carry_out1, resultadoMultParcial2, 
																	  carry_out2);
	multiplicacaoParcialDigitoA1ComB3 : multiplicador1Digito port map (digitoA1, digitoB3, 
																	  carry_out2, resultadoMultParcial3, 
																	  carry_out3);
	multiplicacaoParcialDigitoA1ComB4 : multiplicador1Digito port map (digitoA1, digitoB4, 
																	  carry_out3, resultadoMultParcial4, 
																	  carry_out4);
																	  
	-- Grupo de multiplicações parciais entre o dígito A2 e todos os dígitos de B, 
	-- seguindo a mesma lógica de carry_in e carry_out
	multiplicacaoParcialDigitoA2ComB1 : multiplicador1Digito port map (digitoA2, digitoB1, 
																	  carry_out4, resultadoMultParcial5, 
																	  carry_out5);
	multiplicacaoParcialDigitoA2ComB2 : multiplicador1Digito port map (digitoA2, digitoB2, 
																	  carry_out5, resultadoMultParcial6, 
																	  carry_out6);
	multiplicacaoParcialDigitoA2ComB3 : multiplicador1Digito port map (digitoA2, digitoB3, 
																	  carry_out6, resultadoMultParcial7, 
																	  carry_out7);
	multiplicacaoParcialDigitoA2ComB4 : multiplicador1Digito port map (digitoA2, digitoB4, 
																	  carry_out7, resultadoMultParcial8, 
																	  carry_out8);
	
	-- Grupo de multiplicações parciais entre o dígito A3 e todos os dígitos de B, 
	-- com a mesma estratégia de propagação de carry
	multiplicacaoParcialDigitoA3ComB1 : multiplicador1Digito port map (digitoA3, digitoB1, 
																	  carry_out8, resultadoMultParcial9, 
																	  carry_out9);
	multiplicacaoParcialDigitoA3ComB2 : multiplicador1Digito port map (digitoA3, digitoB2, 
																	  carry_out9, resultadoMultParcial10, 
																	  carry_out10);
	multiplicacaoParcialDigitoA3ComB3 : multiplicador1Digito port map (digitoA3, digitoB3, 
																	  carry_out10, resultadoMultParcial11, 
																	  carry_out11);
	multiplicacaoParcialDigitoA3ComB4 : multiplicador1Digito port map (digitoA3, digitoB4, 
																	  carry_out11, resultadoMultParcial12, 
																	  carry_out12);
																	  
	-- Grupo de multiplicações parciais entre o dígito A4 e todos os dígitos de B, 
	-- continuando a cadeia de carry
	multiplicacaoParcialDigitoA4ComB1 : multiplicador1Digito port map (digitoA4, digitoB1, 
																	  carry_out12, resultadoMultParcial13, 
																	  carry_out13);
	multiplicacaoParcialDigitoA4ComB2 : multiplicador1Digito port map (digitoA4, digitoB2, 
																	  carry_out13, resultadoMultParcial14, 
																	  carry_out14);
	multiplicacaoParcialDigitoA4ComB3 : multiplicador1Digito port map (digitoA4, digitoB3, 
																	  carry_out14, resultadoMultParcial15, 
																	  carry_out15);
	multiplicacaoParcialDigitoA4ComB4 : multiplicador1Digito port map (digitoA4, digitoB4, 
																	  carry_out15, resultadoMultParcial16, 
																	  resultadoMultParcial17);	

	-- Construção dos produtos parciais, alinhando os resultados das multiplicações 
	-- parciais com zeros à esquerda ou à direita conforme necessário. 
	-- Cada produto parcial é construído concatenando 
	-- os resultados das multiplicações parciais com zeros para alinhamento.

	-- Produto parcial 1 é formado pela concatenação dos quatro primeiros 
	-- resultados parciais com zeros à esquerda para alinhamento
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

	-- Soma dos produtos parciais convertidos para unsigned para obter o 
	-- resultado da multiplicação sem considerar o carry
	resultadoMultiplicacaoSemCarry <= unsigned(produtoParcial1) + unsigned(produtoParcial2) + 
							   unsigned(produtoParcial3) + unsigned(produtoParcial4);
								
	-- Extração dos dígitos do resultado da multiplicação, dividindo 
	-- o resultado em 8 partes de 4 bits cada
	digitoResultado1 <= resultadoMultiplicacaoSemCarry(3 downto 0);
	digitoResultado2 <= resultadoMultiplicacaoSemCarry(7 downto 4);
	digitoResultado3 <= resultadoMultiplicacaoSemCarry(11 downto 8);
	digitoResultado4 <= resultadoMultiplicacaoSemCarry(15 downto 12);
	digitoResultado5 <= resultadoMultiplicacaoSemCarry(19 downto 16);
	digitoResultado6 <= resultadoMultiplicacaoSemCarry(23 downto 20);
	digitoResultado7 <= resultadoMultiplicacaoSemCarry(27 downto 24);
	digitoResultado8 <= resultadoMultiplicacaoSemCarry(31 downto 28);

	-- Processo para calcular o carry entre os dígitos do resultado da multiplicação
	-- Este processo ajusta cada dígito do resultado e propaga o carry se necessário

	-- Inicia o processo calculaCarryDigitos, que depende dos dígitos do resultado da multiplicação
	calculaCarryDigitos: process(digitoResultado1, digitoResultado2, 
				   				 digitoResultado3, digitoResultado4, 
				   				 digitoResultado5, digitoResultado6, 
				   				 digitoResultado7, digitoResultado8) is
	begin
		-- Verifica se o primeiro dígito excede o valor 9 (em binário "1001")
    	-- Se exceder, subtrai 10 (em binário "1010") e sinaliza um carry
    	-- Caso contrário, mantém o dígito e não sinaliza carry
		if digitoResultado1 > "1001" then
			digitoResultadoFinal1 <= digitoResultado1 - "1010";
			carryDigito1 <= "0001";
		else
			digitoResultadoFinal1 <= digitoResultado1;
		end if;					

		-- Repete o processo para os demais dígitos, considerando o carry do dígito anterior
    	-- Cada um é ajustado com base no seu valor e no carry recebido do anterior
    	-- Se o resultado da soma com o carry anterior exceder 9, ajusta o valor e propaga o carry
		if (digitoResultado2 + carryDigito1) > "1001" then
			digitoResultadoFinal2 <= digitoResultado2 + carryDigito1 - "1010";
			carryDigito2 <= "0001";
		else
			digitoResultadoFinal2 <= digitoResultado2 + carryDigito1;
		end if;		
		
		-- Continua o processo de ajuste e propagação de carry para os demais dígitos
		if (digitoResultado3 + carryDigito2) > "1001" then
			digitoResultadoFinal3 <= digitoResultado3 + carryDigito2 - "1010";
			carryDigito3 <= "0001";
		else
			digitoResultadoFinal3 <= digitoResultado3 + carryDigito2;
		end if;
		
		if (digitoResultado4 + carryDigito3) > "1001" then
			digitoResultadoFinal4 <= digitoResultado4 + carryDigito3 - "1010";
			carryDigito4 <= "0001";
		else
			digitoResultadoFinal4 <= digitoResultado4 + carryDigito3;
		end if;

		if (digitoResultado5 + carryDigito4) > "1001" then
			digitoResultadoFinal5 <= digitoResultado5 + carryDigito4 - "1010";
			carryDigito5 <= "0001";
		else
			digitoResultadoFinal5 <= digitoResultado5 + carryDigito4;
		end if;
		
		if (digitoResultado6 + carryDigito5) > "1001" then
			digitoResultadoFinal6 <= digitoResultado6 + carryDigito5 - "1010";
			carryDigito6 <= "0001";
		else
			digitoResultadoFinal6 <= digitoResultado6 + carryDigito5;
		end if;

		if (digitoResultado7 + carryDigito6) > "1001" then
			digitoResultadoFinal7 <= digitoResultado7 + carryDigito6 - "1010";
			carryDigito7 <= "0001";
		else
			digitoResultadoFinal7 <= digitoResultado7 + carryDigito6;
		end if;
		
		-- O último dígito é ajustado com o último carry, sem necessidade de verificar excedente
		digitoResultadoFinal8 <= digitoResultado8 + carryDigito7;
	end process;
	
	-- A saída é formada pela concatenação dos dígitos finais ajustados, 
	-- convertendo o resultado para std_logic_vector
	saida <= std_logic_vector(digitoResultadoFinal8 & digitoResultadoFinal7 & 
							  digitoResultadoFinal6 & digitoResultadoFinal5 & 
							  digitoResultadoFinal4 & digitoResultadoFinal3 & 
							  digitoResultadoFinal2 & digitoResultadoFinal1);

end Behavioral;