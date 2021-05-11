----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/4/2020 07:41:19 PM
-- Design Name: 
-- Module Name: fullAdder - Behavioral
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

entity fullAdder is
    Port ( A : in STD_LOGIC;
           B : in STD_LOGIC;
           Cin: in STD_LOGIC;
           S : out STD_LOGIC;
           Cout : out STD_LOGIC);
end fullAdder;

architecture Behavioral of fullAdder is
    signal Cfirst, Csecond, Sfirst: STD_LOGIC; 
begin
    c1: entity work.halfAdder port map(A, B, Sfirst, Cfirst);
    c2: entity work.halfAdder port map(Sfirst, Cin, S, Csecond);
    c3: entity work.circuitOR2 port map(Cfirst, Csecond, Cout);

end Behavioral;
