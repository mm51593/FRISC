----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/13/2021 11:50:59 PM
-- Design Name: 
-- Module Name: RAM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAM4 is
    Port ( clk : in STD_LOGIC;
           address : in STD_LOGIC_VECTOR (31 downto 0);
           read : in STD_LOGIC;
           write : in STD_LOGIC;
           size: in STD_LOGIC_VECTOR (1 downto 0);
           datafinal : inout STD_LOGIC_VECTOR (31 downto 0);
           waitsig : out STD_LOGIC := '0';
           datatest : out STD_LOGIC_VECTOR (31 downto 0));
end RAM4;

architecture Behavioral of RAM4 is
-- define the new type for the 128x8 RAM 
type RAM_ARRAY is array (0 to 127 ) of std_logic_vector (7 downto 0);
-- initial values in the RAM
signal RAM: RAM_ARRAY :=( 
   x"7C",x"00",x"00",x"10",-- 0x00:
   x"C0",x"80",x"00",x"10",-- 0x04: 
   x"00",x"00",x"00",x"40",-- 0x08: 
   x"E8",x"00",x"00",x"00",-- 0x0C: 
   x"6F",x"80",x"00",x"80",-- 0x10: 
   x"04",x"00",x"00",x"02",-- 0x14: 
   x"04",x"00",x"00",x"03",-- 0x18: 
   x"04",x"00",x"00",x"04",-- 0x1C: 
   x"04",x"00",x"00",x"05",-- 0x20: 
   x"04",x"00",x"00",x"06",-- 0x24: 
   x"FF",x"00",x"00",x"00",-- 0x28: 
   x"04",x"00",x"00",x"0C",-- 0x2C: 
   x"34",x"A0",x"5C",x"99",-- 0x30: 
   x"00",x"00",x"00",x"00",-- 0x34: 
   x"00",x"00",x"00",x"00",-- 0x38: 
   x"00",x"00",x"00",x"00",-- 0x3C: 
   x"E0",x"00",x"00",x"00",-- 0x40: 
   x"00",x"00",x"00",x"00",-- 0x44: 
   x"00",x"00",x"00",x"00",-- 0x48: 
   x"00",x"00",x"00",x"00",-- 0x4C: 
   x"00",x"00",x"00",x"00",-- 0x50: 
   x"00",x"00",x"00",x"00",-- 0x54: 
   x"00",x"00",x"00",x"00",-- 0x58: 
   x"00",x"00",x"00",x"00",-- 0x5C: 
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00",
   --x"00",x"00",x"00",x"00",
   --x"00",x"00",x"00",x"00",
   x"00",x"00",x"00",x"00"
   ); 
signal data: STD_LOGIC_VECTOR (31 downto 0);
begin
process(address, clk, read, write)
begin
 --if(rising_edge(clk)) then
    if (read = '1') then
        waitsig <= '1';
        if (size = "00") then
            data(7 downto 0) <= RAM(to_integer(unsigned(address)) + 3);
            data(15 downto 8) <= RAM(to_integer(unsigned(address)) + 2);
            data(23 downto 16) <= RAM(to_integer(unsigned(address)) + 1);
            data(31 downto 24) <= RAM(to_integer(unsigned(address)));
        elsif (size = "10") then
            data(7 downto 0) <= RAM(to_integer(unsigned(address)) + 1);
            data(15 downto 8) <= RAM(to_integer(unsigned(address)));
            data(31 downto 16) <= "0000000000000000";
        elsif (size = "11") then
            data(7 downto 0) <= RAM(to_integer(unsigned(address)));
            data(31 downto 8) <= "000000000000000000000000";
        end if;
        waitsig <= '0';
    elsif (write = '1') then
        data <= (others => 'Z');
        waitsig <= '1';
        if (size = "00") then
            RAM(to_integer(unsigned(address)) + 3) <= data(7 downto 0);
            RAM(to_integer(unsigned(address)) + 2) <= data(15 downto 8);
            RAM(to_integer(unsigned(address)) + 1) <= data(23 downto 16);
            RAM(to_integer(unsigned(address))) <= data(31 downto 24);
        elsif (size = "10") then
            RAM(to_integer(unsigned(address)) + 1) <= data(7 downto 0);
            RAM(to_integer(unsigned(address))) <= data(15 downto 8);
        elsif (size = "11") then
            RAM(to_integer(unsigned(address))) <= data(7 downto 0);
        end if;
        waitsig <= '0';
    else
        data <= (others => 'Z');
    end if;
 --end if;
end process;
    datatest <= data;
    datafinal <= data;
end Behavioral;
