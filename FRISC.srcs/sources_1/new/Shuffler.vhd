----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/26/2021 09:46:24 PM
-- Design Name: 
-- Module Name: Shuffler - Behavioral
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

entity Shuffler is
    Port ( address : in STD_LOGIC_VECTOR (31 downto 0);
           size : in STD_LOGIC_VECTOR (1 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0));
end Shuffler;

architecture Behavioral of Shuffler is
    signal alignment: STD_LOGIC_VECTOR (1 downto 0);
    constant N: integer := 32;
begin
    output(N - 1 downto 2) <= address(N - 1 downto 2);
    output(1 downto 0) <= alignment(1 downto 0);

    align: for i in 0 to 1 generate
        A_i: entity work.circuitAND2 port map(A => size(i), B => address(i), R => alignment(i));
    end generate;
end Behavioral;
