library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity somaDigito is
    Port (
        entradaA, entradaB : in STD_LOGIC_VECTOR (3 downto 0); 
        carry_in : in STD_LOGIC_VECTOR (3 downto 0) := "0000"; 
        carry_out : out STD_LOGIC_VECTOR (3 downto 0) := "0000";
        soma : out STD_LOGIC_VECTOR (3 downto 0) 
    );
end somaDigito;

architecture Behavioral of somaDigito is
    -- Sinal interno para armazenar o resultado temporário da soma, 4 bits
    signal resultado: unsigned (3 downto 0) := "0000";
    -- Sinal interno auxiliar para calcular a soma e o carry, 5 bits para acomodar o carry out
    signal aux: unsigned (4 downto 0) := "00000";
     
begin
    -- Calcula a soma dos vetores de entrada e o carry_in, armazenando o resultado em 'aux'
    aux <= '0' & unsigned(entradaA) + unsigned(entradaB) + unsigned(carry_in);
    
    -- Processo para calcular o carry_out e ajustar o resultado com base no valor de 'aux'
    calculaCarry : process(aux) is
    begin
        if aux >= "01010" then -- Se 'aux' indica um carry (valor >= 10 em binário)
            carry_out <= "0001"; -- Define carry_out como 1
            resultado <= aux (3 downto 0) - "1010"; -- Ajusta o resultado subtraindo 10 (1010 em binário)
        else -- Se não houver carry
            carry_out <= "0000"; -- Define carry_out como 0
            resultado <= aux (3 downto 0); -- O resultado é igual aos 4 bits menos significativos de 'aux'
        end if;
    end process;
    
    -- Atribui o valor de 'resultado' ao sinal de saída 'soma', convertendo de unsigned para std_logic_vector
    soma <= std_logic_vector(resultado);

end Behavioral;

