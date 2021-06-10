----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2021 08:08:19 AM
-- Design Name: 
-- Module Name: Complete - Behavioral
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

entity Complete is
    Port ( clk : in STD_LOGIC;
           addressout : out STD_LOGIC_VECTOR (31 downto 0);
           dataout : out STD_LOGIC_VECTOR (31 downto 0);
           readout: out STD_LOGIC;
           writeout: out STD_LOGIC;
           waitsigout: out STD_LOGIC;
           sizeout: out STD_LOGIC_VECTOR (1 downto 0);
           instruction: out STD_LOGIC_VECTOR(31 downto 0);
           regenable: out STD_LOGIC_VECTOR (31 downto 0);
           regin: out STD_LOGIC_VECTOR (31 downto 0));
end Complete;

architecture Behavioral of Complete is
    type wrapper is array (1 downto 0) of STD_LOGIC_VECTOR (31 downto 0);
    signal temp: wrapper;
    signal waitsig: STD_LOGIC;
    signal interrupt: STD_LOGIC_VECTOR (1 downto 0);
    signal address: STD_LOGIC_VECTOR (31 downto 0);
    signal data: STD_LOGIC_VECTOR (31 downto 0);
    signal size: STD_LOGIC_VECTOR (1 downto 0);
    signal read: STD_LOGIC;
    signal write: STD_LOGIC;
begin
    FRISC: entity work.FRISC port map(clk => clk, address => address, data => data, waitsig => waitsig, interrupt => interrupt, sizeout => size,
                read => read, write => write, pctest => instruction, A_out => regenable, B_out => regin);
                
    RAM: entity work.RAM port map(clk => clk, address => address, datafinal => data, waitsig => waitsig, read => read, write => write, size => size);
    
    addressout <= address;
    dataout <= data;
    
    readout <= read;
    writeout <= write;
    waitsigout <= waitsig;
    sizeout <= size;

end Behavioral;
