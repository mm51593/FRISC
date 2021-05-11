----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2020 04:08:12 PM
-- Design Name: 
-- Module Name: MUX8to1 - Behavioral
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

entity MUX8to1 is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           selection : in STD_LOGIC_VECTOR (2 downto 0);
           output : out STD_LOGIC);
end MUX8to1;

architecture Behavioral of MUX8to1 is
    signal level2 : STD_LOGIC_VECTOR (1 downto 0);
    constant n : integer := 2;
begin
    for_i: for i in 0 to n - 1 generate
        ci: entity work.MUX4to1 port map(input => input(4 * i + 3 downto 4 * i), selection => selection(1 downto 0), output => level2(i));
    end generate;
    
    c1: entity work.MUX2to1 port map(I1 => level2(0), I2 => level2(1), selection => selection(2), output => output);
end Behavioral;
