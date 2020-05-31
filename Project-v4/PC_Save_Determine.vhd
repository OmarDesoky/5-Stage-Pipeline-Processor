LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY PC_Save_Determine IS  
PORT (
	CURRENT_PC, UPDATED_PC :IN std_logic_vector(31 downto 0);
	IN_MIDDLE_OF_IMM, IF_ANY_JUMP, CLK:IN std_logic;
	PC_OUT 			:OUT  std_logic_vector(31 downto 0);
	old_executed 	:OUT  std_logic_vector(31 downto 0)
	);    
END ENTITY PC_Save_Determine;


ARCHITECTURE behavioral_flow OF PC_Save_Determine IS

--signal q1_SIG:std_logic_vector(31 downto 0);

signal q2_SIG:std_logic_vector(63 downto 0);
BEGIN   

process(clk, CURRENT_PC,IN_MIDDLE_OF_IMM, IF_ANY_JUMP)
-- variable q1_SIG:std_logic_vector(31 downto 0);
-- variable q2_SIG:std_logic_vector(63 downto 0);
begin 
if ((IN_MIDDLE_OF_IMM = '1') or (IF_ANY_JUMP = '1')) then
	PC_OUT <= q2_SIG(63 downto 32);
else 
	PC_OUT <= UPDATED_PC;
end if;
-- q1_SIG := UPDATED_PC;
if rising_edge (clk) then
	old_executed <= q2_SIG(63 downto 32);
end if;
q2_SIG(63 downto 32) <= q2_SIG(31 downto 0);
q2_SIG(31 downto 0) <= CURRENT_PC;
end process;


END behavioral_flow;