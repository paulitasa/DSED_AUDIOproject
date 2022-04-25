----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2020 16:56:03
-- Design Name: 
-- Module Name: audio_interface_tb - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity audio_interface_tb is
end audio_interface_tb;

architecture Behavioral of audio_interface_tb is

component audio_interface
    Port ( clk_12megas : in STD_LOGIC;
            reset : in STD_LOGIC;
            --Recording ports
            --To/From the controller
            record_enable: in STD_LOGIC;
            sample_out: out STD_LOGIC_VECTOR (sample_size-1 downto 0); 
            sample_out_ready: out STD_LOGIC;
            --To/From the microphone
            micro_clk : out STD_LOGIC;
            micro_data : in STD_LOGIC;
            micro_LR : out STD_LOGIC;
            --Playing ports
            --To/From the controller
            play_enable: in STD_LOGIC;
            sample_in: in std_logic_vector(sample_size-1 downto 0);
            sample_request: out std_logic;
            --To/From the mini-jack
            jack_sd : out STD_LOGIC;
            jack_pwm : out STD_LOGIC);
end component;

signal clk_12megas, reset, record_enable, sample_out_ready, micro_clk, micro_data, micro_LR,  play_enable, sample_request, jack_sd, jack_pwm :std_logic :='0';
signal sample_in, sample_out : std_logic_vector (sample_size-1 downto 0) := "00000000";
constant clk_period : time := 10 ns;

begin

INTERFACE:  audio_interface
        port map (
            clk_12megas => clk_12megas, 
            reset => reset,
            record_enable => record_enable,
            sample_out => sample_out,
            sample_out_ready => sample_out_ready,
            micro_clk => micro_clk,
            micro_data => micro_data,
            micro_LR => micro_LR,
            play_enable => play_enable,
            sample_in => sample_in,
            sample_request => sample_request,           
            jack_sd => jack_sd, 
            jack_pwm => jack_pwm);    

clk_process :process
            begin
            clk_12megas <= '0';
            wait for clk_period/2;
                clk_12megas <= '1';
            wait for clk_period/2;
            end process;
            
sim_proc: process
          begin
          reset <='1';
          micro_data<= '0';
          sample_in <= "00000000";
          record_enable <= '1';
          play_enable <= '1';
          wait for 300 us;
          reset<='0';
          micro_data <='1';  
          wait for 103 ns ;
          micro_data <='0';
          wait for 78 ns; 
          micro_data <='1';  
          wait for 20 ns;
          micro_data <='1';  
          wait for 103 ns; 
          micro_data <='0';
          wait for 72 ns; 
          micro_data <='1'; 
          wait for 302 ns ;
          micro_data <='0';
          wait for 50 ns; 
          micro_data <='1';  
          wait for 90 ns;
          micro_data <='1';  
          wait for 23 ns; 
          micro_data <='0';
          wait for 22 ns; 
          micro_data <='1'; 
          wait for 103 ns ;
          micro_data <='0';
          wait for 78 ns; 
          micro_data <='1';  
          wait for 20 ns;
          micro_data <='1';  
          wait for 103 ns; 
          micro_data <='0';
          wait for 72 ns; 
          micro_data <='1'; 
          wait for 302 ns ;
          micro_data <='0';
          wait for 50 ns; 
          micro_data <='1';  
          wait for 90 ns;
          micro_data <='1';  
          wait for 23 ns; 
          micro_data <='0';
          wait for 22 ns; 
          micro_data <='1';
          wait for 20 ns;
          reset<='0';
          micro_data <='1';  
          wait for 103 ns ;
          micro_data <='0';
          wait for 78 ns; 
          micro_data <='1';  
          wait for 20 ns;
          micro_data <='1';  
          wait for 103 ns; 
          micro_data <='0';
          wait for 72 ns; 
          micro_data <='1'; 
          wait for 302 ns ;
          micro_data <='0';
          wait for 50 ns; 
          micro_data <='1';  
          wait for 90 ns;
          micro_data <='1';  
          wait for 23 ns; 
          micro_data <='0';
          wait for 22 ns; 
          micro_data <='1'; 
          wait for 103 ns ;
          micro_data <='0';
          wait for 78 ns; 
          micro_data <='1';  
          wait for 20 ns;
          micro_data <='1';  
          wait for 103 ns; 
          micro_data <='0';
          wait for 72 ns; 
          micro_data <='1'; 
          wait for 302 ns ;
          micro_data <='0';
          wait for 50 ns; 
          micro_data <='1';  
          wait for 90 ns;
          micro_data <='1';  
          wait for 23 ns; 
          micro_data <='0';
          wait for 22 ns; 
          micro_data <='1'; 
          wait for 120 ns;
          sample_in <= "00100111";
          wait for 450 us;
          sample_in <= "10000011";
          wait;
          end process;            

end Behavioral;
