LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY ForwardingUnit IS  
PORT (
	SRC1, SRC2, DST_MEM_WB, DST_EX_MEM, DST2_EX_MEM, DST2_MEM_WB:IN std_logic_vector(2 downto 0);
	SWAP_SIGNAL_EX_MEM, SWAP_SIGNAL_MEM_WB, WB_MEM_WB, WB_EX_MEM,MEM_OR_REG_MEM_WB,disable:IN std_logic;
	ENABLE_1ST_MUX, ENABLE_2ND_MUX:OUT  std_logic_vector(2 downto 0));    
END ENTITY ForwardingUnit;

ARCHITECTURE behavioral_flow OF ForwardingUnit IS
BEGIN   

process (disable,SRC1, SRC2, DST_MEM_WB, DST_EX_MEM,DST2_EX_MEM,DST2_MEM_WB, SWAP_SIGNAL_EX_MEM,SWAP_SIGNAL_MEM_WB, WB_MEM_WB, WB_EX_MEM)
begin
if disable = '0' then 
	if ((SRC1 = DST_EX_MEM) and (WB_EX_MEM = '1')) then
		ENABLE_1ST_MUX <= "001"; -- ALU OUT 1 FROM EX/MEM

	elsif ((SRC1 = DST2_EX_MEM) and (WB_EX_MEM = '1') and (SWAP_SIGNAL_EX_MEM = '1')) then
		ENABLE_1ST_MUX <= "010"; -- ALU OUT 2 FROM EX/MEM

	elsif ((SRC1 = DST_MEM_WB) and (WB_MEM_WB = '1') and (MEM_OR_REG_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '0')) then
		ENABLE_1ST_MUX <= "100"; -- MEM OUT FROM MEM/WB

	elsif ((SRC1 = DST_MEM_WB) and (WB_MEM_WB = '1') and (MEM_OR_REG_MEM_WB = '0') and (SWAP_SIGNAL_MEM_WB = '0')) then
		ENABLE_1ST_MUX <= "101"; -- MEM OUT FROM MEM/WB

	elsif ((SRC1 = DST_MEM_WB) and (WB_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '1')) then
		ENABLE_1ST_MUX <= "101"; -- ALU OUT 1 FROM MEM/WB

	elsif ((SRC1 = DST2_MEM_WB) and (WB_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '1')) then
		ENABLE_1ST_MUX <= "011"; -- ALU OUT 2 FROM MEM/WB

	else 
		ENABLE_1ST_MUX <= "000"; -- REG DATA 1
	end if;

	if ((SRC2 = DST_EX_MEM) and (WB_EX_MEM = '1')) then
		ENABLE_2ND_MUX <= "001"; -- ALU OUT 1 FROM EX/MEM

	elsif ((SRC2 = DST2_EX_MEM) and (WB_EX_MEM = '1') and (SWAP_SIGNAL_EX_MEM = '1')) then
		ENABLE_2ND_MUX <= "010"; -- ALU OUT 2 FROM EX/MEM

	elsif ((SRC2 = DST_MEM_WB) and (WB_MEM_WB = '1') and (MEM_OR_REG_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '0')) then
		ENABLE_2ND_MUX <= "100"; -- MEM OUT FROM MEM/WB

	elsif ((SRC2 = DST_MEM_WB) and (WB_MEM_WB = '1') and (MEM_OR_REG_MEM_WB = '0') and (SWAP_SIGNAL_MEM_WB = '0')) then
		ENABLE_2ND_MUX <= "101"; -- ALU OUT 1 FROM MEM/WB

	elsif ((SRC2 = DST_MEM_WB) and (WB_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '1')) then
		ENABLE_2ND_MUX <= "101"; -- ALU OUT 1 FROM MEM/WB

	elsif ((SRC2 = DST2_MEM_WB) and (WB_MEM_WB = '1') and (SWAP_SIGNAL_MEM_WB = '1')) then
		ENABLE_2ND_MUX <= "011"; -- ALU OUT 2 FROM MEM/WB

	else 
		ENABLE_2ND_MUX <= "000"; -- REG DATA 2 OR EA/IMM DEPEND ON THE DECISION TAKEN BY THE MUX
	end if;
else
	ENABLE_1ST_MUX <= "000";
	ENABLE_2ND_MUX <= "000";
end if;
end process;
END behavioral_flow;