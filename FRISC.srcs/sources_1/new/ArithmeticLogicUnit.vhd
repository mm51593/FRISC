----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/6/2020 09:33:30 PM
-- Design Name: 
-- Module Name: ArithmeticLogicUnit - Behavioral
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

entity ArithmeticLogicUnit is
    Port ( operandA : in STD_LOGIC_VECTOR (31 downto 0);
           operandB : in STD_LOGIC_VECTOR (31 downto 0);
           carryIN : STD_LOGIC;
           operationSelect : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           A_out : out STD_LOGIC_VECTOR (31 downto 0);
           B_out : out STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           flags  : out STD_LOGIC_VECTOR (3 downto 0));
           
end ArithmeticLogicUnit;

architecture Behavioral of ArithmeticLogicUnit is
    signal  OpA: STD_LOGIC_VECTOR (31 downto 0);
    signal  OpB: STD_LOGIC_VECTOR (31 downto 0);
    signal  OpSel: STD_LOGIC_VECTOR (3 downto 0);
    
    signal  RegOPOut: STD_LOGIC_VECTOR (31 downto 0);

    signal  Bmuxed: STD_LOGIC_VECTOR (31 downto 0);
    signal  notB: STD_LOGIC_VECTOR (31 downto 0);
    signal  carryMUX: STD_LOGIC;
    
    signal  adderResult: STD_LOGIC_VECTOR (31 downto 0);
    signal  ANDResult: STD_LOGIC_VECTOR (31 downto 0);
    signal  ORResult: STD_LOGIC_VECTOR (31 downto 0);
    signal  XORResult: STD_LOGIC_VECTOR (31 downto 0);
    signal  shifterResult: STD_LOGIC_VECTOR (31 downto 0);
    
    signal adderFlags : STD_LOGIC_VECTOR (1 downto 0);
    signal ANDFlags : STD_LOGIC_VECTOR (1 downto 0);
    signal ORFlags : STD_LOGIC_VECTOR (1 downto 0);
    signal XORFlags : STD_LOGIC_VECTOR (1 downto 0);
    signal shifterFlags : STD_LOGIC_VECTOR (1 downto 0);
   
    signal  operationOuts: STD_LOGIC_VECTOR (31 downto 0);
    signal  Binvertselection: STD_LOGIC;
    
begin
    RegisterA: entity work.risingEdgeRegister port map(d => operandA, clk => clk, enable => '1', q => OpA);
    RegisterB: entity work.risingEdgeRegister port map(d => operandB, clk => clk, enable => '1', q => OpB);
    
    A_out <= OpA;
    B_out <= OpB;
    
    RegisterOP: entity work.risingEdgeRegister port map(d(3 downto 0) => operationSelect, d(31 downto 4) => "0000000000000000000000000000", clk => clk, enable => '1', q => RegOPOut);
    
    OpSel <= RegOPOut (3 downto 0);
    
    getBinvertselection: entity work.circuitOR3 port map(A => OpSel(3), B => OpSel(2), C => OpSel(1), R => Binvertselection);
    Bmux: entity work.operandBinverter port map(Braw => OpB, invert => Binvertselection, Bout => Bmuxed);
    
    getcarryIN: entity work.MUX8to1 port map(input(0) => '0', input(1) => carryIN, input(2) => '1', input(3) => carryIN, input(4) => '1', 
                input(7 downto 5) => "000", selection => OpSel(2 downto 0), output => carryMUX);

    adder: entity work.adder port map(operand1 => OpA, operand2 => Bmuxed, carryIN => carryMUX, result => adderResult, C => adderFlags(0), V=> adderFlags(1));
    andunit: entity work.ANDunit port map(operand1 => OpA, operand2 => OpB, result => ANDResult, C => ANDFlags(0), V => ANDFlags(1));
    orunit: entity work.ORunit port map(operand1 => OpA, operand2 => OpB, result => ORResult, C => ORFlags(0), V => ORFlags(1));
    xorunit: entity work.XORunit port map(operand1 => OpA, operand2 => OpB, result => XORResult, C => XORFlags(0), V => XORFlags(1));
    barrelshifter: entity work.BarrelShifter port map(input => OpA, shift => OpB, 
            OPselect => OpSel(2 downto 0), output => shifterResult, C => shifterFlags(0), V => shifterFlags(1));
    
    for_operations: for i in 0 to 31 generate
        ci: entity work.MUX16to1 port map(input(0) => adderResult(i), input(1) => adderResult(i), input(2) => adderResult(i),
                input(3) => adderResult(i), input(4) => adderResult(i), input(5) => ANDResult(i), input(6) => ORResult(i),
                input(7) => XORResult(i), input(8) => shifterResult(i), input(9) => shifterResult(i), input(10) => shifterResult(i),
                input(11) => shifterResult(i), input(12) => shifterResult(i), input(13) => OpB(i), input(15 downto 14) => "00", selector => OpSel,
                output => operationOuts(i));
    end generate;        

    carrypicker: entity work.MUX16to1 port map(input(0) => adderFlags(0), input(1) => adderFlags(0), input(2) => adderFlags(0),
                input(3) => adderFlags(0), input(4) => adderFlags(0), input(5) => ANDFlags(0), input(6) => ORFlags(0), 
                input(7) => XORFlags(0), input(8) => shifterFlags(0), input(9) => shifterFlags(0), input(10) => shifterFlags(0),
                input(11) => shifterFlags(0), input(12) => shifterFlags(0), input(15 downto 13) => "000", 
                selector => OpSel, output => flags(1));
                
    overflowpicker: entity work.MUX16to1 port map(input(0) => adderFlags(1), input(1) => adderFlags(1), input(2) => adderFlags(1),
                input(3) => adderFlags(1), input(4) => adderFlags(1), input(5) => ANDFlags(1), input(6) => ORFlags(1), 
                input(7) => XORFlags(1), input(8) => shifterFlags(1), input(9) => shifterFlags(1), input(10) => shifterFlags(1),
                input(11) => shifterFlags(1), input(12) => shifterFlags(1), input(15 downto 13) => "000", 
                selector => OpSel, output => flags(2));
                
    negative_zero: entity work.NZcalculator port map(input => operationOuts, N => flags(0), Z => flags(3));
    
    result <= operationOuts;
                
end Behavioral;
