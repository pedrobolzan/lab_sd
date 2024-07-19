library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Declaração da entidade ps2_rx para recepção de dados do teclado PS/2
entity ps2_rx is
   port (
      clk, reset: in  std_logic; -- Sinais de clock e reset
      ps2d, ps2c: in  std_logic;  -- Dados e clock do teclado PS/2
      rx_en: in std_logic; -- Sinal de habilitação da recepção
      rx_done_tick: out  std_logic; -- Sinal indicador de recepção completa
      dout: out std_logic_vector(7 downto 0) -- Dados recebidos (8 bits)
   );
end ps2_rx;

-- Arquitetura da entidade ps2_rx
architecture arch of ps2_rx is
   -- Declaração dos estados da máquina de estados finita (FSM)
   type statetype is (idle, dps, load);
   signal state_reg, state_next: statetype; -- Estados atual e próximo
   
   -- Registros para filtragem do sinal de clock do PS/2
   signal filter_reg, filter_next: std_logic_vector(7 downto 0);
   
   -- Registros para detecção de borda de descida do clock do PS/2
   signal f_ps2c_reg,f_ps2c_next: std_logic;
   
   -- Registros para armazenar os bits recebidos, incluindo start, stop e paridade
   signal b_reg, b_next: std_logic_vector(10 downto 0);
   
   -- Contador para os bits recebidos
   signal n_reg,n_next: unsigned(3 downto 0);
   
   -- Sinal para detecção de borda de descida
   signal fall_edge: std_logic;
begin
   -- Filtragem e geração de sinal de borda de descida para ps2c
   process (clk, reset)
   begin
      if reset='1' then
         filter_reg <= (others=>'0'); -- Inicializa o filtro com zeros
         f_ps2c_reg <= '0'; -- Estado inicial do clock filtrado
      elsif (clk'event and clk='1') then
         filter_reg <= filter_next; -- Atualiza o filtro
         f_ps2c_reg <= f_ps2c_next; -- Atualiza o estado do clock filtrado
      end if;
   end process;
   
   -- Lógica para atualização do filtro e detecção de borda de descida
   filter_next <= ps2c & filter_reg(7 downto 1); -- Desloca e adiciona o estado atual do clock
   f_ps2c_next <= '1' when filter_reg="11111111" else -- Se filtro todo em 1, clock filtrado em 1
                  '0' when filter_reg="00000000" else -- Se filtro todo em 0, clock filtrado em 0
                  f_ps2c_reg; -- Mantém estado anterior
   fall_edge <= f_ps2c_reg and (not f_ps2c_next); -- Detecção de borda de descida

   -- State Machine finita para extração dos 8 bits de dados
   process (clk, reset)
    begin
      if reset='1' then
         state_reg <= idle; -- Estado inicial
         n_reg  <= (others=>'0'); -- Inicializa contador de bits
         b_reg <= (others=>'0'); -- Inicializa registro de bits
      elsif (clk'event and clk='1') then
         state_reg <= state_next; -- Atualiza estado
         n_reg <= n_next; -- Atualiza contador de bits
         b_reg <= b_next; -- Atualiza registro de bits
      end if;
   end process;
   
   -- Lógica do próximo estado
   process(state_reg,n_reg,b_reg,fall_edge,rx_en,ps2d)
   begin
      rx_done_tick <='0'; -- Inicializa sinal de conclusão
      state_next <= state_reg; -- Mantém estado atual por padrão
      n_next <= n_reg; -- Mantém contador atual por padrão
      b_next <= b_reg; -- Mantém registro de bits atual por padrão
      case state_reg is
         when idle =>
            if fall_edge='1' and rx_en='1' then
               -- Se borda de descida e recepção habilitada, inicia recepção
               b_next <= ps2d & b_reg(10 downto 1); -- Desloca e adiciona bit de start
               n_next <= "1001"; -- Configura contador para 9 bits restantes (8 dados + 1 paridade)
               state_next <= dps; -- Muda para estado dps
            end if;
         when dps =>  -- Recebendo 8 dados + 1 paridade + 1 stop
            if fall_edge='1' then
               b_next <= ps2d & b_reg(10 downto 1); -- Desloca e adiciona bit recebido
               if n_reg = 0 then
                   state_next <=load; -- Se todos os bits recebidos, muda para estado load
               else
                   n_next <= n_reg - 1; -- Decrementa contador de bits
               end if;
            end if;
         when load =>
            -- 1 ciclo extra para completar o último deslocamento
            state_next <= idle; -- Retorna para estado idle
            rx_done_tick <='1'; -- Indica conclusão da recepção
      end case;
   end process;
   
   -- Saída dos dados
   dout <= b_reg(8 downto 1); -- Atribui os 8 bits de dados à saída dout
end arch;