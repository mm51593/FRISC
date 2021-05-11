----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2020 04:21:59 PM
-- Design Name: 
-- Module Name: MUX4to1 - Behavioral
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

entity MUX4to1 is
    Port ( input : in STD_LOGIC_VECTOR (3 downto 0);
           selection : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC);
end MUX4to1;

architecture Behavioral of MUX4to1 is
    signal  notSelect: STD_LOGIC_VECTOR(1 downto 0);
    signal  processedInput: STD_LOGIC_VECTOR(3 downto 0);
    constant    n: integer := 2; 
begin
    for_i: for i in 0 to n - 1 generate
        ci: entity work.circuitNOT port map(I => selection(i), O => notSelect(i)); 
    end generate;
    
    c1: entity work.circuitAND3 port map(A => notSelect(1), B => notSelect(0), C => input(0), R => processedInput(0));
    c2: entity work.circuitAND3 port map(A => notSelect(1), B => selection(0), C => input(1), R => processedInput(1));
    c3: entity work.circuitAND3 port map(A => selection(1), B => notSelect(0), C => input(2), R => processedInput(2));
    c4: entity work.circuitAND3 port map(A => selection(1), B => selection(0), C => input(3), R => processedInput(3));
    
    c5: entity work.circuitOR4 port map(input => processedInput, output => output);
end Behavioral;
