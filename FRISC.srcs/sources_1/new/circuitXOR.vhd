----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/4/2020 07:33:03 PM
-- Design Name: 
-- Module Name: circuitXOR - Behavioral
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

entity circuitXOR2 is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           R : out STD_LOGIC);
end circuitXOR2;

architecture Behavioral of circuitXOR2 is

begin
    R <= A xor B;

end Behavioral;
