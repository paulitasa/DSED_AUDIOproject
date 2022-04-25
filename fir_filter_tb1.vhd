----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2021 00:20:54
-- Design Name: 
-- Module Name: fir_filter_tb1 - Behavioral
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
use work.package_dsed.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter_tb1 is
end fir_filter_tb1;

architecture Behavioral of fir_filter_tb1 is

    component fir_filter
--    Generic (sample_size : integer :=8);
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size-1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC; --0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size-1 downto 0);
           Sample_Out_ready : out STD_LOGIC); 
    end component;

signal clk, reset, sample_in_enable, filter_select, sample_out_ready : std_logic := '0';
signal sample_in, sample_out: signed (7 downto 0) := (others =>'0');
constant clk_period : time := 10 ns; 


begin
FILTRO: fir_filter
        port map(
            clk => clk,
            Reset => Reset,
            Sample_In => sample_in,
            Sample_In_enable => Sample_In_enable,
            filter_select => filter_select, 
            Sample_Out => sample_out,
            Sample_Out_ready => Sample_Out_ready );
            
            
clk_process :process
            begin
            clk <= '0';
            wait for clk_period/2;
                clk <= '1';
            wait for clk_period/2;
            end process;
            
sim_proc:   process 
            begin   
            
            reset<='1';
            sample_in_enable <='0';
            sample_in<=(others =>'0');
            filter_select <='0';
            wait for 100 ns;
            reset<='0';
                            
------------ TESTBENCH DE UN ÚNICO IMPULSO DE VALOR +0,5            
             wait for 50 ns;
             sample_in_enable <='1';
             sample_in<="01000000";   
             wait for 10 ns;
             sample_in_enable <='0';
             sample_in<=(others =>'0');                   
             wait for 100 ns;
             sample_in_enable <= '1';
             wait for 10 ns;
             sample_in_enable <='0';
             wait for 100 ns;
             sample_in_enable <= '1';
             wait for 10 ns;
             sample_in_enable <='0';
             wait for 100 ns;             
             sample_in_enable <= '1';
             wait for 10 ns;
             sample_in_enable <='0';
             wait for 100 ns;              
             sample_in_enable <= '1';
             wait for 10 ns;
             sample_in_enable <='0';
             wait for 100 ns;              
             
------------ TESTBENCH SECUENCIA (0, 0, 0, 0, X, 0, 0, 0, 0) CON X="01111111" MAYOR NÚMERO POSITIVO REPRESENTABLE
--             wait for 50 ns;
--             sample_in_enable <='1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="01111111";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');   
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';   
--             sample_in<=(others =>'0');                    
--             wait for 100 ns; 

------------ TESTBENCH SECUENCIA (0, 0, 0, 0, X, 0, 0, 0, 0) CON X="00000001" MENOR NÚMERO POSITIVO REPRESENTABLE
--             wait for 50 ns;
--             sample_in_enable <='1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000001";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');   
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';   
--             sample_in<=(others =>'0');                    
--             wait for 100 ns;             

------------ TESTBENCH SECUENCIA (0, 0, 0, 0, X, 0, 0, 0, 0) CON X="11111111" MAYOR NÚMERO NEGATIVO REPRESENTABLE
--             wait for 50 ns;
--             sample_in_enable <='1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="11111111";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');   
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';   
--             sample_in<=(others =>'0');                    
--             wait for 100 ns;              

------------ TESTBENCH SECUENCIA (0, 0, 0, 0, X, 0, 0, 0, 0) CON X="10000000" MENOR NÚMERO NEGATIVO REPRESENTABLE
--             wait for 50 ns;
--             sample_in_enable <='1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="10000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');   
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';   
--             sample_in<=(others =>'0');                    
--             wait for 100 ns; 
             
------------ TESTBENCH SECUENCIA (0, 0.5, 0, 0.125, 0, 0, ...) 
--             wait for 50 ns;
--             sample_in_enable <='1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="01000000";                
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;             
--             sample_in_enable <= '1';
--             sample_in<="00100000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns;              
--             sample_in_enable <= '1';
--             sample_in<="00000000";   
--             wait for 10 ns;
--             sample_in_enable <='0';
--             sample_in<=(others =>'0');                   
--             wait for 100 ns; 
--------------------------------------------------------------------------------------------                   
                   
                                            
             wait;            
            end process;                            
            
end Behavioral;
