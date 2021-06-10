----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2021 08:07:50 PM
-- Design Name: 
-- Module Name: registry - Behavioral
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

entity registry is
    Port ( registerA : in STD_LOGIC_VECTOR (2 downto 0);
           registerB : in STD_LOGIC_VECTOR (2 downto 0);
           writeRegister : in STD_LOGIC_VECTOR (2 downto 0);
           rawSelection : in STD_LOGIC_VECTOR (1 downto 0);
           opAselection: in STD_LOGIC;
           rawData : in STD_LOGIC_VECTOR (31 downto 0);
           registerIN : in STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
           flagsIN : in STD_LOGIC_VECTOR (31 downto 0);
           clk : in STD_LOGIC;
           writeEnable : in STD_LOGIC;
           statusInSelection : in STD_LOGIC;
           statusWriteEnable : in STD_LOGIC;
           outA : out STD_LOGIC_VECTOR (31 downto 0);
           outB : out STD_LOGIC_VECTOR (31 downto 0);
           statusFlags : out STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
           regBdata : out STD_LOGIC_VECTOR (31 downto 0);
           r1_test: out STD_LOGIC_VECTOR (31 downto 0);
           r2_test: out STD_LOGIC_VECTOR (31 downto 0);
           r3_test: out STD_LOGIC_VECTOR (31 downto 0));
end registry;

architecture Behavioral of registry is
    signal  regEnable : STD_LOGIC_VECTOR (7 downto 0) := "00000000";
    type    regARR is array (0 to 7) of STD_LOGIC_VECTOR (31 downto 0);
    signal  regWriteBuffer : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal  BRawDataPicked : STD_LOGIC_VECTOR (31 downto 0);
    signal  regOuts : regARR;
    
    signal R0: STD_LOGIC_VECTOR (31 downto 0);
    signal R1: STD_LOGIC_VECTOR (31 downto 0);
    signal R2: STD_LOGIC_VECTOR (31 downto 0);
    signal R3: STD_LOGIC_VECTOR (31 downto 0);
    signal R4: STD_LOGIC_VECTOR (31 downto 0);
    signal R5: STD_LOGIC_VECTOR (31 downto 0);
    signal R6: STD_LOGIC_VECTOR (31 downto 0);
    signal R7: STD_LOGIC_VECTOR (31 downto 0);
    --signal  regIn : STD_LOGIC_VECTOR (31 downto 0);
    signal  outAReg: STD_LOGIC_VECTOR (31 downto 0);
    signal  outBReg: STD_LOGIC_VECTOR (31 downto 0);
    signal  statusRegOut: STD_LOGIC_VECTOR (31 downto 0);
    constant N : integer := 32;
    constant increment : STD_LOGIC_VECTOR := "001000000000000000000000000000000";
begin
    registers: for i in 0 to 7 generate
        c_i: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(i), q => regOuts(i));
    end generate;
    
    Reg0: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(0), q => R0);
    Reg1: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(1), q => R1);
    Reg2: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(2), q => R2);
    Reg3: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(3), q => R3);
    Reg4: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(4), q => R4);
    Reg5: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(5), q => R5);
    Reg6: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(6), q => R6);
    Reg7: entity work.fallingEdgeRegister port map(d => registerIN, clk => clk, enable => regEnable(7), q => R7);
    
    r1_test(1 downto 0) <= rawSelection;
    r2_test <= rawData;
    r3_test <= registerIn;
    
    getOutAReg: for i in 0 to N - 1 generate
        c_A: entity work.MUX8to1 port map(input(0) => r0(i),
                    input(1) => r1(i),
                    input(2) => r2(i),
                    input(3) => r3(i),
                    input(4) => r4(i),
                    input(5) => r5(i),
                    input(6) => r6(i),
                    input(7) => r7(i), selection => registerA, output => outAReg(i));
    end generate;
    
    getOutBReg: for i in 0 to N - 1 generate
        c_B: entity work.MUX8to1 port map(input(0) => r0(i),
                    input(1) => r1(i),
                    input(2) => r2(i),
                    input(3) => r3(i),
                    input(4) => r4(i),
                    input(5) => r5(i),
                    input(6) => r6(i),
                    input(7) => r7(i), selection => registerB, output => outBReg(i));
    end generate;
    
    regBData <= outBReg;
    
    getRawDataPick: for i in 0 to N - 1 generate
        c_C: entity work.MUX4to1 port map(input(0) => outBReg(i), input(1) => rawData(i), input(2) => increment(i), input(3) => '0', selection => rawSelection, output => BRawDataPicked(i));
    end generate;
    
    getOpA: for i in 0 to N - 1 generate
        M_i: entity work.MUX2to1 port map(I1 => outAReg(i), I2 => statusRegOut(i), selection => OpAselection, output => outA(i));
    end generate;

    outB <= BRawDataPicked;
    
    --getOutA: entity work.fallingEdgeRegister port map(d => outAReg, clk => clk, enable => '1', q => outA);
    --getOutB: entity work.fallingEdgeRegister port map(d => outBReg, clk => clk, enable => '1', q => outB);
    
    bufferWriteRegister: entity work.risingEdgeRegister port map(d(2 downto 0) => writeRegister, d(3) => writeEnable, d(4) => statusWriteEnable, d(5) => statusInselection,
                            d(31 downto 6) => "00000000000000000000000000", clk => clk, enable => '1', q => regWriteBuffer);
                              
    regWrite: entity work.Decoder3to8 port map(input => regWriteBuffer(2 downto 0), output => regEnable, enable => regWriteBuffer(3));
    
    statusRegisterInMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX2to1 port map (I1 => flagsIN(i), I2 => registerIN(i), selection => regWriteBuffer(5), output => statusRegOut(i));
    end generate;
            
    statusRegister: entity work.fallingEdgeRegister port map (d => statusRegOut,
                    clk => clk, enable => regWriteBuffer(4), q => statusFlags);

end Behavioral;
