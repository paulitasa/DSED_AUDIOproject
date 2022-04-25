----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.12.2020 16:03:57
-- Design Name: 
-- Module Name: audio_interface - Behavioral
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

entity audio_interface is
--    Generic (sample_size : integer :=8);
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

end audio_interface;

architecture Behavioral of audio_interface is

    component FSMD_microphone 
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               enable_4_cycles : in STD_LOGIC;
               micro_data : in STD_LOGIC;
               sample_out : out STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_out_ready : out STD_LOGIC);
    end component;
    
    component enables 
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               clk_3megas : out STD_LOGIC;
               en_2_cycles : out STD_LOGIC;
               en_4_cycles : out STD_LOGIC);
    end component;
    
    component pwm 
        Port ( clk_12megas : in STD_LOGIC;
               reset : in STD_LOGIC;
               en_2_cycles : in STD_LOGIC;
               sample_in : in STD_LOGIC_VECTOR (sample_size-1 downto 0);
               sample_request : out STD_LOGIC;
               pwm_pulse : out STD_LOGIC);
    end component;

        
    signal en_2_cycles_aux, en_4_cycles_aux: std_logic:= '0';
    signal enable_2_cycles_aux, enable_4_cycles_aux: std_logic := '0';
    constant clk_period : time := 10 ns;   
    
begin
    enable_4_cycles_aux <= record_enable and en_4_cycles_aux;
    enable_2_cycles_aux <= play_enable and en_2_cycles_aux;     
    
PWM_generator: pwm 
        port map (
            clk_12megas => clk_12megas, 
            reset => reset,
            en_2_cycles => enable_2_cycles_aux,
            sample_in => sample_in,  
            sample_request => sample_request, 
            pwm_pulse => jack_pwm);
            
EN: enables
        port map (
            clk_12megas => clk_12megas, 
            reset => reset,
            clk_3megas => micro_clk,
            en_2_cycles => en_2_cycles_aux, 
            en_4_cycles => en_4_cycles_aux);            
            
FSMD: FSMD_microphone 
        port map (
        clk_12megas => clk_12megas, 
        reset => reset,
        enable_4_cycles => enable_4_cycles_aux,
        micro_data => micro_data,  
        sample_out => sample_out, 
        sample_out_ready => sample_out_ready);    
        
       micro_LR<='1';
       jack_sd<='1';      

end Behavioral;
