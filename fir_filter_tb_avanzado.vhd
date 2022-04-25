----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.01.2021 01:10:12
-- Design Name: 
-- Module Name: fir_filter_tb_avanzado - Behavioral
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

use std.textio.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fir_filter_tb_avanzado is
end fir_filter_tb_avanzado;

architecture Behavioral of fir_filter_tb_avanzado is

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

signal clk, reset, sample_in_enable : std_logic := '0';
signal filter_select :std_logic;
signal sample_out_ready: std_logic;
signal sample_in, sample_out: signed (7 downto 0) := (others => '0');

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
            
            filter_select<= '0';
            
clk_process :process
            begin
            clk <= '0';
            wait for clk_period/2;
            clk <= '1';
            wait for clk_period/2;
            end process;
            
read_process : PROCESS (clk)
            FILE in_file : text OPEN read_mode IS "C:\DSED\DSED_Group16\sample_in.dat"; --ruta completa
            VARIABLE in_line : line;
            VARIABLE in_int : integer;
            VARIABLE in_read_ok : BOOLEAN;
            BEGIN
            if rising_edge(clk)then 
                if NOT endfile (in_file) then 
                    if sample_in_enable ='1' then 
                        ReadLine(in_file, in_line);
                        Read(in_line, in_int, in_read_ok);
                        sample_in<= to_signed(in_int, 8); --8 :bit width
                    end if;
                else
                    assert false report "Simulation Finished" severity failure;
                end if;
            end if;
            end process;
          
            
sample_in_enable_activate:
            process
            begin
                sample_in_enable<= '1';
                wait for 10 ns;
                sample_in_enable<= '0';
                wait for 100 ns;
            end process;
            
reset_proc : process
            begin
                reset <= '1';
                wait for 10 ns;
                reset <= '0';
                wait;            
            end process;
            
write_process : PROCESS (clk)
            FILE out_file : text OPEN write_mode IS "C:\DSED\DSED_Group16\sample_out.dat"; --ruta completa
            VARIABLE out_line : line;
            VARIABLE out_int : integer;
            BEGIN
            if rising_edge(clk)then
                if (sample_out_ready ='1') then 
                    out_int := to_integer(sample_out);
                    Write(out_line, out_int);
                    WriteLine(out_file, out_line);
                end if;
            end if;
            end process;            
                        
end Behavioral;
