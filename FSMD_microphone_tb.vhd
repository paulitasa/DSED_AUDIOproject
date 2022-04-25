----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2020 17:33:57
-- Design Name: 
-- Module Name: FSMD_microphone_tb - Behavioral
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

entity FSMD_microphone_tb is
end FSMD_microphone_tb;

architecture Behavioral of FSMD_microphone_tb is

component enables 
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_3megas : out STD_LOGIC;
           en_2_cycles : out STD_LOGIC;
           en_4_cycles : out STD_LOGIC);
end component;

component FSMD_microphone
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (7 downto 0);
           sample_out_ready : out STD_LOGIC);
end component;

signal clk_12megas, reset, enable_4_cycles_aux, micro_data, sample_out_ready, clk_3megas, en_2_cycles : std_logic :='0';
signal sample_out : std_logic_vector (7 downto 0) := "00000000";
constant clk_period : time := 80 ns; 
constant en_4 : time := 20 ns;

signal a, b, c: std_logic :='0';

begin
EN4: enables
        port map (
            clk_12megas => clk_12megas, 
            reset => reset,
            clk_3megas => clk_3megas,
            en_2_cycles => en_2_cycles, 
            en_4_cycles => enable_4_cycles_aux);
                
DUT: FSMD_microphone
        port map (
            clk_12megas => clk_12megas, 
            reset => reset,
            enable_4_cycles => enable_4_cycles_aux,
            micro_data => micro_data, 
            sample_out => sample_out, 
            sample_out_ready => sample_out_ready);
            
clk_process :process
            begin
            clk_12megas <= '0';
            wait for clk_period/2;
                clk_12megas <= '1';
            wait for clk_period/2;
            end process;
                  
            
sim_proc:   process (a, b, c)

            begin  
            reset<= '0';
            a <= not a after 300 us; 
            b <= not b after 500 us; 
            c <= not c after 700 us; 
            --Descomentar esto para pseudoaleatorio
            --micro_data <= (a xor b) xor c;
end process;            
-- Descomentar esto para micro data <= 1                        
--micro_data <= '1';          

end Behavioral;
