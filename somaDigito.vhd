----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:25:51 06/21/2024 
-- Design Name: 
-- Module Name:    somaDigito - Behavioral 
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

entity somaDigito is
    Port ( entradaA, entradaB : in  STD_LOGIC_VECTOR (3 downto 0);
			  carry_in : in STD_LOGIC_VECTOR (3 downto 0) := "0000";
			  carry_out : out STD_LOGIC_VECTOR (3 downto 0) := "0000";
           soma : out  STD_LOGIC_VECTOR (3 downto 0));
end somaDigito;

architecture Behavioral of somaDigito is

    signal resultado:unsigned (3 downto 0):= "0000";
	 signal aux:unsigned (4 downto 0):= "00000";
	 
begin
	
	aux <= '0' & unsigned(entradaA) + unsigned(entradaB) + unsigned(carry_in);
	
	calculaCarry : process(aux) is
	begin
		if aux >= "01010" then
			carry_out <= "0001";
			resultado <= aux (3 downto 0) - "1010";
		else
			carry_out <= "0000";
			resultado <= aux (3 downto 0);
		end if;
	end process;
	
	soma <= std_logic_vector(resultado);

end Behavioral;

