library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity ALU_full_tb is
end;

architecture bench of ALU_full_tb is

  component ALU_full
      Port ( RegA : in STD_LOGIC_VECTOR (2 downto 0);
             RegB : in STD_LOGIC_VECTOR (2 downto 0);
             RegWrite : in STD_LOGIC_VECTOR (2 downto 0);
             Const : in STD_LOGIC_VECTOR (31 downto 0);
             ConstSelection : in STD_LOGIC;
             instruction : in STD_LOGIC_VECTOR (3 downto 0);
             writeEnable : in STD_LOGIC;
             statusWriteEnable : in STD_LOGIC;
             clk : in STD_LOGIC;
             flagsOUT: out STD_LOGIC_VECTOR (31 downto 0);
             ALU_inputA : out STD_LOGIC_VECTOR (31 downto 0);
             ALU_inputB : out STD_LOGIC_VECTOR (31 downto 0);
             ALU_res : out STD_LOGIC_VECTOR (31 downto 0);
             R0 : out STD_LOGIC_VECTOR (31 downto 0);
             R1 : out STD_LOGIC_VECTOR (31 downto 0);
             R2 : out STD_LOGIC_VECTOR (31 downto 0);
             R3 : out STD_LOGIC_VECTOR (31 downto 0);
             R4 : out STD_LOGIC_VECTOR (31 downto 0);
             R5 : out STD_LOGIC_VECTOR (31 downto 0);
             R6 : out STD_LOGIC_VECTOR (31 downto 0);
             R7 : out STD_LOGIC_VECTOR (31 downto 0));
  end component;

  signal RegA: STD_LOGIC_VECTOR (2 downto 0);
  signal RegB: STD_LOGIC_VECTOR (2 downto 0);
  signal RegWrite: STD_LOGIC_VECTOR (2 downto 0);
  signal Const: STD_LOGIC_VECTOR (31 downto 0);
  signal ConstSelection: STD_LOGIC;
  signal command: STD_LOGIC_VECTOR (3 downto 0);
  signal writeEnable: STD_LOGIC;
  signal statusWriteEnable: STD_LOGIC;
  signal clk: STD_LOGIC;
  signal flagsOUT: STD_LOGIC_VECTOR (31 downto 0);
  signal ALU_inputA : STD_LOGIC_VECTOR (31 downto 0);
  signal ALU_inputB : STD_LOGIC_VECTOR (31 downto 0);
  signal ALU_res : STD_LOGIC_VECTOR (31 downto 0);
  signal R0: STD_LOGIC_VECTOR (31 downto 0);
  signal R1: STD_LOGIC_VECTOR (31 downto 0);
  signal R2: STD_LOGIC_VECTOR (31 downto 0);
  signal R3: STD_LOGIC_VECTOR (31 downto 0);
  signal R4: STD_LOGIC_VECTOR (31 downto 0);
  signal R5: STD_LOGIC_VECTOR (31 downto 0);
  signal R6: STD_LOGIC_VECTOR (31 downto 0);
  signal R7: STD_LOGIC_VECTOR (31 downto 0);

begin

  uut: ALU_full port map ( RegA              => RegA,
                           RegB              => RegB,
                           RegWrite          => RegWrite,
                           Const             => Const,
                           ConstSelection    => ConstSelection,
                           instruction           => command,
                           writeEnable       => writeEnable,
                           statusWriteEnable => statusWriteEnable,
                           clk               => clk,
                           flagsOUT          => flagsOUT,
                           ALU_inputA        => ALU_inputA,
                           ALU_inputB        => ALU_inputB,
                           ALU_res           => ALU_res,
                           R0                => R0,
                           R1                => R1,
                           R2                => R2,
                           R3                => R3,
                           R4                => R4,
                           R5                => R5,
                           R6                => R6,
                           R7                => R7 );

  stimulus: process
  begin
        clk <= '0';
        --ConstSelection <= '0';
        --wait for 10 ns;
        
        
        -- 1.
        RegA <= "000";  -- R0
        RegWrite <= "001";  -- R1
        Const <= "10100000000000000000000000001011";    -- A000000B     NAPOMENA: konstante ovdje nisu ograničene na 20 bitova
        ConstSelection <= '1';
        command <= "0000";   -- ADD
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        -- 2.
        RegA <= "001";  -- R1
        RegWrite <= "010";  -- R2
        Const <= "10000000000000000000000000000001";    -- 80000001    NAPOMENA: konstante ovdje nisu ograničene na 20 bitova
        ConstSelection <= '1';
        command <= "0000";   -- ADD
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        -- 3.
        RegA <= "001";  -- R1
        RegB <= "010";  -- R2
        RegWrite <= "100";  -- R4
        ConstSelection <= '0';
        command <= "0001";   -- ADC
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 4.
        RegA <= "010";  -- R2
        RegB <= "100";  -- R4
        RegWrite <= "101";  -- R5
        ConstSelection <= '0';
        command <= "0010";   -- SUB
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        
        -- 5.
        RegA <= "101";  -- R5
        RegB <= "001";  -- R1
        RegWrite <= "110";  -- R6
        ConstSelection <= '0';
        command <= "0011";   -- SBC
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 6.
        RegA <= "110";  -- R6
        RegB <= "110";  -- R6
        ConstSelection <= '0';
        command <= "0100";   -- CMP
        writeEnable <= '0';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 7.
        RegA <= "100";  -- R4
        RegB <= "001";  -- R1
        RegWrite <= "111";  -- R7
        ConstSelection <= '0';
        command <= "0101";   -- AND
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 8.
        RegA <= "010";  -- R2
        RegB <= "111";  -- R7
        RegWrite <= "000";  -- R0
        ConstSelection <= '0';
        command <= "0110";   -- OR
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        -- 9.
        RegA <= "110";  -- R6
        RegB <= "101";  -- R5
        RegWrite <= "011";  -- R3
        ConstSelection <= '0';
        command <= "0111";   -- XOR
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        

        
        
        -- 10.
        RegA <= "001";  -- R1
        RegWrite <= "100";  -- R4
        ConstSelection <= '1';
        Const <= "00000000000000000000000000001010";    -- 10
        command <= "1000";   -- SHL
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 11.
        RegA <= "100";  -- R4
        RegWrite <= "101";  -- R5
        ConstSelection <= '1';
        Const <= "00000000000000000000000000001011";    -- 11
        command <= "1001";   -- SHR
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 12.
        RegA <= "000";  -- R0
        RegWrite <= "010";  -- R2
        ConstSelection <= '1';
        Const <= "00000000000000000000000000011011";    -- 27
        command <= "1010";   -- ASHR
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        
        
        -- 13.
        RegA <= "111";  -- R7
        RegWrite <= "111";  -- R7
        ConstSelection <= '1';
        Const <= "00000000000000000000000000000001";    -- 1
        command <= "1011";   -- ROTL
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar

        

        -- 14.
        RegA <= "111";  -- R7
        RegWrite <= "111";  -- R7
        ConstSelection <= '1';
        Const <= "00000000000000000000000000100000";    -- 32
        command <= "1100";   -- ROTR
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
        -- 15.
        RegA <= "011";  -- R3
        RegWrite <= "011";  -- R3
        ConstSelection <= '1';
        Const <= "00000000000000000000000000000011";    -- 3
        command <= "1011";   -- ROTL
        writeEnable <= '1';
        statusWriteEnable <= '1';
        
        wait for 10 ns;
        clk <= '1';
        wait for 5 ns;
        RegA <= "110";  -- R6
        RegB <= "101";  -- R5
        RegWrite <= "011";  -- R3
        ConstSelection <= '0';
        command <= "0111";   -- XOR
        writeEnable <= '1';
        statusWriteEnable <= '0';
        wait for 5 ns;
        clk <= '0';         -- Rezultat se upisuje u registar
        
    wait;
  end process;


end;