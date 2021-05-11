----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/7/2020 01:06:09 AM
-- Design Name: 
-- Module Name: operandBmux - Behavioral
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

entity operandBinverter is
    Port ( Braw : in STD_LOGIC_VECTOR (31 downto 0);
           invert : in STD_LOGIC;
           Bout : out STD_LOGIC_VECTOR (31 downto 0));
end operandBinverter;

architecture Behavioral of operandBinverter is
    constant    n: integer := 32;
begin
    for_not: for i in 0 to n - 1 generate
        ci: entity work.circuitXOR2 port map(A => Braw(i), B => invert, R => Bout(i));
    end generate;

end Behavioral;
