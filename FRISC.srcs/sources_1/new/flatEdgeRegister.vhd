----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/05/2021 05:49:27 PM
-- Design Name: 
-- Module Name: flatEdgeRegister - Behavioral
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

entity flatEdgeRegister is
    Port ( d : in STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (31 downto 0));
end flatEdgeRegister;

architecture Behavioral of flatEdgeRegister is

begin
    process(enable, d)
    begin
        if enable = '1' then
            q <= d;
         end if;
    end process;


end Behavioral;
