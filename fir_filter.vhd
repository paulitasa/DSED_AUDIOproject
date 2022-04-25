----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04.01.2021 20:40:12
-- Design Name: 
-- Module Name: fir_filter - Behavioral
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

entity fir_filter is
--    Generic (sample_size : integer :=8);
    Port ( clk : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Sample_In : in signed (sample_size-1 downto 0);
           Sample_In_enable : in STD_LOGIC;
           filter_select : in STD_LOGIC; --0 lowpass, 1 highpass
           Sample_Out : out signed (sample_size-1 downto 0);
           Sample_Out_ready : out STD_LOGIC);
end fir_filter;

architecture Behavioral of fir_filter is
type state_type is (S0, S1, S2, S3, S4, S5, S6, S7);
signal state_reg, state_next : state_type;

signal x0_reg, x1_reg, x2_reg, x3_reg, x4_reg, x0_next, x1_next, x2_next, x3_next, x4_next : signed (sample_size-1 downto 0); -- tamaño del dato de entrada (8bits, <1,7>)

constant c0_pb, c4_pb : signed (sample_size-1 downto 0) := "00000101"; -- 0.039   -- tamaño de coeficientes del filtro (8bits, <1,7>)
constant c1_pb, c3_pb : signed (sample_size-1 downto 0) := "00011111"; -- 0.2422  -- tamaño de coeficientes del filtro (8bits, <1,7>)
constant c2_pb : signed (sample_size-1 downto 0) := "00111001";             -- 0.4453  -- tamaño de coeficientes del filtro (8bits, <1,7>)
constant c0_pa, c4_pa : signed (sample_size-1 downto 0) := "11111111" ;-- -0.0078 -- tamaño de coeficientes del filtro (8bits, <1,7>)
constant c1_pa, c3_pa : signed (sample_size-1 downto 0) := "11100110"; -- 0.2031  -- tamaño de coeficientes del filtro (8bits, <1,7>)
constant c2_pa : signed (sample_size-1 downto 0) := "01001101";             -- 0.6015  -- tamaño de coeficientes del filtro (8bits, <1,7>) 

signal r1_reg, r1_next, r2_reg, r2_next, r3_reg, r3_next, sample_out_reg, sample_out_next : signed ((sample_size*2)-1 downto 0); -- resultados de multiplicar x*c (16 bits, <2,14>) que truncaremos en <1,7> en la salida haciendo (14 downto 7)

signal sample_out_ready_reg, sample_out_ready_next : STD_LOGIC;

begin


--Registro desplazamiento
process(reset, clk)
begin 
    if rising_edge(clk) then 
        if(reset='1') then 
            x0_reg <= (others =>'0');
            x1_reg <= (others =>'0');
            x2_reg <= (others =>'0');
            x3_reg <= (others =>'0');
            x4_reg <= (others =>'0');  
        else
            x0_reg <= x0_next;
            x1_reg <= x1_next;
            x2_reg <= x2_next;
            x3_reg <= x3_next;
            x4_reg <=x4_next;     
        end if;    
    end if;
 
end process;

process (sample_in, sample_in_enable, x0_reg, x1_reg, x2_reg, x3_reg, x4_reg)
begin
    x0_next <= x0_reg;
    x1_next <= x1_reg;
    x2_next <= x2_reg;
    x3_next <= x3_reg;
    x4_next <= x4_reg;      
    
    if(sample_in_enable = '1') then 
        x0_next <= sample_in;
        x1_next <= x0_reg;
        x2_next <= x1_reg;
        x3_next <= x2_reg;
        x4_next <= x3_reg;
    end if; 
end process;

-- Máquina de estados
--next state logic
process (state_reg, sample_in_enable) 
     begin 
        case(state_reg) is
            when S0 =>
                if(sample_in_enable = '1') then 
                    state_next <= S1;
                else 
                    state_next <= S0;
                end if;
            when S1 =>
                state_next <= S2;
            when S2 =>
                state_next <= S3;
            when S3 =>
                state_next <= S4;
            when S4 =>
                state_next <= S5;
            when S5 =>
                state_next <= S6;
            when S6 =>
                state_next <= S7;
            when S7 =>
                state_next <= S0;
        end case;    
end process; 

--
process (state_reg, filter_select, x0_reg, x1_reg, x2_reg, x3_reg, x4_reg, r1_reg, r2_reg, r3_reg, sample_out_reg) 
     begin 
         sample_out_ready_next <= '0'; 
         sample_out_next <= sample_out_reg; 
         r1_next <= r1_reg;
         r2_next <= r2_reg;
         r3_next <= r3_reg;       
        case(state_reg) is
            when S0 =>
                sample_out_ready_next <= '0'; 
            when S1 =>
                if(filter_select = '0') then 
                    r1_next <=(c0_pb * x0_reg);
                else  
                    r1_next <= (c0_pa * x0_reg);
                end if;
            when S2 =>
                r2_next<= r1_reg;
                if(filter_select = '0') then 
                    r1_next <= (c1_pb * x1_reg);
                else  
                    r1_next <= (c1_pa * x1_reg);
                end if;            
            when S3 =>
                r3_next<= r1_reg;
                if(filter_select = '0') then 
                    r1_next <= (c2_pb * x2_reg);
                else  
                    r1_next <=(c2_pa * x2_reg);
                end if;             
            when S4 =>
                r3_next<= r1_reg;
                r2_next<= r2_reg + r3_reg;
                if(filter_select = '0') then 
                    r1_next <= (c3_pb * x3_reg);
                else  
                    r1_next <= (c3_pa * x3_reg);
                end if;            
            when S5 =>
                r3_next<= r1_reg;
                r2_next<= r2_reg + r3_reg;
                if(filter_select = '0') then 
                    r1_next <= (c4_pb * x4_reg);
                else  
                   r1_next <= (c4_pa * x4_reg);
                end if;                
            when S6 =>
                r3_next<= r1_reg;
                r2_next<= r2_reg + r3_reg;              
            when S7 =>
                sample_out_next <= r2_reg + r3_reg;              
                sample_out_ready_next <= '1';
                  
        end case;    
end process; 

               
--state register
process (clk)
    begin
        if rising_edge(clk) then 
            if(reset='1') then 
                state_reg<=S0;
                r1_reg <= (others =>'0');
                r2_reg <= (others =>'0');
                r3_reg <= (others =>'0');
                sample_out_reg <= (others =>'0');
                sample_out_ready_reg <= '0';
            else
                state_reg<=state_next;
                r1_reg <= r1_next;
                r2_reg <= r2_next;
                r3_reg <= r3_next;
                sample_out_reg <= sample_out_next;
                sample_out_ready_reg <= sample_out_ready_next;               
            end if;
        end if;            
end process;

--output logic 
sample_out<= sample_out_reg (14 downto 7);
sample_out_ready<= sample_out_ready_reg;


end Behavioral;
