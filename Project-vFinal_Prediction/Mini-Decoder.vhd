library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.ALL;

entity MINI_DECODER is
 Port ( 
 instruction : 				in STD_LOGIC_VECTOR (15 downto 0);
 clk : 						in STD_LOGIC;
 reset : 					in STD_LOGIC;
 not_another_inst : 		out STD_LOGIC;
 fsm_take_decision : 		out STD_LOGIC;
 reg_src : 					out STD_LOGIC_VECTOR (2 downto 0);
 ret_rti_call_ready:		out STD_LOGIC;
 hazard_prediction_enb : 	out STD_LOGIC);
end MINI_DECODER;

architecture mini_decoder of MINI_DECODER is

signal counter 	: integer range 0 to 1;
signal counter2 : integer range 0 to 4;
signal old_instruction_sig : STD_LOGIC_VECTOR (15 downto 0);
signal old_opcode_sig : STD_LOGIC_VECTOR (4 downto 0);
signal old_instruction:std_logic_vector(31 downto 0);
signal old_opcode  	: std_logic_vector(9 downto 0);
signal opcode  : std_logic_vector(4 downto 0);
constant IADD : std_logic_vector(4 downto 0) := "00010";
constant SHL : std_logic_vector(4 downto 0) := "00000";
constant SHR : std_logic_vector(4 downto 0) := "00001";
constant LDM : std_logic_vector(4 downto 0) := "10010";
constant LDD : std_logic_vector(4 downto 0) := "10011";
constant STD : std_logic_vector(4 downto 0) := "10100";
constant JZ : std_logic_vector(4 downto 0) := "11000";
constant JMP : std_logic_vector(4 downto 0) := "11001";
constant CALL : std_logic_vector(4 downto 0) := "11010";
constant RET : std_logic_vector(4 downto 0) := "11110";
constant RTI : std_logic_vector(4 downto 0) := "11111";

begin
	process (clk,reset,instruction,opcode)
	-- variable old_instruction:std_logic_vector(31 downto 0);
	-- variable old_opcode  	: std_logic_vector(9 downto 0);
	begin
		old_instruction(31 downto 16) <= old_instruction(15 downto 0);
		old_instruction(15 downto 0) <= instruction;
		--old_instruction := instruction;
		old_opcode(9 downto 5) <= old_opcode(4 downto 0);
		old_opcode(4 downto 0) <= opcode;
		--old_opcode := opcode;
		old_opcode_sig <= old_opcode(9 downto 5);
		old_instruction_sig<=old_instruction(31 downto 16);
		opcode <= instruction(15 downto 11);
		if (reset = '1') then
			not_another_inst <= '0';
			fsm_take_decision <= '0';
			counter<=0;
			hazard_prediction_enb <= '0';
			ret_rti_call_ready<='0';
			reg_src <= "000";
		elsif(falling_edge(clk))then
			if (counter > 0) then 
				hazard_prediction_enb <= '0';
				counter<=0;
				not_another_inst <= '0';
				fsm_take_decision <= '1'; --don't care
				ret_rti_call_ready<='0';
			elsif(opcode =JZ or opcode = JMP) then
				reg_src <= instruction(7 downto 5);
				-- JZ
				if (opcode = JZ) then
					not_another_inst <= '1';
					fsm_take_decision <= '0';
					hazard_prediction_enb <= '1';
					ret_rti_call_ready<='0';
					
				-- JMP
				elsif (opcode = JMP) then
					not_another_inst <= '1';
					fsm_take_decision <= '1';
					hazard_prediction_enb <= '1';
					ret_rti_call_ready<='0';
				end if;
			elsif(opcode=IADD or opcode=SHL or opcode=SHR or opcode=LDM or opcode=LDD or opcode=STD) then
					not_another_inst <= '0';
					fsm_take_decision <= '1'; --don't care
					hazard_prediction_enb <= '0';
					ret_rti_call_ready<='0';
					counter<=1;
			--check old
			elsif(old_opcode_sig =JZ or old_opcode_sig = JMP) then
				reg_src <= old_instruction_sig(7 downto 5);
				not_another_inst <= '0';
				fsm_take_decision <= '1'; --don't care
				hazard_prediction_enb <= '0';
				ret_rti_call_ready<='0';
			-- Other Operation
			else
				not_another_inst <= '0';
				fsm_take_decision <= '1'; --don't care
				hazard_prediction_enb <= '0';
				ret_rti_call_ready<='0';

				--if (opcode=IADD or opcode=SHL or opcode=SHR or opcode=LDM or opcode=LDD or opcode=STD) then
					--skip next instruction
					--counter<=1;
				--elsif (opcode=CALL or opcode=RET or opcode=RTI) then
					--counter2<=1;
				--end if;
			end if;
		end if;
		-- old_instruction_sig <= instruction;
	end process;
end mini_decoder;