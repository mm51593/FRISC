----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/3/2021 08:21:18 PM
-- Design Name: 
-- Module Name: ALU_full - Behavioral
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

entity ALU_full is
    Port ( RegA : in STD_LOGIC_VECTOR (2 downto 0);
           RegB : in STD_LOGIC_VECTOR (2 downto 0);
           RegWrite : in STD_LOGIC_VECTOR (2 downto 0);
           RegistryIn : in STD_LOGIC_VECTOR (31 downto 0);
           flagsIN: in STD_LOGIC_VECTOR (31 downto 0);
           Const : in STD_LOGIC_VECTOR (31 downto 0);
           ConstSelection : in STD_LOGIC_VECTOR (1 downto 0);
           instruction : in STD_LOGIC_VECTOR (3 downto 0);
           statusRegWrite: in STD_LOGIC;
           statusRegRead: in STD_LOGIC;
           writeEnable : in STD_LOGIC;
           statusWriteEnable : in STD_LOGIC;
           clk : in STD_LOGIC;
           result: out STD_LOGIC_VECTOR (31 downto 0);
           flagsOUT: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
           RegBOut : out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
           statusreg: out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
           A_out : out STD_LOGIC_VECTOR (31 downto 0);
           B_out : out STD_LOGIC_VECTOR (31 downto 0));

end ALU_full;

architecture Behavioral of ALU_full is
    signal operandA: STD_LOGIC_VECTOR (31 downto 0);
    signal operandB: STD_LOGIC_VECTOR (31 downto 0);
    signal flagsTemp: STD_LOGIC_VECTOR (31 downto 0);
    signal carry: STD_LOGIC;
    signal ALUresult: STD_LOGIC_VECTOR (31 downto 0);

begin
    registry: entity work.registry port map (registerA => RegA, registerB => RegB, registerIN => RegistryIN,
                        writeRegister => RegWrite, RawSelection => ConstSelection, rawData => Const, OpASelection => statusRegRead, 
                        statusInSelection => statusRegWrite, clk => clk, writeEnable => writeEnable, statusWriteEnable => statusWriteEnable, outA => operandA,
                        outB => operandB, flagsIN => flagsIN, statusFlags => flagsTemp, regBData => RegBOut, r1_test => A_out, r2_test => B_out);
    
    carry <= flagsTemp(1);
    statusreg <= flagsTemp;

    flagsOUT(31 downto 4) <= flagsTemp (31 downto 4);
    ArithmeticLogicUnit: entity work.ArithmeticLogicUnit port map (operandA => operandA, operandB => operandB,
                       carryIN => carry, operationSelect => instruction, clk => clk, result => result, flags => flagsOUT(3 downto 0));
end Behavioral;
