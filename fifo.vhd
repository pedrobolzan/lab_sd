library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Declaração da entidade FIFO (First-In, First-Out)
entity fifo is
   generic(
      B: natural:=8; -- Número de bits por palavra armazenada na FIFO
      W: natural:=4 -- Número de bits para o endereço, determina o tamanho da FIFO como 2^W
   );
   port(
      clk, reset: in std_logic; -- Sinais de clock e reset
      rd, wr: in std_logic; -- Sinais de leitura (rd) e escrita (wr)
      w_data: in std_logic_vector (B-1 downto 0); -- Dados de entrada para escrita
      empty, full: out std_logic; -- Sinais de saída indicando FIFO vazia (empty) ou cheia (full)
      r_data: out std_logic_vector (B-1 downto 0) -- Dados de saída para leitura
   );
end fifo;

-- Arquitetura da FIFO
architecture arch of fifo is
   -- Tipo de dado para armazenar a FIFO como um array de vetores de bits
   type reg_file_type is array (2**W-1 downto 0) of std_logic_vector(B-1 downto 0);
   signal array_reg: reg_file_type; -- Registro que armazena os dados da FIFO
   
   -- Ponteiros de escrita e leitura, incluindo o próximo valor e o valor sucessor
   signal w_ptr_reg, w_ptr_next, w_ptr_succ: std_logic_vector(W-1 downto 0);
   signal r_ptr_reg, r_ptr_next, r_ptr_succ: std_logic_vector(W-1 downto 0);
   
   -- Sinais para controle de estado da FIFO (cheia ou vazia)
   signal full_reg, empty_reg, full_next, empty_next: std_logic;
   
   -- Sinal para habilitar a operação de escrita
   signal wr_en: std_logic;
   
begin
   -- Processo para escrita na FIFO
   process(clk,reset)
   begin
     if (reset='1') then
        -- Se reset, inicializa a FIFO com zeros
        array_reg <= (others=>(others=>'0'));
     elsif (clk'event and clk='1') then
        -- Na borda de subida do clock, se a escrita estiver habilitada, escreve os dados
        if wr_en='1' then
           array_reg(to_integer(unsigned(w_ptr_reg))) <= w_data;
        end if;
     end if;
   end process;
   
   -- Porta de leitura da FIFO
   r_data <= array_reg(to_integer(unsigned(r_ptr_reg)));
   
   -- A escrita é habilitada apenas quando a FIFO não está cheia
   wr_en <= wr and (not full_reg);

   -- Processo para controle dos ponteiros e estados da FIFO
   process(clk,reset)
    begin
      if (reset='1') then
         -- Se reset, inicializa os ponteiros e indica FIFO vazia
         w_ptr_reg <= (others=>'0');
         r_ptr_reg <= (others=>'0');
         full_reg <= '0';
         empty_reg <= '1';
      elsif (clk'event and clk='1') then
         -- Na borda de subida do clock, atualiza os ponteiros e estados
         w_ptr_reg <= w_ptr_next;
         r_ptr_reg <= r_ptr_next;
         full_reg <= full_next;
         empty_reg <= empty_next;
      end if;
   end process;
   
   -- Calcula os valores sucessores dos ponteiros de escrita e leitura
   w_ptr_succ <= std_logic_vector(unsigned(w_ptr_reg)+1);
   r_ptr_succ <= std_logic_vector(unsigned(r_ptr_reg)+1);

   -- Lógica para atualização dos ponteiros e estados baseada nas operações de leitura e escrita
   process(w_ptr_reg,w_ptr_succ,r_ptr_reg,r_ptr_succ,empty_reg,full_reg)
    begin
      -- Inicializa os próximos estados dos ponteiros e indicadores de cheio/vazio
      w_ptr_next <= w_ptr_reg;
      r_ptr_next <= r_ptr_reg;
      full_next <= full_reg;
      empty_next <= empty_reg;
      -- Avalia as operações de leitura e escrita
      case wr and rd is
         when '0' & '0' => -- Sem operação
         when '0' & '1' => -- Operação de leitura
            if (empty_reg /= '1') then -- Se não está vazia
               r_ptr_next <= r_ptr_succ; -- Atualiza ponteiro de leitura
               full_next <= '0'; -- Indica que não está cheia
               if (r_ptr_succ=w_ptr_reg) then
                  empty_next <='1'; -- Se os ponteiros se igualam, indica vazia
               end if;
            end if;
         when '1' & '0' => -- Operação de escrita
            if (full_reg /= '1') then -- Se não está cheia
               w_ptr_next <= w_ptr_succ; -- Atualiza ponteiro de escrita
               empty_next <= '0'; -- Indica que não está vazia
               if (w_ptr_succ=r_ptr_reg) then
                  full_next <='1'; -- Se os ponteiros se igualam, indica cheia
               end if;
            end if;
         when others => -- Operação de leitura e escrita simultâneas
            w_ptr_next <= w_ptr_succ; -- Atualiza ponteiro de escrita
            r_ptr_next <= r_ptr_succ; -- Atualiza ponteiro de leitura
      end case;
   end process;
   
   -- Atribui os estados de cheio e vazio para as saídas
   full <= full_reg;
   empty <= empty_reg;
end arch;