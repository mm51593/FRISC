----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 28/04/2021 02:20:55 AM
-- Design Name: 
-- Module Name: FlatRegister - Behavioral
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

entity FlatRegister is
    Port ( d : in STD_LOGIC_VECTOR (31 downto 0);
           enable : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (31 downto 0));
end FlatRegister;

architecture Behavioral of FlatRegister is

begin


end Behavioral;
