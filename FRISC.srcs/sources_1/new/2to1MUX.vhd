----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/7/2020 12:40:12 AM
-- Design Name: 
-- Module Name: 2to1MUX - Behavioral
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

entity MUX2to1 is
    Port ( selection : in STD_LOGIC;
           I1 : in STD_LOGIC;
           I2 : in STD_LOGIC;
           output : out STD_LOGIC);
end MUX2to1;

architecture Behavioral of MUX2to1 is
    signal  notSelect: STD_LOGIC;
    signal  nand1: STD_LOGIC;
    signal  nand2: STD_LOGIC;
begin
    c1: entity work.circuitNOT port map (I => selection, O => notSelect);
    c2: entity work.circuitNAND2 port map (A => I1, B => notSelect, R => nand1);
    c3: entity work.circuitNAND2 port map (A => I2, B => selection, R => nand2);
    c4: entity work.circuitNAND2 port map (A => nand1, B => nand2, R => output);

end Behavioral;
