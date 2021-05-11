----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/7/2020 01:37:22 AM
-- Design Name: 
-- Module Name: StatusFlags - Behavioral
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

entity NZcalculator is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           Z : out STD_LOGIC;
           N : out STD_LOGIC);
end NZcalculator;

architecture Behavioral of NZcalculator is
    signal  and32: STD_LOGIC;
begin
    c1: entity work.circuitOR32 port map (input => input, output => and32);
    c2: entity work.circuitNOT port map (I => and32, O => Z);
    N <= input(31);

end Behavioral;
