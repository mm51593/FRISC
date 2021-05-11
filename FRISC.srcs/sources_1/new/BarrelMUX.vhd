----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/21/2020 09:06:11 PM
-- Design Name: 
-- Module Name: BarrelMUX - Behavioral
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


--input(0): left logic shift
--input(1): right logic shift
--input(2): right arithmetic shift
--input(3): left rotation
--input(4): right rotation 

entity BarrelMUX is
    Port ( input : in STD_LOGIC_VECTOR (7 downto 0);
           pass : in STD_LOGIC;
           selection : in STD_LOGIC_VECTOR (2 downto 0);
           enable : in STD_LOGIC;
           output : out STD_LOGIC);
end BarrelMUX;

architecture Behavioral of BarrelMUX is
    signal muxed : STD_LOGIC;
begin
    c1: entity work.MUX8to1 port map(input => input, selection => selection, output => muxed);
    c2: entity work.MUX2to1 port map(I1 => pass, I2 => muxed, selection => enable, output => output);

end Behavioral;
