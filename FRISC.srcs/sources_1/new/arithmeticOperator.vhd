----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/6/2020 08:12:15 PM
-- Design Name: 
-- Module Name: arithmeticOperator - Behavioral
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

entity adder is
    Port ( operand1 : in STD_LOGIC_VECTOR (31 downto 0);
           operand2 : in STD_LOGIC_VECTOR (31 downto 0);
           carryIN  : in STD_LOGIC;
           result : out STD_LOGIC_VECTOR (31 downto 0);
           C : out STD_LOGIC;
           V: out STD_LOGIC);
end adder;

architecture Behavioral of adder is
    signal  carry: STD_LOGIC_VECTOR (32 downto 0);
    constant    n: integer := 32;

begin
    carry(0) <= carryIN;
    for_i: for i in 0 to n - 1 generate
        ci: entity work.fullAdder port map(A => operand1(i), B => operand2(i), Cin => carry(i), S => result(i), Cout => carry(i + 1));
    end generate;
    C <= carry(n);
    oVerflow: entity work.circuitXOR2 port map(A => carry(n), B => carry(n - 1), R => V); 

end Behavioral;
