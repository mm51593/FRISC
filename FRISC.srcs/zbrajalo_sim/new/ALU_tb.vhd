library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_tb is
end ALU_tb;

architecture bench of ALU_tb is
  component ArithmeticLogicUnit
    Port ( operandA : in STD_LOGIC_VECTOR (31 downto 0);
           operandB : in STD_LOGIC_VECTOR (31 downto 0);
           carryIN : STD_LOGIC;
           operationSelect : in STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           A_out : out STD_LOGIC_VECTOR (31 downto 0);
           B_out : out STD_LOGIC_VECTOR (31 downto 0);
           result : out STD_LOGIC_VECTOR (31 downto 0);
           flags  : out STD_LOGIC_VECTOR (3 downto 0));
  end component;

signal operandA : STD_LOGIC_VECTOR (31 downto 0);
signal operandB : STD_LOGIC_VECTOR (31 downto 0);
signal carryIN : STD_LOGIC;
signal operationSelect : STD_LOGIC_VECTOR (3 downto 0);
signal clk : STD_LOGIC;
signal result : STD_LOGIC_VECTOR (31 downto 0);
signal A_out: STD_LOGIC_VECTOR (31 downto 0);
signal B_out: STD_LOGIC_VECTOR (31 downto 0);
signal flags  : STD_LOGIC_VECTOR (3 downto 0);

begin
    uut: ArithmeticLogicUnit port map ( operandA    => operandA,
                                        operandB    => operandB,
                                        carryIN     => carryIN,
                                        operationSelect => operationSelect,
                                        clk         => clk,
                                        result      => result,
                                        flags       => flags,
                                        A_out       => A_out,
                                        B_out       => B_out);        

stimulus: process
begin
    clk <= '0';
    wait for 5 ns;
    
    operandA <= "00000000000000000011100000000000";
    operandB <= "00000001110000001000000000100000";
    
    operationSelect <= "0110";
    clk <= '1';
    
    wait;
end process;
end bench;
