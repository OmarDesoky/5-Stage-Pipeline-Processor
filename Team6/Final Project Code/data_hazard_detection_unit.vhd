LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY data_hazard_detection_unit IS  
PORT (
	SRC1, SRC2, DST:IN std_logic_vector(2 downto 0);
	MEM_READ_ID_EX, STALL_FOR_JUMP_PREDECTION, STALL_FOR_INT,enable:IN std_logic;
	INSERT_BUBBLE, PC_ENB, IF_ID_ENB:OUT  std_logic);    
END ENTITY data_hazard_detection_unit;

ARCHITECTURE behavioral_flow OF data_hazard_detection_unit IS
BEGIN   

process (enable,SRC1, SRC2, DST, MEM_READ_ID_EX, STALL_FOR_JUMP_PREDECTION, STALL_FOR_INT)
begin
IF (((SRC1 = DST) AND (MEM_READ_ID_EX = '1')) OR ((SRC2 = DST) AND (MEM_READ_ID_EX = '1')) OR (STALL_FOR_JUMP_PREDECTION  = '1') OR (STALL_FOR_INT ='1')) and (enable = '0')
THEN 
INSERT_BUBBLE <= '1';
PC_ENB <= '0';
IF_ID_ENB <='0';
ELSE 
INSERT_BUBBLE <= '0';
PC_ENB <= '1';
IF_ID_ENB <='1';
END IF;
end process;
END behavioral_flow;