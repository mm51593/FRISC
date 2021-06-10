----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/04/2021 11:55:24 PM
-- Design Name: 
-- Module Name: FRISC - Behavioral
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

entity FRISC is
    Port ( clk : in STD_LOGIC;
           waitsig: in STD_LOGIC;
           interrupt: in STD_LOGIC_VECTOR (1 downto 0);
           data : inout STD_LOGIC_VECTOR (31 downto 0);
           address: out STD_LOGIC_VECTOR (31 downto 0);
           sizeout : out STD_LOGIC_VECTOR (1 downto 0);
           read: out STD_LOGIC;
           write: out STD_LOGIC;
           PCtest: out STD_LOGIC_VECTOR (31 downto 0);
           A_out : out STD_LOGIC_VECTOR (31 downto 0);
           B_out : out STD_LOGIC_VECTOR (31 downto 0));
end FRISC;

architecture Behavioral of FRISC is
    signal regApick: STD_LOGIC_VECTOR (2 downto 0);
    signal regBpick: STD_LOGIC_VECTOR (2 downto 0);
    signal regwritepick: STD_LOGIC_VECTOR (2 downto 0);
    signal operandApick: STD_LOGIC;
    signal operandBpick: STD_LOGIC_VECTOR (1 downto 0);
    signal opsel: STD_LOGIC_VECTOR (3 downto 0);
    signal regwriteenable: STD_LOGIC;
    signal regtostatusenable: STD_LOGIC;
    signal statuswriteenable: STD_LOGIC;
    signal statusregin: STD_LOGIC_VECTOR (31 downto 0);
    signal statusregout: STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal aluflagsout: STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal regBout : STD_LOGIC_VECTOR (31 downto 0);
    signal ALUresult : STD_LOGIC_VECTOR (31 downto 0);
    signal condition: STD_LOGIC_VECTOR (3 downto 0);
    signal size: STD_LOGIC_VECTOR (1 downto 0);
    
    signal dataRegMUXOut : STD_LOGIC_VECTOR (31 downto 0);
    signal dataRegOut: STD_LOGIC_VECTOR (31 downto 0);
    
    signal instruction: STD_LOGIC_VECTOR (31 downto 0);
    signal instructionwrite: STD_LOGIC;
    signal reading: STD_LOGIC;
    signal writing: STD_LOGIC;
    
    signal registryMUXOut: STD_LOGIC_VECTOR (31 downto 0);
    
    signal const: STD_LOGIC_VECTOR (19 downto 0);
    signal extenderOut: STD_LOGIC_VECTOR (31 downto 0);
    
    signal GIEnegate: STD_LOGIC; 
    
    signal PCIncrementMUXCondition: STD_LOGIC;
    signal PCIncrementPickFinal: STD_LOGIC;
    signal PCIncrementMUXOut: STD_LOGIC_VECTOR (31 downto 0);
    signal PCIncremented: STD_LOGIC_VECTOR (31 downto 0);
    signal PCInMUX: STD_LOGIC_VECTOR (31 downto 0);
    signal PCOut: STD_LOGIC_VECTOR (31 downto 0);
    
    signal PCDecrementMUXOut: STD_LOGIC_VECTOR (31 downto 0);
    signal PCDecremented: STD_LOGIC_VECTOR (31 downto 0);
    
    signal AddressRegisterMUXOut: STD_LOGIC_VECTOR (31 downto 0);
    signal AddressShufflerOut: STD_LOGIC_VECTOR (31 downto 0);
    signal AddressWrite: STD_LOGIC;
    
    signal reginpick: STD_LOGIC_VECTOR (1 downto 0);
    signal drpick: STD_LOGIC_VECTOR (1 downto 0);
    signal pcinc: STD_LOGIC;
    signal pcpick: STD_LOGIC_VECTOR (2 downto 0);
    signal pcdec: STD_LOGIC;
    signal arpick: STD_LOGIC_VECTOR (1 downto 0);
    signal gieselect: STD_LOGIC;
    
    constant N : integer := 32;
    constant increment : STD_LOGIC_VECTOR := "00100000000000000000000000000000";
    constant incrementComplement: STD_LOGIC_VECTOR := "11011111111111111111111111111111";
    constant MIaddress:  STD_LOGIC_VECTOR := "00010000000000000000000000000000";
    constant NMIaddress: STD_LOGIC_VECTOR := "00110000000000000000000000000000";
begin
    ALU: entity work.ALU_FULL port map(RegA => regAPick, RegB => regBPick, RegistryIN => registryMUXOut, RegWrite => regwritepick, Const => extenderOut,
            statusregwrite => regtostatusenable, statusregread => operandApick, 
            constSelection => operandBpick, instruction => opsel, writeEnable => regwriteenable, statusWriteEnable => statuswriteenable,
            clk => clk, flagsIN => statusregin, flagsOUT => aluflagsout, RegBOut => regBout, result => ALUresult, statusreg => statusregout,
            A_out => A_out, B_out => B_out);

    --B_out <= ALUresult;

    negGIE: entity work.circuitNOT port map(I => aluflagsout(4), O => GIEnegate);
    GIEMUX: entity work.MUX2to1 port map(I1 => aluflagsout(4), I2 => GIEnegate, selection => gieselect, output => statusregin(4));
    
    SR_in: for i in 0 to N - 1 generate
        SR_notGIE: if i /= 4 generate
            statusregin(i) <= aluflagsout(i);
        end generate;
    end generate;
     
    dataRegMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX4to1 port map(input(0) => PCDecremented(i), input(1) => data(i), input(2) => regBout(i), input(3) => '0', selection => drpick, output => dataRegMUXOut(i));
    end generate;
    
    dataRegister: entity work.flatEdgeRegister port map(d => dataRegMUXOut, enable => '1', q => dataRegOut);
    
    instructionRegister: entity work.flatEdgeRegister port map(d => data, enable => instructionwrite, q => instruction);
    --instructionwriteout <= instructionwrite;
    
    registryInMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX4to1 port map(input(0) => ALUresult(i), input(1) => aluflagsout(i), input(2) => dataRegOut(i), input(3) => '0',
                    selection => reginpick, output => registryMUXOut(i));
    end generate;
    
    extender: entity work.Extender port map(input => const, output => extenderOut);
    
    PCMUXCondition: entity work.ConditionTester port map(flags => statusregout(3 downto 0), selection => condition, output => PCIncrementMUXCondition);
    PCMUXAND: entity work.circuitAND2 port map(A => pcinc, B => PCIncrementMUXCondition, R => PCIncrementPickFinal);
    PCIncrementMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX2to1 port map(I1 => increment(i), I2 => extenderOut(i), selection => PCIncrementPickFinal, output => PCIncrementMUXOut(i));
    end generate;
    
    PCIncrement: entity work.adder port map(operand1 => PCIncrementMUXOut, operand2 => PCOut, carryIN => '0', result => PCIncremented);
    
    PCMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX8to1 port map(input(0) => PCOut(i), input(1) => PCIncremented(i), input(2) => extenderOut(i), input(3) => regBout(i),
                input(4) => NMIaddress(i), input(5) => dataRegOut(i), input(7 downto 6) => "00", selection => pcpick, output => PCInMUX(i));
    end generate;
                
    PC: entity work.fallingEdgeRegister port map(d => PCInMUX, clk => clk, enable => '1', q => PCOut);
    
    PCDecrementMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX2to1 port map(I1 => '1', I2 => incrementComplement(i), selection => pcdec, output => PCDecrementMUXOut(i));
    end generate;
    
    PCDecrement: entity work.adder port map(operand1 => PCOut, operand2 => PCDecrementMUXOut, carryIN => '1', result => PCDecremented);
    
    addressRegisterMUX: for i in 0 to N - 1 generate
        M_i: entity work.MUX4to1 port map(input(0) => PCOut(i), input(1) => ALUresult(i), input(2) => MIaddress(i), input(3) => NMIaddress(i),
                selection => arpick, output => AddressRegisterMUXOut(i));
    end generate;
    
    addressShuffler: entity work.Shuffler port map(address => AddressRegisterMUXOut, size => size, output => AddressShufflerOut);
    
    address <= AddressShufflerOut;
    --addressRegister: entity work.risingEdgeRegister port map(d => AddressShufflerOut, clk => AddressWrite, enable => '1', q => address);
    
    CU: entity work.ControlUnit port map(instruction => instruction, waitsig => waitsig, clk => clk, previous_condition => PCIncrementMUXCondition,
            regin => reginpick, opbpick => operandBpick, opcode => opsel, pcinc => pcinc, pcpick => pcpick, drpick => drpick, arpick => arpick,
            pcdec => pcdec, gieselect => gieselect, const => const, size => size, regA => regApick, regB => regBpick, regWrite => regwritepick,
            statusregwrite => regtostatusenable, statusregread => operandApick, writeenable => regwriteenable, statuswriteenable => statuswriteenable, 
            conditionout => condition, interrupt => interrupt, GIE => statusregout(4), readfinal => reading, writefinal => writing, instructionwrite => instructionwrite,
            instructiontest => PCtest);
    
    read <= reading;
    write <= writing;
    data <= dataregout when writing = '1' else (others => 'Z');
    sizeout <= size;
end Behavioral;
