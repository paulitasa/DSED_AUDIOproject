----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2020 16:35:17
-- Design Name: 
-- Module Name: controlador_tb - Behavioral
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

entity controlador_tb is
end controlador_tb;

architecture Behavioral of controlador_tb is

component controlador
    Port (
    BTNR: in std_logic;
    BTNL: in std_logic;
    BTNC: in std_logic;
    SW0: in std_logic;
    SW1: in std_logic;    
    clk_100Mhz : in std_logic;
    reset: in std_logic;
    --To/From the microphone
    micro_clk : out STD_LOGIC;
    micro_data : in STD_LOGIC;
    micro_LR : out STD_LOGIC;
    --To/From the mini-jack
    jack_sd : out STD_LOGIC;
    jack_pwm : out STD_LOGIC);
end component;

signal clk_100Mhz, reset, micro_clk, micro_data, micro_LR, jack_sd, jack_pwm : std_logic;
constant clk_period : time := 10 ns;

signal BTNR, BTNL, BTNC: std_logic:='0';
signal a, b, c : std_logic:='1';
signal SW0, SW1: std_logic:='1';

begin

CONTROL: controlador 
    port map(
    BTNR =>BTNR,
    BTNL =>BTNL,
    BTNC =>BTNC,
    SW0 =>SW0,
    SW1 => SW1,  
    clk_100Mhz => clk_100Mhz,
    reset =>reset,
    micro_clk =>micro_clk,
    micro_data =>micro_data,
    micro_LR =>micro_LR,
    jack_sd =>jack_sd,
    jack_pwm => jack_pwm);
    

clk_process :process
            begin
            clk_100Mhz <= '0';
            wait for clk_period/2;
                clk_100Mhz <= '1';
            wait for clk_period/2;
            end process;

sim_proc: --process(a, b, c)
            process
          begin
            SW0 <='0';
            SW1 <='0';
--            micro_data <= '1';
            reset <= '0';
            wait for 1 ms;
            BTNL<= '1' ;
            wait for 2 ms;
            BTNL<= '0';
            wait for 500us;
            BTNR <= '1' ;
            wait;
--            a <= not a after 300 us; --13000 ns
--            b <= not b after 500 us;          --  24000 ns
--            c <= not c after 700 us;           -- 37000 ns
--            micro_data <= (a xor b) xor c;
----            wait;
          end process;
          
          a <= not a after 1300 ns; --13000 ns
          b <= not b after 2400 ns;          --  24000 ns
          c <= not c after 3700 ns;           -- 37000 ns
          micro_data <= (a xor b) xor c;     
               
end Behavioral;
