----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    02:59:46 07/18/2024 
-- Design Name: 
-- Module Name:    multiplicador - Behavioral 
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

entity multiplicador1Digito is
    Port ( entradaA : in  STD_LOGIC_VECTOR (3 downto 0);
           entradaB : in  STD_LOGIC_VECTOR (3 downto 0);
			  carry_in : in  STD_LOGIC_VECTOR (3 downto 0);
			  carry_out : out  STD_LOGIC_VECTOR (3 downto 0);
           resultadoFinal : out  STD_LOGIC_VECTOR (3 downto 0));
end multiplicador1Digito;

architecture Behavioral of multiplicador1Digito is

	signal resultadoParcial: unsigned (7 downto 0) := "00000000";
	signal aux : unsigned (7 downto 0) := "00000000" ;

begin
	
	aux <= (unsigned(entradaA) * unsigned(entradaB)) + unsigned(carry_in);
	
	calculaCarry: process(aux) is
	begin
		if aux >= "01010000" then -- Verifica maior que 80
			carry_out <= "1000";
			resultadoParcial <= aux - "01010000";
		elsif "01000110" <= aux and aux < "01010000" then -- Verifica maior que 70
			carry_out <= "0111";
			resultadoParcial <= aux - "01000110";
		elsif "00111100" <= aux and aux < "01000110" then -- Verifica maior que 60
			carry_out <= "0110";
			resultadoParcial <= aux - "00111100";
		elsif "00110010" <= aux and aux < "00111100" then -- Verifica maior que 50
			carry_out <= "0101";
			resultadoParcial <= aux - "00110010";
		elsif "00101000" <= aux and aux < "00110010" then -- Verifica maior que 40
			carry_out <= "0100";
			resultadoParcial <= aux - "00101000";
		elsif "00011110" <= aux and aux < "00101000" then -- Verifica maior que 30
			carry_out <= "0011";
			resultadoParcial <= aux - "00011110";
		elsif "00010100" <= aux and aux < "00011110" then -- Verifica maior que 20
			carry_out <= "0010";
			resultadoParcial <= aux - "00010100";
		elsif "00001010" <= aux and aux < "00010100" then -- Verifica maior que 10
			carry_out <= "0001";
			resultadoParcial <= aux - "00001010";
		else
			carry_out <= "0000";
			resultadoParcial <= aux;
		end if;
	end process;
	
	resultadoFinal <= STD_LOGIC_VECTOR(resultadoParcial(3 downto 0));	

end Behavioral;

