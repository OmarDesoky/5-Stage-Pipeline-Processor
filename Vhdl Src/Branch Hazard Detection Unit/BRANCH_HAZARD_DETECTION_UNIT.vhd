library IEEE;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity branch_hazard is 
port (
    clk : in std_logic;
    -- int : in std_logic;
	reset : in std_logic;
	
    op_code : in std_logic_vector(4 downto 0);
	rsrc_jmp : in std_logic_vector(2 downto 0);
	not_normal_op : in std_logic;
	jz : in std_logic;
	
	rdst_ifid : in std_logic_vector(2 downto 0);
	write_enable_ifid : in std_logic;
	
	rdst_idex : in std_logic_vector(2 downto 0);
	write_enable_idex : in std_logic;
	idex_read : in std_logic;
	
	rdst_exmem : in std_logic_vector(2 downto 0);
	write_enable_exmem : in std_logic;
	exmem_read : in std_logic;
	
    forward_alu : out std_logic;		-- 0 0 -> Registers
	forward_mem : out std_logic;		-- 0 1 -> memory_out
    stall : out std_logic);				-- 1 0 -> alu_ALU_out
end branch_hazard;						-- 1 1 -> memory_ALU_out

architecture hazardy of branch_hazard is
begin
process(clk, reset) is
begin
	if (jz = '1') then
		if ((rdst_ifid = rsrc_jmp) and (write_enable_ifid = '1')) then
			stall <= '1';
			forward_alu <= '0';
			forward_mem <= '0';
		elsif ((rdst_idex = rsrc_jmp) and(write_enable_idex = '1')) then
			if (idex_read = '1') then
				stall <= '1';
				forward_alu <= '0';
				forward_mem <= '0';
			else 
				stall <= '0';
				forward_alu <= '1';
				forward_mem <= '0';
			end if;
		elsif ((rdst_exmem = rsrc_jmp) and (write_enable_exmem = '1')) then
			if (exmem_read = '1') then
				stall <= '0';
				forward_alu <= '0';
				forward_mem <= '1';
			else 
				stall <= '0';
				forward_alu <= '1';
				forward_mem <= '1';
			end if;
		else 
			stall <= '0';
			forward_alu <= '0';
			forward_mem <= '0';
		end if;
	-- RET/RTI & SWAP (Left to be implemented once I understand them well)
	
		
	end if;
end process;
end hazardy;