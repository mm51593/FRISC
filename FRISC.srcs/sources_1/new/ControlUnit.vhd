----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/11/2021 11:02:47 PM
-- Design Name: 
-- Module Name: ControlUnit - Behavioral
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

entity ControlUnit is
    Port ( instruction: in STD_LOGIC_VECTOR(31 downto 0);
           waitsig: in STD_LOGIC := '0';
           clk: in STD_LOGIC;
           previous_condition: in STD_LOGIC;
           interrupt: in STD_LOGIC_VECTOR (1 downto 0);
           GIE: in STD_LOGIC;
           
           regin: out STD_LOGIC_VECTOR(1 downto 0);
           opbpick: out STD_LOGIC_VECTOR(1 downto 0);
           opcode: out STD_LOGIC_VECTOR(3 downto 0);
           pcinc: out STD_LOGIC := '0';
           pcpick: out STD_LOGIC_VECTOR(2 downto 0) := "101";
           drpick: out STD_LOGIC_VECTOR(1 downto 0);
           arpick: out STD_LOGIC_VECTOR(1 downto 0);
           pcdec: out STD_LOGIC := '0';
           gieselect: out STD_LOGIC;
           const: out STD_LOGIC_VECTOR(19 downto 0);
           size: out STD_LOGIC_VECTOR(1 downto 0);
           pcpicktest: out STD_LOGIC_VECTOR (2 downto 0);
           
           regA: out STD_LOGIC_VECTOR(2 downto 0);
           regB: out STD_LOGIC_VECTOR(2 downto 0);
           regwrite: out STD_LOGIC_VECTOR(2 downto 0);
           statusregwrite: out STD_LOGIC;
           statusregread: out STD_LOGIC;
           writeenable: out STD_LOGIC;
           statuswriteenable: out STD_LOGIC;
           conditionout: out STD_LOGIC_VECTOR(3 downto 0) := "0000";
           read: out STD_LOGIC := '0';
           write: out STD_LOGIC := '0'
           );
end ControlUnit;

architecture Behavioral of ControlUnit is
    signal constregout: STD_LOGIC_VECTOR(19 downto 0);
    signal reginreg: STD_LOGIC_VECTOR(1 downto 0);
    signal opbpickreg: STD_LOGIC_VECTOR(1 downto 0);
    signal opcodereg: STD_LOGIC_VECTOR(3 downto 0);
    signal pcincreg: STD_LOGIC;
    signal pcpickreg: STD_LOGIC_VECTOR(2 downto 0) := "101";
    signal drpickreg: STD_LOGIC_VECTOR(1 downto 0);
    signal arpickreg: STD_LOGIC_VECTOR(1 downto 0);
    signal pcdecreg: STD_LOGIC := '0';
    signal gieselectreg: STD_LOGIC;
    signal statusregwritereg: STD_LOGIC;
    signal statusregreadreg: STD_LOGIC;
    signal writeenablereg: STD_LOGIC;
    signal statuswriteenablereg: STD_LOGIC;
    signal conditionreg: STD_LOGIC_VECTOR(3 downto 0) := "0000";
    signal sizereg: STD_LOGIC_VECTOR(1 downto 0);
    
    signal regAreg: STD_LOGIC_VECTOR (2 downto 0);
    signal regBreg: STD_LOGIC_VECTOR (2 downto 0); 
    signal regRreg: STD_LOGIC_VECTOR (2 downto 0);
    
    signal count: STD_LOGIC := '0';
    signal step: STD_LOGIC := '0';
    signal halt: STD_LOGIC := '0';
    signal IIF: STD_LOGIC;
    
    signal constRegTemp: STD_LOGIC_VECTOR (31 downto 0);
    signal controlSignalRegTemp: STD_LOGIC_VECTOR (31 downto 0);
    
    type states is (state_fetch, state_decode, state_NMI, state_INT, state_step2, state_start);
    signal current_state: states := state_start;

begin
    constReg: entity work.risingEdgeRegister port map(d(19 downto 0) => instruction(19 downto 0), d(22 downto 20) => regAreg,
            d(25 downto 23) => regBreg, d(28 downto 26) => regRreg, d(31 downto 29) => "000", clk => clk, enable => '1',
            q(19 downto 0) => const, q(22 downto 20) => regA, q(25 downto 23) => regB, q(28 downto 26) => regwrite, 
            q(31 downto 29) => constRegTemp(31 downto 29));
    
    controlSignalsReg: entity work.risingEdgeRegister port map(
            d(1 downto 0) => reginreg, d(3 downto 2) => opbpickreg, d(7 downto 4) => opcodereg, d(8) => pcincreg, d(11 downto 9) => pcpickreg,
            d(13 downto 12) => drpickreg, d(15 downto 14) => arpickreg, d(16) => pcdecreg, d(17) => statusregwritereg,
            d(18) => statusregreadreg, d(19) => writeenablereg, d(20) => statuswriteenablereg, d(24 downto 21) => conditionreg, 
            d(25) => gieselectreg, d(31 downto 26) => "000000", clk => clk, enable => '1',
            q(1 downto 0) => regin, q(3 downto 2) => opbpick, q(7 downto 4) => opcode, q(8) => pcinc, q(11 downto 9) => pcpick,
            q(13 downto 12) => drpick, q(15 downto 14) => arpick, q(16) => pcdec, q(17) => statusregwrite, q(18) => statusregread,
            q(19) => writeenable, q(20) => statuswriteenable, q(24 downto 21) => conditionout, q(25) => gieselect, 
            q(31 downto 26) => controlSignalRegTemp(31 downto 26));
    
    pcpicktest <= pcpickreg;        
    process(clk, waitsig)
    begin
        if (falling_edge(clk) and waitsig = '0') then
            if (IIF = '1' and interrupt(1) = '1') then
                current_state <= state_NMI;
                
            elsif (IIF = '1' and GIE = '1' and interrupt(0) = '1') then
                current_state <= state_INT;
                
            else
                if (count = '0') then
                    current_state <= state_decode;
                else
                    current_state <= state_step2;
                end if;
                step <= not step;
            end if;
        end if;
        if (falling_edge(waitsig)) then
            current_state <= state_decode;
        end if;
    end process;
        
    process(instruction, current_state, step)
    begin
        if (current_state = state_fetch) then
            reginreg <= "00";
            opbpickreg <= "00";
            opcodereg <= "0000";
            pcincreg <= '0';
            pcpickreg <= "101";
            drpickreg <= "00";
            arpickreg <= "00";
            pcdecreg <= '0';
            statusregwritereg <= '0';
            statusregreadreg <= '0';
            writeenablereg <= '0';
            statuswriteenablereg <= '0';
            size <= "00";
            gieselectreg <= '0';
            
            read <= '1';
            
        --elsif (current_state = state_wait) then
        --    reginreg <= "00";
        --    opbpickreg <= "00";
        --    opcodereg <= "0000";
        --    pcincreg <= '0';
        --    pcpickreg <= "101";
        --    drpickreg <= "00";
        --    arpickreg <= "00";
        --    pcdecreg <= '0';
        --    statusregwritereg <= '0';
        --    statusregreadreg <= '0';
        --    writeenablereg <= '0';
        --    statuswriteenablereg <= '0';
        --    sizereg <= "00";
        --    gieselectreg <= '0';
            
        elsif (current_state = state_NMI) then
            reginreg <= "00";
            opbpickreg <= "00";
            opcodereg <= "0000";
            pcincreg <= '0';
            pcpickreg <= "101";
            drpickreg <= "00";
            arpickreg <= "00";
            pcdecreg <= '0';
            statusregwritereg <= '0';
            statusregreadreg <= '0';
            writeenablereg <= '0';
            statuswriteenablereg <= '0';
            sizereg <= "00";
            gieselectreg <= '0';
            
            IIF <= '0';
            
            conditionreg <= "0000";
            
        elsif (current_state = state_INT) then
            if (current_state /= state_step2) then
                reginreg    <= "00";
                opbpickreg <= "01";
                opcodereg <= "0000";
                pcincreg <= '0';
                pcpickreg <= "101";
                drpickreg <= "00";
                arpickreg <= "10";
                pcdecreg <= '0';
                statusregwritereg <= '0';
                statusregreadreg <= '0';
                writeenablereg <= '0';
                statuswriteenablereg <= '0';
                sizereg <= "00";
                gieselectreg <= '1';
                
                IIF <= '0';
                                
                count <= '1';
              
            else
                reginreg <= "00";
                opbpickreg <= "00";
                opcodereg <= "0000";
                pcincreg <= '0';
                pcpickreg <= "001";
                drpickreg <= "00";
                arpickreg <= "00";
                pcdecreg <= '0';
                statusregwritereg <= '0';
                statusregreadreg <= '0';
                writeenablereg <= '0';
                statuswriteenablereg <= '0';
                sizereg <= "00";
                gieselectreg <= '0';
                
                IIF <= '1';
                
                conditionreg <= "0000";
            end if;
            
        elsif (current_state = state_decode) then
            reginreg <= "00";
            opbpickreg <= "00";
            opcodereg <= "0000";
            pcincreg <= '0';
            pcpickreg <= "101";
            drpickreg <= "00";
            arpickreg <= "00";
            pcdecreg <= '0';
            statusregwritereg <= '0';
            statusregreadreg <= '0';
            writeenablereg <= '0';
            statuswriteenablereg <= '0';
            size <= "00";
            gieselectreg <= '0';
            
            read <= '1';
        case instruction(31 downto 26) is
            -- ALU instructions 
            -- ADD reg1 + reg2
            when "000000" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0000";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- ADD reg1 + const20
            when "000001" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0000";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- ADC reg1 + reg2 + C   
            when "000010" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0001";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- ADC reg1 + const20 + C
            when "000011" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0001";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- SUB reg1 - reg2
            when "000100" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0010";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    read <= '0';
                    write <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);

            -- SUB reg1 - const20
            when "000101" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0010";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- SBC reg1 - reg2 + C   
            when "000110" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0011";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);

            -- SBC reg1 - const20 + C
            when "000111" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0011";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- CMP reg1 - reg2  
            when "001000" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0100";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- CMP reg1 - const20
            when "001001" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0100";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- AND reg1 & reg2       
            when "001010" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0101";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);

            -- AND reg1 & const20                    
            when "001011" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0101";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- OR reg1 | reg2    
            when "001100" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0110";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
             
            -- OR reg1 | const20       
            when "001101" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0110";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- XOR reg1 ^ reg2   
            when "001110" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0111";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- XOR reg1 ^ const20
            when "001111" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "0111";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- SHL reg1 << reg2 
            when "010000" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1000";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
              
            -- SHL reg1 << const20      
            when "010001" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1000";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- SHR reg1 >> reg2
            when "010010" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1001";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);

            -- SHR reg1 >> const20                    
            when "010011" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1001";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- ASHR reg1 A>> reg2
            when "010100" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1010";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);

            -- ASHR reg1 A>> const20                    
            when "010101" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1010";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- ROTL reg1 R<< reg2
            when "010110" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1011";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- ROTL reg1 R<< const20
            when "010111" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1011";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
            
            -- ROTR reg1 R>> reg2
            when "011000" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1100";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- ROTR reg1 R>> const20
            when "011001" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1100";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regAreg <= instruction(22 downto 20);
                    regBreg <= instruction(19 downto 17);
                    
            -- MOVE
            -- MOVE src -> dest        
            when "011010" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1101";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regBreg <= instruction(22 downto 20);
                    
            when "011011" =>
                    reginreg <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1101";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    regBreg <= instruction(22 downto 20);
                    
            -- MOVE SR -> dest        
            when "011100" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0000";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '1';
                    writeenablereg <= '1';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regRreg <= instruction(25 downto 23);
                    
            -- MOVE src -> SR        
            when "011110" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "1101";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '1';
                    statusregreadreg <= '0';
                    writeenablereg <= '0';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regBreg <= instruction(25 downto 23);
                    
            when "011111" =>
                    reginreg    <= "00";
                    opbpickreg <= "01";
                    opcodereg <= "1100";
                    pcincreg <= '0';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '0';
                    statuswriteenablereg <= '1';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regBreg <= instruction(25 downto 23);
                    
            -- memory instructions
            -- LOAD
            when "100000" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        regAreg <= instruction(22 downto 20);
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            when "100001" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            -- STORE
            when "100010" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);    
                        
                        count <= '0';
                    end if;
                    
            when "100011" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);
                        
                        count <= '0';
                    end if;

            -- LOADH
            when "100100" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        regAreg <= instruction(22 downto 20);
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            when "100101" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            -- STOREH
            when "100110" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);    
                        
                        count <= '0';
                    end if;
                    
            when "100111" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);
                        
                        count <= '0';
                    end if;

            -- LOADB
            when "101000" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        regAreg <= instruction(22 downto 20);
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            when "101001" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "10";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "01";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;

            -- STOREB
            when "101010" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);    
                        
                        count <= '0';
                    end if;
                    
            when "101011" =>
                    if (count = '0') then   -- write to DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regBreg <= instruction(25 downto 23);
                        
                        count <= '1';
                    elsif (count = '1') then    -- write to AR
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "1101";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "10";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regBreg <= instruction(22 downto 20);
                        
                        count <= '0';
                    end if;


            -- PUSH
            when "101100" =>
                    if (count = '0') then   -- write into DR
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "10";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                    elsif (count = '1') then    -- write into AR
                        reginreg    <= "00";
                        opbpickreg <= "01";
                        opcodereg <= "0010";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '0';
                    end if;
                    
            -- POP
            when "101110" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0010";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        read <= '1';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg <= "10";
                        opbpickreg <= "01";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "000";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        regRreg <= instruction(25 downto 23);
                        
                        count <= '0';
                    end if;
                    
            -- control instuctions
            -- JP adr20
            when "110000" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0000";
                    pcincreg <= '0';
                    pcpickreg <= "010";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '0';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    conditionreg <= instruction(25 downto 22);
                    
            -- JP (adrreg)
            when "110001" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0000";
                    pcincreg <= '0';
                    pcpickreg <= "011";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '0';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    regBreg <= instruction(21 downto 19);
                    conditionreg <= instruction(25 downto 22);
                    
            -- JR PC + const20
            when "110010" =>
                    reginreg <= "00";
                    opbpickreg <= "00";
                    opcodereg <= "0000";
                    pcincreg <= '1';
                    pcpickreg <= "000";
                    drpickreg <= "00";
                    arpickreg <= "00";
                    pcdecreg <= '0';
                    statusregwritereg <= '0';
                    statusregreadreg <= '0';
                    writeenablereg <= '0';
                    statuswriteenablereg <= '0';
                    sizereg <= "00";
                    gieselectreg <= '0';
                    
                    conditionreg <= instruction(25 downto 22);
                    
            -- CALL adr20
            when "110100" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0010";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '1';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "010";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        count <= '0';
                    end if;
                    
            -- CALL (adrreg)
            when "110101" =>
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0010";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '1';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        write <= '1';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                    elsif (count = '1') then
                        reginreg    <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "011";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        sizereg <= "00";
                        gieselectreg <= '0';
                        
                        count <= '0';
                    end if;
                    
            -- RET
            when "110110" => 
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                        read <= '1';
                    elsif (count = '1') then
                        reginreg <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "001";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        
                        conditionreg <= "0000";
                        count <= '0';
                    end if;
                    
            -- RETI
            when "111000" => 
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                        read <= '1';
                    elsif (count = '1') then
                        reginreg <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "001";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '1';
                        
                        conditionreg <= "0000";
                        count <= '0';
                    end if;
                    
            -- RETN
            when "111010" => 
                    if (count = '0') then
                        reginreg    <= "00";
                        opbpickreg <= "10";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "101";
                        drpickreg <= "00";
                        arpickreg <= "01";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '1';
                        statuswriteenablereg <= '0';
                        
                        regAreg <= "111";
                        regRreg <= "111";
                        
                        count <= '1';
                        read <= '1';
                    elsif (count = '1') then
                        reginreg <= "00";
                        opbpickreg <= "00";
                        opcodereg <= "0000";
                        pcincreg <= '0';
                        pcpickreg <= "001";
                        drpickreg <= "00";
                        arpickreg <= "00";
                        pcdecreg <= '0';
                        statusregwritereg <= '0';
                        statusregreadreg <= '0';
                        writeenablereg <= '0';
                        statuswriteenablereg <= '0';
                        
                        IIF <= '1';
                        
                        conditionreg <= "0000";
                        count <= '0';
                    end if;
                    
            -- HALT
            when others =>
                reginreg <= "00";
                opbpickreg <= "00";
                opcodereg <= "0000";
                pcincreg <= '0';
                pcpickreg <= "101";
                drpickreg <= "00";
                arpickreg <= "00";
                pcdecreg <= '0';
                statusregwritereg <= '0';
                statusregreadreg <= '0';
                writeenablereg <= '0';
                statuswriteenablereg <= '0';
                sizereg <= "00";
                gieselectreg <= '0';
                
                halt <= '1';
        end case;
        end if;
    end process;
end Behavioral;
