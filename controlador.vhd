----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.12.2020 16:07:14
-- Design Name: 
-- Module Name: controlador - Behavioral
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

entity controlador is
--    Generic (sample_size : integer :=8);
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
    jack_pwm : out STD_LOGIC
    );
end controlador;

architecture Behavioral of controlador is

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

component clk_wiz_0
    Port (reset : in STD_LOGIC;
        clk_in1: in STD_LOGIC;
        clk_out1: out STD_LOGIC);
end component; 

component fir_filter 
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size-1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC; --0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size-1 downto 0);
           Sample_Out_ready : out STD_LOGIC);
end component;

component blk_mem_gen_0 
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0); -- este 7 sería 7 por que es sample_size-1????
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- este 7 sería 7 por que es sample_size-1????
END component;


signal clk_out1_aux: std_logic :='0';
signal sample_out_fsmd, sample_in_pwm: std_logic_vector(sample_size-1 downto 0);
signal record_enable, play_enable, sample_out_ready_audio, sample_request, Sample_In_enable_filtro, filter_select, Sample_Out_ready_filtro: std_logic :='0';

signal sample_out_filtro_signed, douta_signed : signed(sample_size-1 downto 0); --relacionar con sample_out_filtro_std y douta_std

signal ena : std_logic :='0';
signal wea : std_logic_vector(0 downto 0);
signal addra, escritura_reg, lectura_reg, escritura_next, lectura_next, rewind_reg, rewind_next : std_logic_vector(18 downto 0):= (others => '0');
signal douta_std : std_logic_vector(7 downto 0);
    
type state_type is (REPOSO, GRABAR, BORRAR, PLAY, REWIND, LPF, HPF);
signal state_reg, state_next : state_type;


    
begin

--input logic
process (state_reg, sample_out_ready_audio, sample_request, escritura_reg, lectura_reg, ena, douta_std, sample_out_filtro_signed, rewind_reg, state_next) 
     begin               
        --valores por defecto
        record_enable <= '0';
        play_enable <= '0';  
        ena <= '0';              
        escritura_next <= escritura_reg;
        lectura_next <= lectura_reg;
        rewind_next <= rewind_reg;
        wea <="1";
        addra <= escritura_reg;
        douta_signed <= (others => '0');
        sample_in_enable_filtro <= '0' ;
        filter_select <= '0';
        sample_in_pwm <=(others => '0');
                
        case(state_reg) is
        
            when REPOSO =>
                record_enable <= '0';
                play_enable <= '0';
                if(state_next = PLAY or state_next= REWIND or state_next=HPF or state_next=LPF) then 
                    lectura_next <= (others => '0'); 
                end if;
                if(state_next = REWIND) then
                    rewind_next<= escritura_reg;
                end if;
                
            when GRABAR =>
                ena <= sample_out_ready_audio;
                record_enable <= '1';
                play_enable <= '0';
                wea<= "1";
                addra <= escritura_reg;
                if(ena ='1') then 
                    escritura_next<= std_logic_vector(unsigned(escritura_reg) +1);
                end if;
--                if(state_next = REWIND) then             
--                    rewind_next<= escritura_reg;
--                end if;
                 
            when BORRAR =>
                escritura_next <= (others => '0');
                lectura_next <= (others => '0'); 
                record_enable <= '0';
                play_enable <= '0';
                                
            when PLAY =>
                ena <= sample_request;
                record_enable <= '0';
                play_enable <= '1';
                wea<= "0";
                addra <= lectura_reg;
                sample_in_pwm <= douta_std;
                if(ena ='1') then 
                    lectura_next <= std_logic_vector(unsigned(lectura_reg) +1);
                end if;
                
            when REWIND =>
                ena <= sample_request;
                record_enable <= '0';
                play_enable <= '1';
                wea<= "0";
                addra <= rewind_reg;
                sample_in_pwm <= douta_std; 
                if(ena ='1') then 
                    rewind_next <= std_logic_vector(unsigned(rewind_reg) -1);
                end if;
                
            when LPF =>
                ena <= sample_request;
                record_enable <= '0';
                play_enable <= '1';
                Sample_In_enable_filtro <= sample_request;
                wea<= "0";
                addra <= lectura_reg;
                douta_signed <= ((signed(douta_std)) +128);
                sample_in_pwm <= std_logic_vector((sample_out_filtro_signed) +128);
                if(ena ='1') then 
                    lectura_next <= std_logic_vector(unsigned(lectura_reg) +1);
                end if;
                filter_select <= '0';
                
            when HPF =>
                ena <= sample_request;
                record_enable <= '0';
                play_enable <= '1';
                Sample_In_enable_filtro <= sample_request;
                wea<= "0";
                addra <= lectura_reg;
                douta_signed <= ((signed(douta_std)) +128);
                sample_in_pwm <= std_logic_vector((sample_out_filtro_signed) +128);
                if(ena ='1') then 
                    lectura_next <= std_logic_vector(unsigned(lectura_reg) +1);
                end if;
                filter_select <= '1';
                              
        end case;
end process;                

--next state logic
process (BTNR, BTNL, BTNC, SW0, SW1, state_reg, lectura_reg, rewind_reg, escritura_reg)
 begin
    state_next<= state_reg;
    
     case(state_reg) is
     when REPOSO => 
        if (BTNR='0' AND BTNL='1' AND BTNC='0') then 
            state_next <= GRABAR;
        elsif (BTNR='0' AND BTNL='0' AND BTNC='1') then 
            state_next <= BORRAR;
        elsif (BTNR='1' AND BTNL='0' AND BTNC='0') then 
            if(SW0='0' AND SW1='0') then 
                state_next <= PLAY;
            elsif (SW0='1' AND SW1='0') then 
                state_next <= REWIND;
            elsif (SW0='0' AND SW1='1') then 
                state_next <= LPF;
            else
                state_next <= HPF;
            end if;
        else
            state_next <= REPOSO;
        end if;
        
     when GRABAR =>
         if (BTNL ='1') then 
            state_next <= GRABAR;
         else 
            state_next <= REPOSO;
         end if;   
           
     when BORRAR =>
            state_next <= REPOSO; 
            
     when PLAY =>    
        if (lectura_reg = escritura_reg) then 
            state_next <= REPOSO;
        else
            state_next <= PLAY;
        end if;
        
     when REWIND =>
        if (rewind_reg = "0000000000000000000") then 
             state_next <= REPOSO;
         else
             state_next <= REWIND;
         end if;     
         
     when LPF =>
        if (lectura_reg = escritura_reg) then 
          state_next <= REPOSO;
        else
          state_next <= LPF;
        end if;      
        
     when HPF =>
      if (lectura_reg = escritura_reg) then 
          state_next <= REPOSO;
      else
          state_next <= HPF;
      end if; 
         
     end case;
end process;



--state register
process (clk_out1_aux, reset)
    begin
        if (reset = '1') then 
        state_reg<=BORRAR;
                        rewind_reg <= (others => '0');
                        escritura_reg <= (others => '0'); 
                        lectura_reg <= (others => '0');
        elsif rising_edge(clk_out1_aux) then 
                escritura_reg <= escritura_next; 
                lectura_reg <= lectura_next; 
                rewind_reg <= rewind_next;
                state_reg<=state_next;
                  
        end if;            
end process;


----------------------------------------------------------------------------------------------------------------


interfaz_audio: audio_interface
        port map(
            clk_12megas => clk_out1_aux,
            reset => reset,
            record_enable => record_enable,
            sample_out => sample_out_fsmd,
            sample_out_ready => sample_out_ready_audio,    
            micro_clk => micro_clk,
            micro_data => micro_data,
            micro_LR => micro_LR,
            play_enable => play_enable,
            sample_in => sample_in_pwm,
            sample_request => sample_request,       
            jack_sd => jack_sd,
            jack_pwm => jack_pwm);

reloj_12meg:  clk_wiz_0           
        port map(
            reset => reset,
            clk_in1 => clk_100Mhz,
            clk_out1 => clk_out1_aux);
                
filtro: fir_filter
        port map(
           clk => clk_out1_aux, --reloj 12mHz
           Reset => reset,
           Sample_In => douta_signed,
           Sample_In_enable => Sample_In_enable_filtro, --Sample_In_enable_filtro
           filter_select => filter_select,
           Sample_Out => sample_out_filtro_signed,
           Sample_Out_ready => Sample_Out_ready_filtro);

RAM:    blk_mem_gen_0
        port map(
        clka => clk_out1_aux, --reloj 12mHz
        ena => ena,
        wea => wea,  --convertir a std_logic_vector 0 downto 0
        addra => addra,
        dina => sample_out_fsmd,
        douta => douta_std);                 
                
end Behavioral;
