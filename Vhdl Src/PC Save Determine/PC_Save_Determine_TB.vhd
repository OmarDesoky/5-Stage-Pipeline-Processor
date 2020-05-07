LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY PC_Save_Determine_TB IS
-- No ports
END PC_Save_Determine_TB;
ARCHITECTURE PC_Save_Determine_TB_architecture OF PC_Save_Determine_TB IS
 -- Component declaration of the tested unit 

COMPONENT PC_Save_Determine IS  
PORT (
	CURRENT_PC, UPDATED_PC :IN std_logic_vector(31 downto 0);
	IN_MIDDLE_OF_IMM, IF_ANY_JUMP, CLK:IN std_logic;
	PC_OUT :OUT  std_logic_vector(31 downto 0));    
END COMPONENT;

COMPONENT Clock port (
clk_v : out std_logic
);
end COMPONENT ;

Signal clk_test, IN_MIDDLE_OF_IMM_test, IF_ANY_JUMP_test: std_logic;
signal CURRENT_PC_test, UPDATED_PC_test, PC_OUT_test:std_logic_vector(31 downto 0);   
 
BEGIN

ck : Clock PORT MAP (clk_test);
pc_selector : PC_Save_Determine port map (CURRENT_PC=>CURRENT_PC_test, UPDATED_PC=> UPDATED_PC_test, IN_MIDDLE_OF_IMM=> IN_MIDDLE_OF_IMM_test,
						IF_ANY_JUMP=> IF_ANY_JUMP_test, CLK=> clk_test, PC_OUT=> PC_OUT_test);
PROCESS 
BEGIN 
CURRENT_PC_test<="00000000000000000000000000000000";
UPDATED_PC_test<="00000000000000000000000000000001";
IN_MIDDLE_OF_IMM_test<= '0';
IF_ANY_JUMP_test<='0';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000001" then 
report "test case # 1 passed succesfully";
else 
report "you must take the updated pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000001";
UPDATED_PC_test<="00000000000000000000000000000010";
IN_MIDDLE_OF_IMM_test<= '0';
IF_ANY_JUMP_test<='0';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000010" then 
report "test case # 2 passed succesfully";
else 
report "you must take the updated pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000010";
UPDATED_PC_test<="00000000000000000000000000000011";
IN_MIDDLE_OF_IMM_test<= '1';
IF_ANY_JUMP_test<='0';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000001" then 
report "test case # 3 passed succesfully";
else 
report "you must take the old pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000011";
UPDATED_PC_test<="00000000000000000000000000000100";
IN_MIDDLE_OF_IMM_test<= '1';
IF_ANY_JUMP_test<='0';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000010" then 
report "test case # 4 passed succesfully";
else 
report "you must take the old pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000100";
UPDATED_PC_test<="00000000000000000000000000000101";
IN_MIDDLE_OF_IMM_test<= '0';
IF_ANY_JUMP_test<='0';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000101" then 
report "test case # 5 passed succesfully";
else 
report "you must take the updated pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000101";
UPDATED_PC_test<="00000000000000000000000000000110";
IN_MIDDLE_OF_IMM_test<= '0';
IF_ANY_JUMP_test<='1';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000100" then 
report "test case # 6 passed succesfully";
else 
report "you must take the old pc"SEVERITY ERROR;
end if;

CURRENT_PC_test<="00000000000000000000000000000110";
UPDATED_PC_test<="00000000000000000000000000000111";
IN_MIDDLE_OF_IMM_test<= '0';
IF_ANY_JUMP_test<='1';
wait for 0.1 ns;
if PC_OUT_test = "00000000000000000000000000000101" then 
report "test case # 7 passed succesfully";
else 
report "you must take the old pc"SEVERITY ERROR;
end if;
wait;
END PROCESS;
END PC_Save_Determine_TB_architecture;