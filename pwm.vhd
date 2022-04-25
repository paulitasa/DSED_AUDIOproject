----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2020 18:31:10
-- Design Name: 
-- Module Name: pwm - Behavioral
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

entity pwm is
--    Generic (sample_size : integer :=8);
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           en_2_cycles : in STD_LOGIC;
           sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
           sample_request : out STD_LOGIC;
           pwm_pulse : out STD_LOGIC);
end pwm;

architecture Behavioral of pwm is

signal r_reg, r_next : unsigned (8 downto 0):="000000000";
signal buf_reg, buf_next, sample_request_aux :std_logic:= '0';

begin

process (clk_12megas, reset) 
begin
    if rising_edge(clk_12megas) then 
        if(reset  = '1') then 
            r_reg <= (others =>'0');
            buf_reg <= '0';        
        else
            if(en_2_cycles='1') then
                r_reg <= r_next;
                buf_reg <= buf_next;
            end if;
        end if;
    end if;
end process;

process (en_2_cycles, r_reg)
begin 
    sample_request_aux<='0';
    r_next<=r_reg+1;
    if(r_reg =299) then 
        sample_request_aux<= '1';
        r_next <= (others =>'0');
    end if;
end process;

buf_next <=
    '1' when (r_reg<unsigned(sample_in)) else 
    '0';
    
sample_request <= sample_request_aux and en_2_cycles;     
pwm_pulse<= buf_reg;
end Behavioral;
