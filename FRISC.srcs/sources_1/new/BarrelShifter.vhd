----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/20/2020 10:31:44 PM
-- Design Name: 
-- Module Name: BarrelShifter - Behavioral
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
use IEEE.math_real.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity BarrelShifter is
    Port ( input : in STD_LOGIC_VECTOR (31 downto 0);
           shift : in STD_LOGIC_VECTOR (31 downto 0);
           OPselect : in STD_LOGIC_VECTOR (2 downto 0);
           output : out STD_LOGIC_VECTOR (31 downto 0);
           C : out STD_LOGIC;
           V : out STD_LOGIC);
end BarrelShifter;

architecture Behavioral of BarrelShifter is
    constant n : integer := 32;
    constant m : integer := 6;
    signal shift_trunc : STD_LOGIC_VECTOR (m - 1 downto 0);
    type ARR is array (0 to m) of STD_LOGIC_VECTOR (31 downto 0);
    type ARR_short is array (0 to n - 1) of STD_LOGIC_VECTOR (7 downto 0);
    type ARR_long is array (0 to m - 1) of ARR_short;
    signal levels : ARR;
    signal BarrelMUXins : ARR_long;
    type ARR_carry is array (0 to m) of STD_LOGIC_VECTOR (1 downto 0);
    signal carry_flag : ARR_carry;
    signal carry_selection : STD_LOGIC;
begin
    shift_trunc (m - 2 downto 0) <= shift(m - 2 downto 0);
    shift_highest_bit: entity work.circuitOR32 port map(input(m - 2 downto 0) => "00000", input(31 downto m - 1) => shift(31 downto m - 1), output => shift_trunc(m - 1));

    levels(0) <= input;
    carry_flag(0) <= "00";
    for_i: for i in 0 to n - 1 generate
        for_j: for j in 0 to m - 1 generate
            BarrelMUXins(j)(i)(3) <= levels(j)((i - 2 ** j) mod n); -- ROTL
            BarrelMUXins(j)(i)(4) <= levels(j)((i + 2 ** j) mod n); -- ROTR
            
            LSHIFT_overflow: if (i - 2 ** j) < 0 generate
                BarrelMUXins(j)(i)(0) <= '0'; -- SHL
            end generate;
            LSHIFT_no_overflow: if (i - 2 ** j) >= 0 generate     -- SHL
                BarrelMUXins(j)(i)(0) <= levels(j)((i - 2 ** j));
            end generate;
            
            RSHIFT_overflow: if (i + 2 ** j) > (n - 1) generate
                BarrelMUXins(j)(i)(1) <= '0';       -- SHR
                BarrelMUXins(j)(i)(2) <= levels(0)(n - 1);  -- ASHR
            end generate;
            RSHIFT_no_overflow: if (i + 2 ** j) <= (n - 1) generate
                BarrelMUXins(j)(i)(1) <= levels(j)((i + 2 ** j) mod n); -- SHR
                BarrelMUXins(j)(i)(2) <= levels(j)((i + 2 ** j) mod n); -- ASHR
            end generate;
            
            c1: entity work.BarrelMUX port map(pass => levels(j)(i), selection => OPselect, enable => shift_trunc(j), output => levels(j + 1)(i),
                input => BarrelMUXins(j)(i));
            
            CARRY1: if (i + 2 ** j) = n generate 
                carry_higher: entity work.MUX2to1 port map(I1 => carry_flag(j)(1), I2 => levels(j)(i), selection => shift_trunc(j), output => carry_flag(j + 1)(1));
            end generate;
            CARRY0: if (i - 2 ** j) = -1 generate
                carry_lower: entity work.MUX2to1 port map(I1 => carry_flag(j)(0), I2 => levels(j)(i), selection => shift_trunc(j), output => carry_flag(j + 1)(0));
            end generate;
        end generate;
    end generate;
        
    output <= levels(m);
    
    carry_select: entity work.MUX8to1 port map(input(0) => carry_flag(m)(1), input(1) => carry_flag(m)(0), input(2) => carry_flag(m)(0),
                                                input(3) => carry_flag(m)(1), input(4) => carry_flag(m)(0), input(7 downto 5) => "000",
                                                selection => OPselect, output => C);
    V <= '0';
end Behavioral;
