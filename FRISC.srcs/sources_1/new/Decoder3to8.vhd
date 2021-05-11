----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2021 08:37:23 PM
-- Design Name: 
-- Module Name: Decoder3to8 - Behavioral
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

entity Decoder3to8 is
    Port ( input : in STD_LOGIC_VECTOR (2 downto 0);
           output : out STD_LOGIC_VECTOR (7 downto 0);
           enable : in STD_LOGIC);
end Decoder3to8;

architecture Behavioral of Decoder3to8 is
    constant    N : integer := 3;
    signal inputWithInvert : STD_LOGIC_VECTOR (N * 2 - 1 downto 0);
begin
    for_c: for i in 0 to N - 1 generate
        c_i: entity work.circuitNOT port map(I => input(i), O => inputWithInvert(i * 2));
        c_j: inputWithInvert(i * 2 + 1) <= input(i);
    end generate;

    for_l1: for a in 0 to 1 generate
        for_l2: for b in 0 to 1 generate
            for_l3: for c in 0 to 1 generate
                gen: entity work.circuitAND4 port map(input(0) => inputWithInvert(c), input(1) => inputWithInvert(2 + b), input(2) => inputWithInvert(4 + a), input(3) => enable,
                        output => output(4 * a + 2 * b + c));
             end generate;
         end generate;
     end generate;    
end Behavioral;
