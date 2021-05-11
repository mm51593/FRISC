----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2021 01:18:13 AM
-- Design Name: 
-- Module Name: Extender - Behavioral
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

entity Extender is
    Port ( input : in STD_LOGIC_VECTOR (19 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end Extender;

architecture Behavioral of Extender is

begin
    output(19 downto 0) <= input;
    
    fill: for i in 20 to 31 generate
        b_i: output(i) <= input(19);
    end generate;

end Behavioral;
