LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY TestBench IS
-- No ports
END TestBench;
ARCHITECTURE Forwarding_Unit_tb_architecture OF TestBench IS
 -- Component declaration of the tested unit 

COMPONENT ForwardingUnit IS  
PORT (
	SRC1, SRC2, DST_MEM_WB, DST_EX_MEM, DST2_EX_MEM, DST2_MEM_WB:IN std_logic_vector(2 downto 0);
	SWAP_SIGNAL_EX_MEM, SWAP_SIGNAL_MEM_WB, WB_MEM_WB, WB_EX_MEM:IN std_logic;
	ENABLE_1ST_MUX, ENABLE_2ND_MUX:OUT  std_logic_vector(2 downto 0));       
END COMPONENT;

Signal SRC1_test, SRC2_test, DST_MEM_WB_test, DST_EX_MEM_test, DST2_EX_MEM_test, DST2_MEM_WB_test: std_logic_vector (2 downto 0);
Signal SWAP_SIGNAL_EX_MEM_test, SWAP_SIGNAL_MEM_WB_test, WB_MEM_WB_test, WB_EX_MEM_test: std_logic;
Signal ENABLE_1ST_MUX_test, ENABLE_2ND_MUX_test: std_logic_vector (2 downto 0);

BEGIN

FU : ForwardingUnit PORT MAP ( SRC1 => SRC1_test, SRC2 =>SRC2_test , DST_MEM_WB => DST_MEM_WB_test, DST_EX_MEM => DST_EX_MEM_test,DST2_EX_MEM=> DST2_EX_MEM_test, 
			DST2_MEM_WB=> DST2_MEM_WB_test,SWAP_SIGNAL_EX_MEM=> SWAP_SIGNAL_EX_MEM_test,
			SWAP_SIGNAL_MEM_WB => SWAP_SIGNAL_MEM_WB_test, WB_MEM_WB=> WB_MEM_WB_test, WB_EX_MEM=> WB_EX_MEM_test, 
			ENABLE_1ST_MUX=> ENABLE_1ST_MUX_test, ENABLE_2ND_MUX=> ENABLE_2ND_MUX_test);

PROCESS 
BEGIN 
-- MUL R0, R1, R3;
-- ADD R2, R1, R3;
-- SUB R4, R2, R4;
SRC1_test <= "010";
SRC2_test <= "100";
DST_MEM_WB_test <= "000";
DST_EX_MEM_test <= "010";
DST2_EX_MEM_test <= "001";
DST2_MEM_WB_test <= "001";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="000") REPORT "[test case # 1]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =000" SEVERITY ERROR;

-- MUL R4, R1, R3;
-- ADD R2, R1, R3;
-- SUB R4, R2, R4;
SRC1_test <= "010";
SRC2_test <= "100";
DST_MEM_WB_test <= "100";
DST_EX_MEM_test <= "010";
DST2_EX_MEM_test <= "001";
DST2_MEM_WB_test <= "001";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test = "100") REPORT "[test case # 2]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test = 100" SEVERITY ERROR;

-- MUL R2, R1, R3;
-- ADD R0, R1, R3;
-- SUB R4, R2, R4;
SRC1_test <= "010";
SRC2_test <= "100";
DST_MEM_WB_test <= "010";
DST_EX_MEM_test <= "000";
DST2_EX_MEM_test <= "001";
DST2_MEM_WB_test <= "001";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "100" and ENABLE_2ND_MUX_test ="000") REPORT "[test case # 3]ENABLE_1ST_MUX_test = 100 and ENABLE_2ND_MUX_test =000" SEVERITY ERROR;

-- MUL R2, R1, R3;
-- ADD R0, R1, R3;
-- SUB R4, R1, R4;
SRC1_test <= "001";
SRC2_test <= "100";
DST_MEM_WB_test <= "010";
DST_EX_MEM_test <= "000";
DST2_EX_MEM_test <= "001";
DST2_MEM_WB_test <= "001";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "000" and ENABLE_2ND_MUX_test ="000") REPORT "[test case # 4]ENABLE_1ST_MUX_test = 000 and ENABLE_2ND_MUX_test =000" SEVERITY ERROR;

-- MUL R0, R1, R3;
-- SWAP R0, R4;
-- ADD R5, R4, R0;
SRC1_test <= "100";
SRC2_test <= "000";
DST_MEM_WB_test <= "000";
DST_EX_MEM_test <= "100";
DST2_EX_MEM_test <= "000";
DST2_MEM_WB_test <= "001";
SWAP_SIGNAL_EX_MEM_test <= '1';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="010") REPORT "[test case # 5]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =010" SEVERITY ERROR;

-- SWAP R0, R4;
-- MUL R1, R2, R3;
-- ADD R5, R1, R0;
SRC1_test <= "001";
SRC2_test <= "000";
DST_MEM_WB_test <= "100";
DST_EX_MEM_test <= "001";
DST2_EX_MEM_test <= "010";
DST2_MEM_WB_test <= "000";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '1';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="011") REPORT "[test case # 6]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =011" SEVERITY ERROR;

-- SWAP R0, R4;
-- MUL R1, R2, R3;
-- ADD R5, R1, R4;
SRC1_test <= "001";
SRC2_test <= "100";
DST_MEM_WB_test <= "100";
DST_EX_MEM_test <= "001";
DST2_EX_MEM_test <= "010";
DST2_MEM_WB_test <= "000";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '1';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="101") REPORT "[test case # 7]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =101" SEVERITY ERROR;

-- SWAP R0, R4;
-- MUL R1, R2, R3;
-- ADD R5, R0, R4;
SRC1_test <= "000";
SRC2_test <= "100";
DST_MEM_WB_test <= "100";
DST_EX_MEM_test <= "001";
DST2_EX_MEM_test <= "010";
DST2_MEM_WB_test <= "000";
SWAP_SIGNAL_EX_MEM_test <= '0';
SWAP_SIGNAL_MEM_WB_test <= '1';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "011" and ENABLE_2ND_MUX_test ="101") REPORT "[test case # 8]ENABLE_1ST_MUX_test = 011 and ENABLE_2ND_MUX_test =101" SEVERITY ERROR;

-- MUL R1, R2, R3;
-- SWAP R0, R4;
-- ADD R5, R0, R4;
SRC1_test <= "000";
SRC2_test <= "100";
DST_MEM_WB_test <= "001";
DST_EX_MEM_test <= "100";
DST2_EX_MEM_test <= "000";
DST2_MEM_WB_test <= "010";
SWAP_SIGNAL_EX_MEM_test <= '1';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "010" and ENABLE_2ND_MUX_test ="001") REPORT "[test case # 9]ENABLE_1ST_MUX_test = 010 and ENABLE_2ND_MUX_test =001" SEVERITY ERROR;

-- SWAP R0, R4;
-- SWAP R4, R0;
SRC1_test <= "100";
SRC2_test <= "000";
DST_MEM_WB_test <= "000";
DST_EX_MEM_test <= "100";
DST2_EX_MEM_test <= "000";
DST2_MEM_WB_test <= "000";
SWAP_SIGNAL_EX_MEM_test <= '1';
SWAP_SIGNAL_MEM_WB_test <= '0';
WB_MEM_WB_test <= '0';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="010") REPORT "[test case # 10]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =010" SEVERITY ERROR;

-- SWAP R0, R4;
-- SWAP R4, R0;
-- ADD R5, R0, R4
SRC1_test <= "000";
SRC2_test <= "100";
DST_MEM_WB_test <= "100";
DST_EX_MEM_test <= "000";
DST2_EX_MEM_test <= "100";
DST2_MEM_WB_test <= "000";
SWAP_SIGNAL_EX_MEM_test <= '1';
SWAP_SIGNAL_MEM_WB_test <= '1';
WB_MEM_WB_test <= '1';
WB_EX_MEM_test <= '1';
wait for 0.3 ns;
ASSERT(ENABLE_1ST_MUX_test = "001" and ENABLE_2ND_MUX_test ="010") REPORT "[test case # 11]ENABLE_1ST_MUX_test = 001 and ENABLE_2ND_MUX_test =010" SEVERITY ERROR;

wait;
END PROCESS;
END Forwarding_Unit_tb_architecture;