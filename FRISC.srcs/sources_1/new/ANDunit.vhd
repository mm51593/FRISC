----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/6/2020 12:11:50 AM
-- Design Name: 
-- Module Name: ANDunit - Behavioral
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

entity ANDunit is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0); 
           C : out STD_LOGIC;
           V: out STD_LOGIC);
end ANDunit;

architecture Behavioral of ANDunit is
    constant    n: integer := 32; 
begin
    for_and: for i in 0 to n - 1 generate
        ci: entity work.circuitAND2 port map(A => operand1(i), B => operand2(i), R => result(i));
    end generate;

    C <= '0';
    V <= '0';
end Behavioral;
