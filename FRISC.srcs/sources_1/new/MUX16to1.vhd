----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/7/2020 01:21:47 AM
-- Design Name: 
-- Module Name: MUX16to1 - Behavioral
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

entity MUX16to1 is
    Port ( input : in STD_LOGIC_VECTOR (15 downto 0);
           selector : in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC);
end MUX16to1;

architecture Behavioral of MUX16to1 is
    signal  processedInput: STD_LOGIC_VECTOR(3 downto 0);
    constant    n: integer := 4;
    
begin
    for_i: for i in 0 to n - 1 generate
        ci: entity work.MUX4to1 port map(input => input(4 * i + 3 downto 4 * i), output => processedInput(i), selection => selector(1 downto 0));
    end generate;
    
    c1: entity work.MUX4to1 port map(input => processedInput, output => output, selection => selector(3 downto 2));

end Behavioral;
