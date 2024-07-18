----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:51:46 11/11/2022 
-- Design Name: 
-- Module Name:    ui - Behavioral 
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
use IEEE.numeric_std.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ui is
    Port (
      clk, reset: in  std_logic;
      ps2d, ps2c, button, Operacao: in  std_logic;
		kb_buf_emptyld: out  std_logic;
		Resultado: out std_logic_vector(7 downto 0));
end ui;

architecture Behavioral of ui is

component MULTIPLICACAOBCD
		port(A, B:in STD_LOGIC_VECTOR;
				RESULT: out STD_LOGIC_VECTOR);
	end component;
	
component SOMABCD
		port(A, B:in STD_LOGIC_VECTOR;
				RESULT: out STD_LOGIC_VECTOR);
	end component;
	 
component DIVISORCLOCK
		port(CLK50 :in std_logic;
				CLK: out std_logic);
	end component;
	
signal A1, A2, A3, A4, B1, B2, B3, B4, D1, D2, D3, D4: STD_LOGIC_VECTOR (3 downto 0):= "1111";
signal A, B : STD_LOGIC_VECTOR(15 downto 0):= (others => '0');
type etapa_type is (dig1, dig2, dig3, dig4, change, stop);
signal etapa: etapa_type := dig1;
signal number_code: STD_LOGIC_VECTOR (7 downto 0);
signal sec_dig, OVER : STD_LOGIC := '0';
signal kb_buf_empty, rd_key_code, CLK_DIV: std_logic; 
signal SAIDA, res : std_logic_vector(31 downto 0):= (others => '0');
signal SAIDA2 : std_logic_vector(19 downto 0);
type etapa_maquina_type is (etapa1, etapa2, etapa3, etapa4);
signal maquina_estado : etapa_maquina_type;


begin	

	keyboard: entity work.kb_code(arch)
      port map(
      clk=>clk, reset=>reset,
      ps2d=>ps2d, ps2c=>ps2c,
      rd_key_code=>rd_key_code,
      number_code=>number_code,
      kb_buf_empty=>kb_buf_empty);
		
	kb_buf_emptyld<=kb_buf_empty;
	
	process (clk)
		begin
			if clk'event and clk = '1' then
				if kb_buf_empty = '0' then
					case etapa is
					when dig1 =>
						-- if kb_buf_empty = '1' then				
						D1 <= number_code(3 downto 0);
						-- end if;
						
						if sec_dig = '0' then
							A1 <= D1;
						else
							B1 <= D1;
						end if;
						if button = '1' then
							rd_key_code <= '1';
							if D1 = "1101" then
								etapa <= change;
							else
								etapa <= dig2;
							end if;
						end if;
					when dig2 =>
						--if kb_buf_empty = '1' then
						D2 <= number_code(3 downto 0);
						--end if;
						
						if sec_dig = '0' then
							A2 <= D2;
						else
							B2 <= D2;
						end if;
						if button = '1' then
							rd_key_code <= '1';
							if D2 = "1101" then
								etapa <= change;
							else
								etapa <= dig3;
							end if;
						end if;

					when dig3 =>
						--if kb_buf_empty = '1' then
						D3 <= number_code(3 downto 0);
						--end if;
						
						if sec_dig = '0' then
							A3 <= D3;
						else
							B3 <= D3;
						end if;
						if button = '1' then
							rd_key_code <= '1';
							if D3 = "1101" then
								etapa <= change;
							else
								etapa <= dig4;
							end if;
						end if;

					when dig4 =>
						--if kb_buf_empty = '1' then
						D4 <= number_code(3 downto 0);
						--end if;
						
						if sec_dig = '0' then
							A4 <= D4;
						else
							B4 <= D4;
						end if;
						if button = '1' then
							rd_key_code <= '1';
							etapa <= change;
						end if;

					when change =>
						if sec_dig = '0' then
							sec_dig <= '1';
							etapa <= dig1;
						else
							etapa <= stop;
						end if;
					when stop =>
						OVER <= '1';
					end case;
				
					--rd_key_code <= '1';
				else
					rd_key_code <= '0';
				end if;
			end if;
			
	end process;

--	process (CLK_DIV, number_code, etapa, kb_buf_empty)
--		begin
--			if CLK_DIV'event and CLK_DIV = '1' then
----				case etapa is
----					when dig1 =>
----						if kb_buf_empty = '1' then				
----							D1 <= number_code(3 downto 0);
----						end if;
----						Cout<="01";
----						if sec_dig = '0' then
----							A1 <= D1;
----						else
----							B1 <= D1;
----						end if;
----						if button = '1' then
----							if D1 = "1101" then
----								etapa <= change;
----							else
----								etapa <= dig2;
----							end if;
----						end if;
----					when dig2 =>
----						if kb_buf_empty = '1' then
----							D2 <= number_code(3 downto 0);
----						end if;
----						Cout<="10";
----						if sec_dig = '0' then
----							A2 <= D2;
----						else
----							B2 <= D2;
----						end if;
----						if button = '1' then
----							if D2 = "1101" then
----								etapa <= change;
----							else
----								etapa <= dig3;
----							end if;
----						end if;
----
----					when dig3 =>
----						if kb_buf_empty = '1' then
----							D3 <= number_code(3 downto 0);
----							end if;
----						Cout<="11";
----						if sec_dig = '0' then
----							A3 <= D3;
----						else
----							B3 <= D3;
----						end if;
----						if button = '1' then
----							if D3 = "1101" then
----								etapa <= change;
----							else
----								etapa <= dig4;
----							end if;
----						end if;
----
----					when dig4 =>
----						if kb_buf_empty = '1' then
----							D4 <= number_code(3 downto 0);
----							end if;
----						Cout<="00";
----						if sec_dig = '0' then
----							A4 <= D4;
----						else
----							B4 <= D4;
----						end if;
----						if button = '1' then
----							etapa <= change;
----						end if;
----
----					when change =>
----						if sec_dig = '0' then
----							sec_dig <= '1';
----							etapa <= dig1;
----						else
----							etapa <= stop;
----						end if;
----					when stop =>
----						OVER <= '1';
----				end case;
--			end if;
--	end process;
	
	process (clk)
		begin
			if OVER = '1' then
				if A2 = "1101" then
						A <= A(15 downto 4) & A1;
				elsif A3 = "1101" then
						A <= A(15 downto 8) & A1 & A2;
				elsif A4 = "1101" then
						A <= A(15 downto 12) & A1 & A2 & A3;
				else
					A <= A1 & A2 & A3 & A4;
				end if;
				
				if B2 = "1101" then
						B <= B(15 downto 4) & B1;
				elsif B3 = "1101" then
						B <= B(15 downto 8) & B1 & B2;
				elsif B4 = "1101" then
						B <= B(15 downto 12) & B1 & B2 & B3;
				else
					B <= B1 & B2 & B3 & B4;
				end if;
			end if;
			
	end process;
	
	MULTI : MULTIPLICACAOBCD port map (A, B, SAIDA);
	SOMA : SOMABCD port map (A, B, SAIDA2);
	
	selectOP : process (Operacao) is
		begin
			if Operacao = '1' then
				res <= SAIDA;
			else
				res(19 downto 0) <= SAIDA2;
			end if;
		end process;
		
	Clock : DIVISORCLOCK port map (clk, CLK_DIV);
	
	maquina : process (CLK_DIV) is
		begin
			if CLK_DIV'event and CLK_DIV = '1' then
				case maquina_estado is 
					when etapa1 =>	
						Resultado <= res(31 downto 24);
						maquina_estado <= etapa2;
					when etapa2 =>	
						Resultado <= res(23 downto 16);
						maquina_estado <= etapa3;
					when etapa3 =>	
						Resultado <= res(15 downto 8);
						maquina_estado <= etapa4;
					when etapa4 =>
						Resultado <= res(7 downto 0);
						maquina_estado <= etapa1;
					when others => 
						maquina_estado <= etapa1;
				end case;
			end if;
		end process;
		
end Behavioral;



