library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Declaração da entidade kb_code, que representa um decodificador de códigos de teclado PS/2.
entity kb_code is
   generic(W_SIZE: integer:=1);  -- Define o tamanho da FIFO. 2^W_SIZE palavras na FIFO.
   port (
      clk, reset: in  std_logic; -- Sinais de clock e reset.
      ps2d, ps2c: in  std_logic; -- Dados e clock do teclado PS/2.
      rd_key_code: in std_logic; -- Sinal para solicitar a leitura do código da tecla.
      number_code: out std_logic_vector(7 downto 0); -- Saída do código numérico da tecla.
      kb_buf_empty: out std_logic -- Sinal que indica se o buffer do teclado está vazio.
   );
end kb_code;

-- Arquitetura do decodificador de códigos de teclado.
architecture arch of kb_code is
   constant BRK: std_logic_vector(7 downto 0):="11110000"; -- Código de "break" (F0) do teclado PS/2.
   type statetype is (wait_brk, get_code); -- Estados: esperar pelo break e obter o código.
   signal state_reg, state_next: statetype; -- Sinais para o estado atual e o próximo estado.
   signal scan_out, w_data: std_logic_vector(7 downto 0); -- Saída do scanner e dados a serem escritos.
   signal scan_done_tick, got_code_tick: std_logic; -- Sinais para indicar a conclusão da varredura e a obtenção do código.

   signal key_code: std_logic_vector(7 downto 0); -- Código da tecla obtido.

begin
   -- Instanciação do componente ps2_rx para receber os dados do teclado PS/2.
   ps2_rx_unit: entity work.ps2_rx(arch)
      port map(clk=>clk, reset=>reset, rx_en=>'1',
               ps2d=>ps2d, ps2c=>ps2c,
               rx_done_tick=>scan_done_tick,
               dout=>scan_out);

   -- Instanciação do componente fifo para armazenar os códigos das teclas recebidas.
   fifo_key_unit: entity work.fifo(arch)
      generic map(B=>8, W=>W_SIZE) -- Configuração da largura e tamanho da FIFO.
      port map(clk=>clk, reset=>reset, rd=>rd_key_code,
               wr=>got_code_tick, w_data=>scan_out,
               empty=>kb_buf_empty, full=>open,
               r_data=>key_code);

    -- Instanciação do componente key2ascii para converter o código da tecla em um código ASCII.
    conv_number: entity work.key2ascii(arch) 
        port map(key_code=>key_code, 
            ascii_code=>number_code);
            
   -- Máquina de estados finita (FSM) para obter o código de varredura após receber o código de "break" (F0).
   process (clk, reset)
   begin
      if reset='1' then
         state_reg <= wait_brk; -- Estado inicial: esperar pelo código de "break".
      elsif (clk'event and clk='1') then
         state_reg <= state_next; -- Atualização do estado.
      end if;
   end process;
    
   -- Processo que define a lógica de transição entre os estados da FSM.
   process(state_reg, scan_done_tick, scan_out)
   begin
      got_code_tick <='0'; -- Inicializa o sinal de código obtido como '0'.
      state_next <= state_reg; -- Mantém o estado atual por padrão.
      case state_reg is
         when wait_brk => -- Espera pelo código de "break" (F0).
            if scan_done_tick='1' and scan_out=BRK then
               state_next <= get_code; -- Se o código de "break" for recebido, muda para o estado de obter o código.
            end if;

         when get_code => -- Obter o código de varredura seguinte.
            if scan_done_tick='1' then
               got_code_tick <='1'; -- Indica que o código foi obtido.
               state_next <= wait_brk; -- Retorna ao estado de espera pelo próximo código de "break".
            end if;
      end case;
   end process;
end arch;