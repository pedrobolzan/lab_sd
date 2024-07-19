
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

-- Declaração da entidade maquinaEstados
entity maquinaEstados is
    Port (
        clk, reset, ps2d, -- Entradas: clk (clock), reset (reinicialização), ps2d (dado do teclado PS/2)
        ps2c, botao, operacao: in std_logic; -- ps2c (clock do teclado PS/2), botao (entrada de botão), operacao (seleciona a operação)
        fifo: out std_logic; -- Saída para um FIFO (First In, First Out)
        saida: out std_logic_vector(7 downto 0) 
        );
end maquinaEstados;

architecture Behavioral of maquinaEstados is


    -- Multiplica dois números de 4 dígitos (16 bits) e produz um resultado de 8 dígitos (32 bits).
    component multiplicador4Digitos
        port ( entradaA, entradaB : in std_logic_vector (15 downto 0); 
               saida : out  std_logic_vector (31 downto 0));
    end component;
    
    -- Soma dois números de 4 dígitos (16 bits) e produz um resultado de 5 dígitos (20 bits).
    component soma4Digitos
        port ( entradaA, entradaB : in std_logic_vector (15 downto 0); 
               soma : out std_logic_vector (19 downto 0));
    end component;
     
    -- Recebe um sinal de clock e produz um sinal de clock dividido, com frequência menor.
    component divisorClock
            port(clockOriginal : in std_logic; -- Entrada de clock original
                 clockDividido : out std_logic); -- Saída de clock dividido
    end component;
	
    -- Sinais para armazenar dígitos individuais das entradas A e B, e buffers para manipulação de dígitos
    signal entradaADigito0, entradaADigito1, 
           entradaADigito2, entradaADigito3, 
           entradaBDigito0, entradaBDigito1, 
           entradaBDigito2, entradaBDigito3, 
           bufferDigito0, bufferDigito1, 
           bufferDigito2, bufferDigito3: 
           std_logic_vector (3 downto 0):= "1111";
    
    -- Sinais para representar as entradas A e B completas, inicializados com zeros
    signal entradaA, entradaB : 
           std_logic_vector(15 downto 0) := (others => '0');
    
    -- Declaração de um tipo enumerado para representar as etapas de operação da máquina de estados
    type tipoEtapa is (digito0, digito1, 
                       digito2, digito3, 
                       mudaDigito, stop);
    
    -- Sinal para controlar a etapa atual da máquina de estados, inicializado em digito0
    signal etapa : tipoEtapa := digito0;
    
    -- Sinal para armazenar o código numérico atual, utilizado para processamento de entrada ou saída
    signal number_code : std_logic_vector (7 downto 0);
    
    -- Sinais de controle para seleção de entrada, indicação de fim de operação, e outros sinais de controle e estado
    signal selecaoEntrada, fim : STD_LOGIC := '0';
    signal kb_buf_empty, rd_key_code, clockDividido: std_logic; 
    
    -- Sinais para armazenar os resultados das operações, inicializados com zeros
    signal resultado, resultadoFinal : std_logic_vector(31 downto 0):= (others => '0');
    signal resultado2 : std_logic_vector(19 downto 0);
    
    -- Declaração de um tipo enumerado para representar as etapas da máquina de estados
    type tipoEtapaMaquina is (etapa1, etapa2, etapa3, etapa4);
    
    -- Sinal para controlar a etapa atual da máquina de estados
    signal maqEstad : tipoEtapaMaquina;

begin	

	-- Instanciação do componente kb_code, realiza a lógica de decodificação de teclas do teclado
    keyboard: entity work.kb_code(arch)
          port map(
                clk, reset: in  std_logic; 
                ps2d, ps2c: in  std_logic; 
                rd_key_code: in std_logic; 
                number_code: out std_logic_vector(7 downto 0); 
                kb_buf_empty: out std_logic 
                );
            
    -- Indica se o buffer do teclado está vazio ou não, para controlar o fluxo de dados
    fifo <= kb_buf_empty;

	process (clk)
    -- Processo que introduz cada digito inserido no teclado no buffer, e 
    -- entao passa do buffer para o digito de entrada A ou B, de acordo com 
    -- a variavel selecaoEntrada
		begin
			if rising_edge (clk) then
				if kb_buf_empty = '0' then
					case etapa is
					when digito0 =>				
						bufferDigito0 <= number_code(3 downto 0);
						
						if selecaoEntrada = '0' then
							entradaADigito0 <= bufferDigito0;
						else
							entradaBDigito0 <= bufferDigito0;
						end if;

						if botao = '1' then
							rd_key_code <= '1';
							if bufferDigito0 = "1101" then
								etapa <= mudaDigito;
							else
								etapa <= digito1;
							end if;
						end if;

					when digito1 =>
						bufferDigito1 <= number_code(3 downto 0);
						
						if selecaoEntrada = '0' then
							entradaADigito1 <= bufferDigito1;
						else
							entradaBDigito1 <= bufferDigito1;
						end if;

						if botao = '1' then
							rd_key_code <= '1';
							if bufferDigito1 = "1101" then
								etapa <= mudaDigito;
							else
								etapa <= digito2;
							end if;
						end if;

					when digito2 =>
						bufferDigito2 <= number_code(3 downto 0);
						
						if selecaoEntrada = '0' then
							entradaADigito2 <= bufferDigito2;
						else
							entradaBDigito2 <= bufferDigito2;
						end if;

						if botao = '1' then
							rd_key_code <= '1';
							if bufferDigito2 = "1101" then
								etapa <= mudaDigito;
							else
								etapa <= digito3;
							end if;
						end if;

					when digito3 =>
						bufferDigito3 <= number_code(3 downto 0);
						
						if selecaoEntrada = '0' then
							entradaADigito3 <= bufferDigito3;
						else
							entradaBDigito3 <= bufferDigito3;
						end if;

						if botao = '1' then
							rd_key_code <= '1';
							etapa <= mudaDigito;
						end if;

					when mudaDigito =>
						if selecaoEntrada = '0' then
							selecaoEntrada <= '1';
							etapa <= digito0;
						else
							etapa <= stop;
						end if;

					when stop =>
						fim <= '1';
					end case;
				
				else
					rd_key_code <= '0';
				end if;
			end if;
			
	end process;
	
	process (clk)
        -- Processo que realiza a montagem da entrada A e B de acordo com todos os digitos
        -- Atribui as entradas deslocadas e concatenadas com os digitos
		begin
			if fim = '1' then
				if entradaADigito1 = "1101" then
						entradaA <= entradaA(15 downto 4) & entradaADigito0;

				elsif entradaADigito2 = "1101" then
						entradaA <= entradaA(15 downto 8) & 
                                    entradaADigito0 & entradaADigito1;

				elsif entradaADigito3 = "1101" then
						entradaA <= entradaA(15 downto 12) & 
                                    entradaADigito0 & entradaADigito1 & 
                                    entradaADigito2;

				else
					entradaA <= entradaADigito0 & entradaADigito1 & 
                                entradaADigito2 & entradaADigito3;
				end if;
				
				if entradaBDigito1 = "1101" then
						entradaB <= entradaB(15 downto 4) & entradaBDigito0;

				elsif entradaBDigito2 = "1101" then
						entradaB <= entradaB(15 downto 8) & entradaBDigito0 & 
                                    entradaBDigito1;

				elsif entradaBDigito3 = "1101" then
						entradaB <= entradaB(15 downto 12) & entradaBDigito0 & 
                                    entradaBDigito1 & entradaBDigito2;
                                    
				else
					entradaB <= entradaBDigito0 & entradaBDigito1 & 
                                entradaBDigito2 & entradaBDigito3;
				end if;

			end if;
			
	end process;
	
	calculaMultiplicacao : multiplicador4Digitos port map (entradaA, entradaB, resultado);
	calculaSomoa : soma4Digitos port map (entradaA, entradaB, resultado2);
	
	selecionaOperacao : process (operacao) is
    -- Processo que observa a selecao de operacao
		begin
			if operacao = '1' then
                -- Se operação='1', atribui o resultado da multiplicação ao resultadoFinal
				resultadoFinal <= resultado;
			else
                -- Se operação='0', atribui o resultado da soma ao resultadoFinal
                resultadoFinal(19 downto 0) <= resultado2;
			end if;
		end process;
		
	calculaClockDivido : divisorClock port map (clk, clockDividido);
	
    -- A cada borda de subida do clock dividido, avança a máquina de estados 
    --para exibir uma parte do resultado
	maquinaEstadosPrincipal : process (clockDividido) is
		begin
			if rising_edge (clockDivido) then
				case maqEstad is 
					when etapa1 =>
						saida <= resultadoFinal(31 downto 24);
						maqEstad <= etapa2;
					when etapa2 =>	
						saida <= resultadoFinal(23 downto 16);
						maqEstad <= etapa3;
					when etapa3 =>	
						saida <= resultadoFinal(15 downto 8);
						maqEstad <= etapa4;
					when etapa4 =>
						saida <= resultadoFinal(7 downto 0);
						maqEstad <= etapa1;
					when others => 
						maqEstad <= etapa1;
				end case;
			end if;
		end process;
		
end Behavioral;



