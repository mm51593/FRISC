-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity Complete4_tb is
end;

architecture bench of Complete4_tb is

  component Complete4
      Port ( clk : in STD_LOGIC;
             interrupt: in STD_LOGIC_VECTOR (1 downto 0);
             breq: in STD_LOGIC;
             addressout : out STD_LOGIC_VECTOR (31 downto 0);
             dataout : out STD_LOGIC_VECTOR (31 downto 0);
             readout: out STD_LOGIC;
             writeout: out STD_LOGIC;
             waitsigout: out STD_LOGIC;
             sizeout: out STD_LOGIC_VECTOR (1 downto 0);
             instruction: out STD_LOGIC_VECTOR (31 downto 0);
             back: out STD_LOGIC;
             pcpick: out STD_LOGIC_VECTOR(31 downto 0);
             PCout: out STD_LOGIC_VECTOR(31 downto 0));
  end component;

  signal clk: STD_LOGIC := '1';
  signal interrupt: STD_LOGIC_VECTOR (1 downto 0);
  signal addressout: STD_LOGIC_VECTOR (31 downto 0);
  signal dataout: STD_LOGIC_VECTOR (31 downto 0);
  signal readout: STD_LOGIC;
  signal writeout: STD_LOGIC;
  signal waitsigout: STD_LOGIC;
  signal sizeout: STD_LOGIC_VECTOR (1 downto 0);
  signal instruction: STD_LOGIC_VECTOR (31 downto 0);
  signal pcpick: STD_LOGIC_VECTOR (31 downto 0);
  signal PCout: STD_LOGIC_VECTOR (31 downto 0);
  signal breq: STD_LOGIC;
  signal back: STD_LOGIC;

begin

  uut: Complete4 port map ( clk        => clk,
                           interrupt => interrupt,
                           addressout => addressout,
                           dataout    => dataout,
                           readout    => readout,
                           writeout   => writeout,
                           waitsigout => waitsigout,
                           sizeout => sizeout,
                           instruction => instruction,
                           pcpick=> pcpick,
                           PCout => PCout,
                           breq => breq,
                           back => back);

  stimulus: process
  begin
    breq <= '0';
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    breq <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    breq <= '0';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait for 10 ns;  
    clk <= '0';
    wait for 10 ns;
    clk <= '1';
    
    wait;
  end process;


end;