----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.12.2020 16:29:12
-- Design Name: 
-- Module Name: FSMD_microphone - Behavioral
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

entity FSMD_microphone is
--    Generic (sample_size : integer :=8);
    Port ( clk_12megas : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable_4_cycles : in STD_LOGIC;
           micro_data : in STD_LOGIC;
           sample_out : out STD_LOGIC_VECTOR (sample_size-1  downto 0); 
           sample_out_ready : out STD_LOGIC);
end FSMD_microphone;

architecture Behavioral of FSMD_microphone is
type state_type is (S0, S1, S2, S3);
signal state_reg, state_next : state_type;

signal data1_reg : UNSIGNED (sample_size-1  DOWNTO 0) := (others =>'0');
signal data1_next : UNSIGNED (sample_size-1  DOWNTO 0) := (others =>'0');
signal data2_reg : UNSIGNED (sample_size-1  DOWNTO 0) := (others =>'0');
signal data2_next : UNSIGNED (sample_size-1  DOWNTO 0) := (others =>'0');

signal primer_ciclo_reg : STD_LOGIC:= '0';
signal primer_ciclo_next : STD_LOGIC:= '0';

signal cuenta_reg :  UNSIGNED (8 DOWNTO 0) := (others =>'0');
signal cuenta_next :  UNSIGNED (8 DOWNTO 0) := (others =>'0');

signal sample_out_reg :STD_LOGIC_VECTOR (sample_size-1  downto 0):= (others =>'0');
signal sample_out_next : STD_LOGIC_VECTOR (sample_size-1  downto 0):= (others =>'0');

signal sample_out_ready_temp_reg : STD_LOGIC := '0';
signal sample_out_ready_temp_next : STD_LOGIC := '0';

begin

--input logic
process (cuenta_reg, state_reg, primer_ciclo_reg, micro_data, data1_reg, data2_reg, sample_out_reg) 
     begin 
                cuenta_next <=(others =>'0');
                data1_next <= data1_reg;
                data2_next <= data2_reg;
                primer_ciclo_next <= primer_ciclo_reg;
                sample_out_next <= sample_out_reg;
                sample_out_ready_temp_next <='0';              
                
        case(state_reg) is
        
            when S0 =>
                cuenta_next <= (others =>'0') ; 
                data1_next<= (others =>'0');
                data2_next<= (others =>'0');
                primer_ciclo_next <= '0';
                sample_out_ready_temp_next <='0';
                sample_out_next<= (others =>'0');  
                
            when S1=>
                cuenta_next <= cuenta_reg + 1;
                
                if(micro_data='1') then                 
                    data1_next<= data1_reg + 1;
                    data2_next<= data2_reg + 1;
                else
                   data1_next<= data1_reg;
                   data2_next<= data2_reg ;                
                end if;  
                 
                if(cuenta_reg=255) then 
                    sample_out_next <= std_logic_vector(data1_reg); 
                    sample_out_ready_temp_next<= '1';
                    data1_next<=(others =>'0');
                end if;  
                                
                if(primer_ciclo_reg='1' and cuenta_reg=105)then 
                    sample_out_next<= std_logic_vector(data2_reg);
                    sample_out_ready_temp_next<= '1';
                    data2_next<=(others =>'0'); 
                end if;
                
            when S2=>
                cuenta_next <= cuenta_reg + 1;
                sample_out_ready_temp_next<='0'; 
                if(micro_data='1') then
                    data1_next<= data1_reg + 1;   
                else
                    data1_next<= data1_reg;      
                end if;              
                
            when S3=>
                sample_out_ready_temp_next<='0'; 
                if(cuenta_reg > 298)then 
                    cuenta_next<=(others =>'0');
                    primer_ciclo_next<='1';
                else 
                    cuenta_next <= cuenta_reg + 1;
                end if;
                
                if(micro_data='1') then
                    data2_next<= data2_reg + 1;
                else    
                    data2_next<= data2_reg;
                end if;                
     
        end case;
end process;

--next state logic
process (cuenta_reg, state_reg)
 begin
    state_next<= state_reg;
    
     case(state_reg) is
     when S0 => 
        state_next <= S1;                 
     when S1 =>
         if((0<= cuenta_reg) and (cuenta_reg<=104))or ((149<= cuenta_reg)and (cuenta_reg <=254)) then 
            state_next <= S1;
         elsif (105<= cuenta_reg) and (cuenta_reg<=148) then
            state_next <= S2; 
         elsif (255<= cuenta_reg) and (cuenta_reg<=298) then
            state_next <= S3;  
         end if;     
     when S2 =>
        if((105 <= cuenta_reg) and (cuenta_reg <= 148)) then 
            state_next <= S2;
        else
            state_next <= S1;    
        end if;      
     when S3 =>
        if(cuenta_reg >= 299) then 
            state_next <= S1;
        else
            state_next <= S3;
        end if;         
     end case;
end process;

--state register
process (clk_12megas)
    begin
        if rising_edge(clk_12megas) then 
            if (reset='1') then 
                state_reg<=S0;
                --
                cuenta_reg<= cuenta_next;
                data1_reg <= data1_next;
                data2_reg <= data2_next;
                primer_ciclo_reg <= primer_ciclo_next;
                sample_out_reg<= sample_out_next;
                sample_out_ready_temp_reg<= sample_out_ready_temp_next;                 
                --
            else
                if(enable_4_cycles = '1') then
                    state_reg<=state_next;
                    cuenta_reg<= cuenta_next;
                    data1_reg <= data1_next;
                    data2_reg <= data2_next;
                    primer_ciclo_reg <= primer_ciclo_next;
                    sample_out_reg<= sample_out_next;
                    sample_out_ready_temp_reg<= sample_out_ready_temp_next;   
                end if;     
            end if;
        end if;            
end process;


--output logic 
    sample_out_ready <=sample_out_ready_temp_reg and enable_4_cycles;
    sample_out <= sample_out_reg;

end Behavioral;
