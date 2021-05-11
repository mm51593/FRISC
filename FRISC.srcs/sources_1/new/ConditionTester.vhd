----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2021 10:17:12 PM
-- Design Name: 
-- Module Name: ConditionTester - Behavioral
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

entity ConditionTester is
    Port ( flags : in STD_LOGIC_VECTOR (3 downto 0);
           selection: in STD_LOGIC_VECTOR (3 downto 0);
           output : out STD_LOGIC);
end ConditionTester;

architecture Behavioral of ConditionTester is
    signal N: STD_LOGIC;
    signal C: STD_LOGIC;
    signal V: STD_LOGIC;
    signal Z: STD_LOGIC;
    
    signal not_N: STD_LOGIC;
    signal not_C: STD_LOGIC;
    signal not_V: STD_LOGIC;
    signal not_Z: STD_LOGIC;
    
    signal N_xor_V: STD_LOGIC;
    signal not_N_xor_V: STD_LOGIC;
    
    signal ULE: STD_LOGIC;
    signal UGT: STD_LOGIC;
    signal SLE: STD_LOGIC;
    signal SGT: STD_LOGIC;
    signal SLT: STD_LOGIC;
    signal SGE: STD_LOGIC;
begin
    N <= flags(0);
    C <= flags(1);
    V <= flags(2);
    Z <= flags(3);
    
    negate_N: entity work.circuitNOT port map(I => N, O => not_N);
    negate_C: entity work.circuitNOT port map(I => C, O => not_C);
    negate_V: entity work.circuitNOT port map(I => V, O => not_V);
    negate_Z: entity work.circuitNOT port map(I => Z, O => not_Z);
    
    NxV: entity work.circuitXOR2 port map(A => N, B => V, R => N_xor_V);
    NNxV: entity work.circuitNOT port map(I => N_xor_V, O => not_N_xor_V);
    
    get_ULE: entity work.circuitOR2 port map(A => not_C, B => Z, R => ULE);
    get_UGT: entity work.circuitOR2 port map(A => C, B => not_Z, R => UGT);
    get_SLE: entity work.circuitOR2 port map(A => N_xor_V, B => Z, R => SLE);
    get_SGT: entity work.circuitOR2 port map(A => not_N_xor_V, B => not_Z, R => SGT); 
    
    MUX: entity work.MUX16to1 port map(input(0) => '1', input(1) => C, input(2) => not_C, input(3) => V, input(4) => not_V, input(5) => N,
            input(6) => not_N, input(7) => Z, input(8) => not_Z, input(9) => ULE, input(10) => UGT, input(11) => SLE, input(12) => SGT,
            input(13) => N_xor_V, input(14) => not_N_xor_V, selector => selection, output => output);
end Behavioral;
