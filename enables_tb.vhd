----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.12.2020 20:00:48
-- Design Name: 
-- Module Name: enables_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity enables_tb is
end enables_tb;

architecture Behavioral of enables_tb is
component enables
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

signal clk_12megas, reset : STD_LOGIC:= '0';
signal clk_3megas, en_2_cycles, en_4_cycles: STD_LOGIC;
constant clk_period : time := 10ns; 

begin

clk_process :process
    begin
        clk_12megas <= '0';
        wait for clk_period/2;
        clk_12megas <= '1';
        wait for clk_period/2;
    end process; 
      
ENABLE: enables 
    port map(
    clk_12megas => clk_12megas,
    reset => reset, 
    clk_3megas => clk_3megas,
    en_2_cycles => en_2_cycles,
    en_4_cycles => en_4_cycles);
    
enable_process :process
        begin        
            reset<='0';
            wait for 65 ns;
            reset<='1';
            wait for 25 ns;
            reset<='0';
            wait;
        end process;     
end Behavioral;
