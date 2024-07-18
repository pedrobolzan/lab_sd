----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:59:41 07/12/2024 
-- Design Name: 
-- Module Name:    list_ch08_04_key2ascii - Behavioral 
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity key2ascii is
   port (
      key_code: in std_logic_vector(7 downto 0);
      ascii_code: out std_logic_vector(7 downto 0)
   );
end key2ascii;

architecture arch of key2ascii is
begin
   with key_code select
      ascii_code <=
         "00110000" when "01000101",  -- 0
         "00110001" when "00010110",  -- 1
         "00110010" when "00011110",  -- 2
         "00110011" when "00100110",  -- 3
         "00110100" when "00100101",  -- 4
			"00110101" when "00101110",  -- 5
         "00110110" when "00110110",  -- 6
         "00110111" when "00111101",  -- 7
         "00111000" when "00111110",  -- 8
         "00111001" when "01000110",  -- 9
         "00001101" when "01011010",  -- (enter, cr)
         "00001000" when "01100110",  -- (backspace)
         "00101010" when others;      -- *
end arch;

