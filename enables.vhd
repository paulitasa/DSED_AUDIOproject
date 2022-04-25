----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.11.2020 12:40:52
-- Design Name: 
-- Module Name: tarea1-1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enables is
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end enables;

architecture Behavioral of enables is
      signal contador_reg, contador_next: UNSIGNED (1 DOWNTO 0) := "00"; 
      signal salida : std_logic_vector (2 downto 0):= "000";
begin

--next state logic
    process (contador_reg)
    begin
    if(contador_reg = "11")then 
        contador_next<= "00";
    else
        contador_next<= contador_reg + 1;
    end if;
    end process;
    
--state register
    process (reset, clk_12megas)
        begin
        if rising_edge(clk_12megas) then 
            if (reset = '1') then 
                contador_reg <= "00";
            else
                contador_reg <= contador_next;           
            end if;
        end if;    
    end process;
    
--output logic
    process(contador_reg)
    begin
        if (contador_reg = "00")then 
            salida <= "010";      
        elsif (contador_reg = "01") then
            salida <= "101";         
        elsif (contador_reg = "10") then
            salida <= "110";         
        else 
            salida <= "000";        
        end if;
    end process;
    
    clk_3megas <= salida(2);
    en_2_cycles <= salida(1);
    en_4_cycles <= salida(0);    
    
end Behavioral;


