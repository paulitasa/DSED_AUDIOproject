----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.01.2021 12:55:19
-- Design Name: 
-- Module Name: blk_mem_gen_0_tb - Behavioral
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

USE IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity blk_mem_gen_0_tb is
end blk_mem_gen_0_tb;

architecture Behavioral of blk_mem_gen_0_tb is

component blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;                            -- reloj del sistema completo (12MHz)
    ena : IN STD_LOGIC;                             -- enable de la memoria RAM
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);          -- señal de control que dependiendo de si es 0 o 1 permite leer(0) o escribir(1) en la memoria RAM
    addra : IN STD_LOGIC_VECTOR(18 DOWNTO 0);       -- dirección en la que se guardrá el dato
    dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);         -- dato de entrada que se quiere guardar
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)        -- dato de salida que se lee de la RAM
  );
END component;

   signal clka   : std_logic := '0';
   signal ena  : std_logic := '0';
   signal wea : std_logic_vector(0 downto 0) := "0";
   signal addra : std_logic_vector(18 downto 0) := (others => '0');
   signal dina  : std_logic_vector(7 downto 0) := (others => '0');
   signal douta  : std_logic_vector(7 downto 0);

   constant CLK_period : time := 10 ns;

begin
uut : blk_mem_gen_0
PORT MAP (
      clka   => clka,
      ena  => ena,
      wea => wea,
      addra => addra,
      dina  => dina,
      douta => douta
   );

CLK_process : process
   begin
        clka <= '0';
        wait for CLK_period/2;
        clka <= '1';
        wait for CLK_period/2;
   end process;
   
stim_write_read : process
      begin   
          -- write
         wait for CLK_period * 1;  
         addra <= (others => '0');
         for i in 0 to 2 loop
            wea <= "1";    
            ena  <= '1';
            wait for CLK_period * 1;        
            addra <= addra + 1;     
            dina  <= dina + 4;
         end loop;    
   
         -- read
         addra <= (others => '0');
         for k in 0 to 2 loop     
            wea <= "0";     
            ena  <= '1';  
            wait for CLK_period * 1;
            addra <= addra + 1;            
         end loop;
         ena  <= '1';  
         wait;
      end process;

end Behavioral;
